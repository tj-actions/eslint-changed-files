#!/usr/bin/env bash

set -e

echo "::group::eslint-changed-files"

if [[ -z $GITHUB_BASE_REF ]]; then
  echo "::warning::Skipping: This should only run on pull_request.";
  exit 0;
fi


GITHUB_TOKEN=$INPUT_TOKEN
CONFIG_PATH=$INPUT_CONFIG_PATH
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTENSIONS=${INPUT_EXTENSIONS// /}
EXTRA_ARGS=$INPUT_EXTRA_ARGS
EXCLUDED=()
MODIFIED_FILES=()
FILES=()
TARGET_BRANCH=$INPUT_REF

IFS=" " read -r -a EXCLUDED <<< "$(echo "$INPUT_EXCLUDE_PATH" | xargs)"

EXTENSIONS=${EXTENSIONS//,/|}

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"

echo "Getting base branch..."
echo "Getting head sha..."
if [[ $TARGET_BRANCH -eq $GITHUB_BASE_REF ]]; then
  git fetch --depth=1 origin "${TARGET_BRANCH}":"${TARGET_BRANCH}"
  HEAD_SHA=$(git rev-parse "${TARGET_BRANCH}" || true)

  if [[ -z $HEAD_SHA ]]; then
    echo "Error determining the HEAD SHA of: $TARGET_BRANCH"
    exit 1
  fi
else
  git fetch --depth=1 origin "$GITHUB_BASE_REF":"$GITHUB_BASE_REF"
  HEAD_SHA=$(git log $GITHUB_BASE_REF..$GITHUB_REF --oneline | tail -1 | cut -d' ' -f 1 || true)

  if [[ -z $HEAD_SHA ]]; then
    echo "::warning::Unable to determine the head sha"
    echo "::warning::You seem to be missing 'fetch-depth: 0'"
    exit 1
  fi
fi

echo "Using head sha ${HEAD_SHA} on ${TARGET_BRANCH}..."


echo "Retrieving modified files..."
IFS=" " read -r -a MODIFIED_FILES <<< "$(git diff --diff-filter=ACM --name-only "${HEAD_SHA}" | xargs || true)"

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
    if [[ -n ${IGNORE_PATH} ]]; then
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" --ignore-path "${IGNORE_PATH}" ${EXTRA_ARGS} $CHANGED_FILES
    else
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} $CHANGED_FILES
    fi
  fi
else
  echo "Skipping: No files to lint"
  echo "::endgroup::"
fi
