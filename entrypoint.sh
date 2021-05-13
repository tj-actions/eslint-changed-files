#!/usr/bin/env bash

set -e

if [[ -z $GITHUB_BASE_REF ]]; then
  echo "Skipping: This should only run on pull_request.";
  exit 0;
fi

GITHUB_TOKEN=$1
CONFIG_PATH=$2
IGNORE_PATH=$3
EXTENSIONS=${4// /}
EXTRA_ARGS=$5
EXCLUDED=$6
TARGET_BRANCH=${GITHUB_BASE_REF}

EXTENSIONS=${EXTENSIONS//,/|}

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"

echo "Getting base branch..."
git fetch --depth=1 origin "${TARGET_BRANCH}":"${TARGET_BRANCH}"

echo "Getting changed files..."

echo "Getting head sha..."
HEAD_SHA=$(git rev-parse "${TARGET_BRANCH}" || true)

echo "Filtering files with \"${EXTENSIONS}\"... "

if [[ -n "${EXCLUDED}" ]]; then
  echo ""
  echo "Excluding files"
  echo "---------------"
  echo "${EXCLUDED}"
  echo "---------------"
  echo ""
  FILES=$(git diff --diff-filter=ACM --name-only "${HEAD_SHA}" | grep -Ev "${EXCLUDED//\n/|}" || true)
else
  FILES=$(git diff --diff-filter=ACM --name-only "${HEAD_SHA}" || true)
fi

FILES=${FILES// /\n}

if [[ -n ${FILES} ]]; then
  CHANGED_FILES=$(echo "${FILES}" | grep -E ".(${EXTENSIONS})$" || true)

  if [[ -z ${CHANGED_FILES} ]]; then
    echo "Skipping: No files to lint"
    exit 0;
  else
    echo ""
    echo "Running ESLint on..."
    echo "--------------------"
    echo "$CHANGED_FILES"
    echo "--------------------"
    echo ""
    if [[ ! -z ${IGNORE_PATH} ]]; then
      npx eslint --config="${CONFIG_PATH}" --ignore-path "${IGNORE_PATH}" "${EXTRA_ARGS}" "${CHANGED_FILES}"
    else
      npx eslint --config="${CONFIG_PATH}" "${EXTRA_ARGS}" "${CHANGED_FILES}"
    fi
  fi
fi
