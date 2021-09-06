#!/usr/bin/env bash

set -e

echo "::group::eslint-changed-files"

if [[ -z $GITHUB_BASE_REF ]]; then
  echo "::warning::Skipping: This should only run on pull_request.";
  exit 0;
fi

ESLINT_FORMATTER="formatter.js"
GITHUB_TOKEN=$INPUT_TOKEN
CONFIG_PATH=$INPUT_CONFIG_PATH
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTENSIONS=${INPUT_EXTENSIONS// /}
EXTRA_ARGS=$INPUT_EXTRA_ARGS
EXCLUDED=()
MODIFIED_FILES=()
FILES=()
TARGET_BRANCH=${GITHUB_BASE_REF}

IFS=" " read -r -a EXCLUDED <<< "$(echo "$INPUT_EXCLUDE_PATH" | xargs)"

EXTENSIONS=${EXTENSIONS//,/|}

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"

echo "Getting HEAD info..."

if [[ -z $GITHUB_SHA ]]; then
  CURR_SHA=$(git rev-parse HEAD 2>&1) && exit_status=$? || exit_status=$?
else
  CURR_SHA=$GITHUB_SHA
fi

if [[ $exit_status -ne 0 ]]; then
  echo "::warning::Unable to determine the current head sha"
  exit 1
fi

if [[ -z $GITHUB_BASE_REF ]]; then
  PREV_SHA=$(git rev-parse HEAD^1 2>&1) && exit_status=$? || exit_status=$?
  
  if [[ $exit_status -ne 0 ]]; then
    echo "::warning::Unable to determine the previous commit sha"
    echo "::warning::You seem to be missing 'fetch-depth: 0' or 'fetch-depth: 2'. See https://github.com/tj-actions/changed-files#usage"
    exit 1
  fi
else
  TARGET_BRANCH=${GITHUB_BASE_REF}
  git fetch --depth=1 origin "${TARGET_BRANCH}":"${TARGET_BRANCH}"
  PREV_SHA=$(git rev-parse "${TARGET_BRANCH}" 2>&1) && exit_status=$? || exit_status=$?
  
  if [[ $exit_status -ne 0 ]]; then
    echo "::warning::Unable to determine the base ref sha for ${TARGET_BRANCH}"
    exit 1
  fi
fi

echo "Retrieving changes between $PREV_SHA ($TARGET_BRANCH) → $CURR_SHA ($GITHUB_HEAD_REF)"

IFS=" " read -r -a MODIFIED_FILES <<< "$(git diff --diff-filter=ACM --name-only "$PREV_SHA" "$CURR_SHA" | xargs || true)"

if [[ -n "${EXCLUDED[*]}" && -n "${MODIFIED_FILES[*]}" ]]; then
  echo ""
  echo "Excluding files"
  echo "---------------"
  printf '%s\n' "${EXCLUDED[@]}"
  echo "---------------"
  EXCLUDED_REGEX=$(IFS="|"; echo "${EXCLUDED[*]}")

  for changed_file in "${MODIFIED_FILES[@]}"
  do
    # shellcheck disable=SC2143
    if [[ -z "$(echo "$changed_file" | grep -iE "(${EXCLUDED_REGEX})")" ]]; then
      FILES+=("$changed_file")
    fi
  done
else
  IFS=" " read -r -a FILES <<< "$(echo "${MODIFIED_FILES[*]}" | xargs)"
fi

if [[ -n "${FILES[*]}" ]]; then
  echo ""
  echo "Changed files"
  echo "---------------"
  printf '%s\n' "${FILES[@]}"
  echo "---------------"
  echo ""
  echo "Filtering files with \"${EXTENSIONS}\"... "
  CHANGED_FILES=$(printf '%s\n' "${FILES[@]}" | grep -E ".(${EXTENSIONS})$" || true)

  if [[ -z ${CHANGED_FILES} ]]; then
    echo "Skipping: No files to lint"
    echo "::endgroup::"
    exit 0;
  else
    echo ""
    echo "Running ESLint on..."
    echo "--------------------"
    printf '%s\n' "${CHANGED_FILES[@]}"
    echo "--------------------"
    echo ""
    echo "::endgroup::"
    if [[ ! -z ${IGNORE_PATH} ]]; then
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" --ignore-path "${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" $CHANGED_FILES | reviewdog -f=rdjson \
        -name="eslint" \
        -reporter="github-pr-review" \
        -filter-mode="added" \
        -fail-on-error="true" \
        -level="error"
    else
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" $CHANGED_FILES | reviewdog -f=rdjson \
        -name="eslint" \
        -reporter="github-pr-review" \
        -filter-mode="added" \
        -fail-on-error="true" \
        -level="error"
    fi
  fi
else
  echo "Skipping: No files to lint"
  echo "::endgroup::"
fi
