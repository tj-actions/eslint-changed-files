#!/bin/bash

set -e

if [[ -z $GITHUB_BASE_REF ]]; then
  echo "Skipping: This should only run on pull_request.";
  exit 0;
fi

GITHUB_TOKEN=$1
CONFIG_PATH=$2
IGNORE_PATH=$3
EXTENSIONS=$4
EXTRA_ARGS=$5
TARGET_BRANCH=${GITHUB_BASE_REF}
CURRENT_BRANCH=${GITHUB_HEAD_REF}

git remote set-url origin https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}

echo "Getting base branch..."
git config --local remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git config --local --add remote.origin.fetch "+refs/tags/*:refs/tags/*"
# git fetch origin --tags

git fetch --depth=1 origin ${TARGET_BRANCH}:${TARGET_BRANCH}

echo "Getting changed files..."

echo "Getting head sha..."
HEAD_SHA=$(git rev-parse ${TARGET_BRANCH} || true)
echo ${HEAD_SHA}

echo "Getting diffs..."
FILES=$(git diff --diff-filter=ACM --name-only ${HEAD_SHA} || true)

if [[ ! -z ${FILES} ]]; then
  echo "Filtering files..."
  EXPECTED_EXTENSIONS=$(echo $EXTENSIONS | sed 's/ //g' | sed 's/,/|/g')
  CHANGED_FILES=$(printf $(echo ${FILES} | sed 's| |\\n|g') | grep -E ".($EXPECTED_EXTENSIONS)$")
  if [[ -z ${CHANGED_FILES} ]]; then
    echo "Skipping: No files to lint"
    exit 0;
  else
    echo "Running ESLint on $CHANGED_FILES..."
    if [[ ! -z ${IGNORE_PATH} ]]; then
      npx eslint --config=${CONFIG_PATH} --ignore-path ${IGNORE_PATH} ${EXTRA_ARGS} ${CHANGED_FILES}
    else
      npx eslint --config=${CONFIG_PATH} ${EXTRA_ARGS} ${CHANGED_FILES}
    fi
  fi
fi
