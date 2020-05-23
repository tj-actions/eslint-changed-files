#!/bin/sh

set -e 

CONFIG_PATH=$1
IGNORE_PATH=$2
TARGET_BRANCH=$3

git fetch --depth=1 origin +refs/heads/$TARGET_BRANCH:refs/remotes/origin/$TARGET_BRANCH

CHANGED_FILES=$(git diff --diff-filter=ACM --name-only $(git merge-base origin/develop HEAD) | grep -E ".(js|jsx|ts|tsx)$$")

echo "## Running ESLint"
eslint --config=$CONFIG_PATH --ignore-path $IGNORE_PATH --max-warnings=0 $(CHANGED_FILES)
