#!/bin/sh

set -e 

CONFIG_PATH=$INPUT_CONFIG-PATH
IGNORE_PATH=$INPUT_IGNORE-PATH
TARGET_BRANCH=$GITHUB_BASE_REF


echo ${INPUT_CONFIG-PATH}
echo ${INPUT_IGNORE-PATH}
echo ${GITHUB_BASE_REF}
env

git fetch --depth=1 origin +refs/heads/$TARGET_BRANCH:refs/remotes/origin/$TARGET_BRANCH

CHANGED_FILES=$(git diff --diff-filter=ACM --name-only $(git merge-base origin/$TARGET_BRANCH HEAD) | grep -E ".(js|jsx|ts|tsx)$$")

echo "## Running ESLint"
if [[ ! -z $IGNORE_PATH ]]; then
  eslint --config=$CONFIG_PATH --ignore-path $IGNORE_PATH --max-warnings=0 $(CHANGED_FILES)
else
  eslint --config=$CONFIG_PATH --max-warnings=0 $(CHANGED_FILES)
fi
