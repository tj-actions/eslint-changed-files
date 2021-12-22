#!/usr/bin/env bash

set -eu

echo "::group::eslint-changed-files"

if [[ -z $GITHUB_BASE_REF ]]; then
  echo "::warning::Skipping: This should only run on pull_request.";
  exit 0;
fi

echo "Resolving repository path..."

if [[ -n $INPUT_PATH ]]; then
  REPO_DIR="$GITHUB_WORKSPACE/$INPUT_PATH"
  if [[ ! -d "$REPO_DIR" ]]; then
    echo "::warning::Invalid repository path"
    exit 1
  fi
  cd "$REPO_DIR"
fi

curl -sf -o ./formatter.js https://raw.githubusercontent.com/reviewdog/action-eslint/master/eslint-formatter-rdjson/index.js 

ESLINT_FORMATTER="./formatter.js"
GITHUB_TOKEN=$INPUT_TOKEN

# shellcheck disable=SC2034
export REVIEWDOG_GITHUB_API_TOKEN=$GITHUB_TOKEN
CONFIG_PATH=$INPUT_CONFIG_PATH
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTENSIONS=${INPUT_EXTENSIONS// /}
EXTRA_ARGS=$INPUT_EXTRA_ARGS
MODIFIED_FILES=()
TARGET_BRANCH=${GITHUB_BASE_REF}

EXTENSIONS=${EXTENSIONS//,/|}


if [[ "$INPUT_ALL_FILES" == "true" ]]; then
  if [[ -n ${IGNORE_PATH} ]]; then
    echo "Using ignore path: $IGNORE_PATH"
    # shellcheck disable=SC2086
    npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter=github-pr-review \
      -filter-mode=nofilter \
      -fail-on-error && exit_status=$? || exit_status=$?
  else
    # shellcheck disable=SC2086
    npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter=github-pr-review \
      -filter-mode=nofilter \
      -fail-on-error && exit_status=$? || exit_status=$?
  fi
  echo "::endgroup::"
else
  SERVER_URL=$(echo "$GITHUB_SERVER_URL" | awk -F/ '{print $3}')

  echo "Setting up 'temp_eslint_changed_files' remote..."

  git ls-remote --exit-code temp_eslint_changed_files 1>/dev/null 2>&1 && exit_status=$? || exit_status=$?

  if [[ $exit_status -ne 0 ]]; then
    echo "No 'temp_eslint_changed_files' remote found"
    echo "Creating 'temp_eslint_changed_files' remote..."
    git remote add temp_eslint_changed_files "https://${INPUT_TOKEN}@${SERVER_URL}/${GITHUB_REPOSITORY}"
  else
    echo "Found 'temp_eslint_changed_files' remote"
  fi

  echo "Getting HEAD info..."

  if [[ -z $GITHUB_SHA ]]; then
    CURR_SHA=$(git rev-parse HEAD 2>&1) && exit_status=$? || exit_status=$?
  else
    CURR_SHA=$GITHUB_SHA && exit_status=$? || exit_status=$?
  fi

  if [[ $exit_status -ne 0 ]]; then
    echo "::warning::Unable to determine the current head sha"
    git remote remove temp_eslint_changed_files
    exit 1;
  fi

  if [[ -z $GITHUB_BASE_REF ]]; then
    PREV_SHA=$(git rev-parse HEAD^1 2>&1) && exit_status=$? || exit_status=$?

    if [[ $exit_status -ne 0 ]]; then
      echo "::warning::Unable to determine the previous commit sha"
      echo "::warning::You seem to be missing 'fetch-depth: 0' or 'fetch-depth: 2'. See https://github.com/tj-actions/changed-files#usage"
      git remote remove temp_eslint_changed_files
      exit 1;
    fi
  else
    TARGET_BRANCH=${GITHUB_BASE_REF}
    git fetch --depth=1 temp_eslint_changed_files "${TARGET_BRANCH}":"${TARGET_BRANCH}"
    PREV_SHA=$(git rev-parse "${TARGET_BRANCH}" 2>&1) && exit_status=$? || exit_status=$?

    if [[ $exit_status -ne 0 ]]; then
      echo "::warning::Unable to determine the base ref sha for ${TARGET_BRANCH}"
      git remote remove temp_eslint_changed_files
      exit 1;
    fi
  fi

  echo "Retrieving changes between $PREV_SHA ($TARGET_BRANCH) → $CURR_SHA ($GITHUB_HEAD_REF)"

  IFS=" " read -r -a MODIFIED_FILES <<< "$(git diff --diff-filter=ACM --name-only "$PREV_SHA" "$CURR_SHA" | xargs || true)"

  if [[ -n "${MODIFIED_FILES[*]}" ]]; then
    echo ""
    echo "Changed files"
    echo "---------------"
    printf '%s\n' "${MODIFIED_FILES[@]}"
    echo "---------------"
    echo ""
    echo "Filtering files with \"${EXTENSIONS}\"... "
    CHANGED_FILES=$(printf '%s\n' "${MODIFIED_FILES[@]}" | grep -E ".(${EXTENSIONS})$" || true)

    if [[ -z ${CHANGED_FILES} ]]; then
      echo "Skipping: No files to lint"
      echo "::endgroup::"
      git remote remove temp_eslint_changed_files
      exit 0;
    else
      echo ""
      echo "Running ESLint on..."
      echo "--------------------"
      printf '%s\n' "${CHANGED_FILES[@]}"
      echo "--------------------"
      echo ""
      if [[ -n ${IGNORE_PATH} ]]; then
        echo "Using ignore path: $IGNORE_PATH"
        # shellcheck disable=SC2086
        npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" $CHANGED_FILES | reviewdog -f=rdjson \
          -name=eslint \
          -reporter=github-pr-review \
          -filter-mode=nofilter \
          -fail-on-error && exit_status=$? || exit_status=$?
      else
        # shellcheck disable=SC2086
        npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" $CHANGED_FILES | reviewdog -f=rdjson \
          -name=eslint \
          -reporter=github-pr-review \
          -filter-mode=nofilter \
          -fail-on-error && exit_status=$? || exit_status=$?
      fi
      echo "::endgroup::"

      if [[ $exit_status -ne 0 ]]; then
        echo "::warning::Error running eslint."
        exit 1;
      fi
      
      git remote remove temp_eslint_changed_files
    fi
  else
    echo "Skipping: No files to lint"
    echo "::endgroup::"
    git remote remove temp_eslint_changed_files
    exit 0;
  fi
fi
