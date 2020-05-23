#!/bin/sh

set -e

if [ -z $GITHUB_BASE_REF ]; then
  echo "This should only run on pull_request.";
  exit 0;
fi

GITHUB_TOKEN=$1
CONFIG_PATH=$2
IGNORE_PATH=$3
TARGET_BRANCH=$GITHUB_BASE_REF
CURRENT_BRANCH=$GITHUB_HEAD_REF


echo "${GITHUB_TOKEN}"
echo "${CONFIG_PATH}"
echo "${IGNORE_PATH}"
echo "${TARGET_BRANCH}"
echo "${CURRENT_BRANCH}"
echo "${GITHUB_REPOSITORY}"
echo "----------------------"


git remote set-url origin https://$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY

echo "Getting base branch..."
git fetch --depth=1 origin +refs/heads/$TARGET_BRANCH:refs/remotes/origin/$TARGET_BRANCH

echo "Getting changed files..."

CHANGED_FILES=$(git diff --diff-filter=ACM --name-only $(git merge-base origin/$TARGET_BRANCH HEAD) | grep -E ".(js|jsx|ts|tsx)$$")

echo "## Running ESLint"
if [[ ! -z $IGNORE_PATH ]]; then
  eslint --config=$CONFIG_PATH --ignore-path $IGNORE_PATH --max-warnings=0 $(CHANGED_FILES)
else
  eslint --config=$CONFIG_PATH --max-warnings=0 $(CHANGED_FILES)
fi
