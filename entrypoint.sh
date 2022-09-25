#!/usr/bin/env bash

set -eu

echo "::group::eslint-changed-files"

if [[ -n $INPUT_PATH ]]; then
  REPO_DIR="$GITHUB_WORKSPACE/$INPUT_PATH"

  echo "Resolving repository path: $REPO_DIR"
  if [[ ! -d "$REPO_DIR" ]]; then
    echo "::error::Invalid repository path: $REPO_DIR"
    echo "::endgroup::"
    exit 1
  fi
  cd "$REPO_DIR"
fi

if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
  curl -sf -o ./formatter.cjs https://raw.githubusercontent.com/reviewdog/action-eslint/master/eslint-formatter-rdjson/index.js
fi

ESLINT_FORMATTER="./formatter.cjs"

# shellcheck disable=SC2034
export REVIEWDOG_GITHUB_API_TOKEN=$INPUT_TOKEN
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTRA_ARGS=$INPUT_EXTRA_ARGS
CONFIG_ARG=""

if [[ -n "$INPUT_CONFIG_PATH" ]]; then
  CONFIG_ARG="--config=${INPUT_CONFIG_PATH}"
fi

echo "Running ESlint on changed files..."
if [[ "$INPUT_ALL_FILES" == "true" ]]; then
  if [[ "$INPUT_SKIP_ANNOTATIONS" == "true" ]]; then
    if [[ -n ${IGNORE_PATH} ]]; then
      # shellcheck disable=SC2086
      npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} && exit_status=$? || exit_status=$?
    else
      # shellcheck disable=SC2086
      npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} && exit_status=$? || exit_status=$?
    fi
  elif [[ -n ${IGNORE_PATH} ]]; then
    # shellcheck disable=SC2086
    npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" && exit_status=$? || exit_status=$?
  else
    # shellcheck disable=SC2086
    npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" && exit_status=$? || exit_status=$?
  fi

  if [[ $exit_status -ne 0 ]]; then
    echo "::error::Error running eslint."
    echo "::endgroup::"
    exit 1;
  fi
else
  if [[ -n "${INPUT_CHANGED_FILES[*]}" ]]; then
      if [[ "$INPUT_SKIP_ANNOTATIONS" == "true" ]]; then
        if [[ -n ${IGNORE_PATH} ]]; then
          # shellcheck disable=SC2086
          npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} ${INPUT_CHANGED_FILES} && exit_status=$? || exit_status=$?
        else
          # shellcheck disable=SC2086
          npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} ${INPUT_CHANGED_FILES} && exit_status=$? || exit_status=$?
        fi
      elif [[ -n ${IGNORE_PATH} ]]; then
        # shellcheck disable=SC2086
        npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" ${INPUT_CHANGED_FILES} | reviewdog -f=rdjson \
          -name=eslint \
          -reporter="${INPUT_REPORTER}" \
          -filter-mode="${INPUT_FILTER_MODE}" \
          -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
          -level="${INPUT_LEVEL}" && exit_status=$? || exit_status=$?
      else
        # shellcheck disable=SC2086
        npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" ${INPUT_CHANGED_FILES} | reviewdog -f=rdjson \
          -name=eslint \
          -reporter="${INPUT_REPORTER}" \
          -filter-mode="${INPUT_FILTER_MODE}" \
          -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
          -level="${INPUT_LEVEL}" && exit_status=$? || exit_status=$?
      fi

      if [[ $exit_status -ne 0 ]]; then
        echo "::error::Error running eslint."
        echo "::endgroup::"
        exit 1;
      fi
  else
      echo "Skipping: No files to lint"
  fi
fi

if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
  rm -f ./formatter.cjs
fi

echo "::endgroup::"
