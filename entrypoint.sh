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
TARGET_BRANCH=${GITHUB_BASE_REF}

IFS=" " read -r -a EXCLUDED <<< "$(echo "$INPUT_EXCLUDE_PATH" | xargs)"

EXTENSIONS=${EXTENSIONS//,/|}

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"

echo "Getting base branch..."
git fetch --depth=1 origin "${TARGET_BRANCH}":"${TARGET_BRANCH}"

echo "Getting head sha..."
HEAD_SHA=$(git rev-parse "${TARGET_BRANCH}" || true)

echo "Using head sha ${HEAD_SHA}..."

echo "Retrieving modified files..."
CHANGED_FILES=$(git diff --diff-filter=ACM --name-only "${HEAD_SHA}" || true)
FILES=()

if [[ -n "${EXCLUDED}" ]]; then
  echo ""
  echo "Excluding files"
  echo "---------------"
  printf '%s\n' "${EXCLUDED[@]}"
  echo "---------------"
  for path in ${EXCLUDED[@]}
  do
    for file in "${CHANGED_FILES[@]}"
    do
      if [[ ! "${file}" =~ $path ]]; then
        FILES+=("$file")
      fi
    done
  done
fi

FILES=${FILES// /\n}

if [[ -n ${FILES} ]]; then
  echo "Filtering files with \"${EXTENSIONS}\"... "
  CHANGED_FILES=$(echo "${FILES}" | grep -E ".(${EXTENSIONS})$" || true)

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
