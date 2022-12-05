#!/usr/bin/env bash

set -euxo pipefail

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

TEMP_DIR=$(mktemp -d)
RD_JSON_FILE="$TEMP_DIR/rd.json"
ESLINT_FORMATTER="$TEMP_DIR/formatter.cjs"

if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
  curl -sf -o "$ESLINT_FORMATTER" https://raw.githubusercontent.com/reviewdog/action-eslint/master/eslint-formatter-rdjson/index.js
fi


# shellcheck disable=SC2034
export REVIEWDOG_GITHUB_API_TOKEN=$INPUT_TOKEN
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTRA_ARGS=$INPUT_EXTRA_ARGS
CONFIG_ARG=""

if [[ -n "$INPUT_CONFIG_PATH" ]]; then
  CONFIG_ARG="--config=${INPUT_CONFIG_PATH}"
fi

if [[ "$INPUT_ALL_FILES" == "true" ]]; then
  echo "Running ESlint on all files..."
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
    npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . > "$RD_JSON_FILE" && exit_status=$? || exit_status=$?
  else
    # shellcheck disable=SC2086
    npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . > "$RD_JSON_FILE" && exit_status=$? || exit_status=$?
  fi

  if [[ $exit_status -ne 0 ]]; then
    echo "::error::Error running eslint."
    if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
      cat "$RD_JSON_FILE"
      rm -f ./formatter.cjs
      rm -rf "$TEMP_DIR"
    fi
    echo "::endgroup::"
    exit 1;
  fi
else
  if [[ -n "${INPUT_CHANGED_FILES[*]}" ]]; then
      echo "Running ESlint on changed files..."
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
        npx eslint ${CONFIG_ARG} --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" ${INPUT_CHANGED_FILES} > "$RD_JSON_FILE" && exit_status=$? || exit_status=$?
      else
        # shellcheck disable=SC2086
        npx eslint ${CONFIG_ARG} ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" ${INPUT_CHANGED_FILES} > "$RD_JSON_FILE" && exit_status=$? || exit_status=$?
      fi

      if [[ $exit_status -ne 0 ]]; then
        echo "::error::Error running eslint."
        if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
          cat "$RD_JSON_FILE"
          rm -f ./formatter.cjs
          rm -rf "$TEMP_DIR"
        fi
        echo "::endgroup::"
        exit 1;
      fi
  else
      echo "Skipping: No files to lint"
  fi
fi

if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
  reviewdog -f=rdjson \
    -name=eslint \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" < "$RD_JSON_FILE"

  rm -f ./formatter.cjs
  rm -rf "$TEMP_DIR"
fi

echo "::endgroup::"
