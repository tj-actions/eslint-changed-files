#!/usr/bin/env bash

set -eu

echo "::group::eslint-changed-files"

if [[ "$INPUT_SKIP_ANNOTATIONS" != "true" ]]; then
  curl -sf -o ./formatter.cjs https://raw.githubusercontent.com/reviewdog/action-eslint/master/eslint-formatter-rdjson/index.js
fi

ESLINT_FORMATTER="./formatter.cjs"
GITHUB_TOKEN=$INPUT_TOKEN

# shellcheck disable=SC2034
export REVIEWDOG_GITHUB_API_TOKEN=$GITHUB_TOKEN
CONFIG_PATH=$INPUT_CONFIG_PATH
IGNORE_PATH=$INPUT_IGNORE_PATH
EXTRA_ARGS=$INPUT_EXTRA_ARGS


if [[ "$INPUT_ALL_FILES" == "true" ]]; then
  if [[ "$INPUT_SKIP_ANNOTATIONS" == "true" ]]; then
    if [[ -n ${IGNORE_PATH} ]]; then
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} && exit_status=$? || exit_status=$?
    else
      # shellcheck disable=SC2086
      npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} && exit_status=$? || exit_status=$?
    fi
  elif [[ -n ${IGNORE_PATH} ]]; then
    # shellcheck disable=SC2086
    npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter=$INPUT_REPORTER \
      -filter-mode=$INPUT_FILTER_MODE \
      -fail-on-error && exit_status=$? || exit_status=$?
  else
    # shellcheck disable=SC2086
    npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" . | reviewdog -f=rdjson \
      -name=eslint \
      -reporter=$INPUT_REPORTER \
      -filter-mode=$INPUT_FILTER_MODE \
      -fail-on-error && exit_status=$? || exit_status=$?
  fi

  echo "::endgroup::"

  if [[ $exit_status -ne 0 ]]; then
    echo "::warning::Error running eslint."
    exit 1;
  fi
else
  if [[ -n "${INPUT_CHANGED_FILES[*]}" ]]; then
      if [[ "$INPUT_SKIP_ANNOTATIONS" == "true" ]]; then
        if [[ -n ${IGNORE_PATH} ]]; then
          # shellcheck disable=SC2086
          npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} "${INPUT_CHANGED_FILES[@]}" && exit_status=$? || exit_status=$?
        else
          # shellcheck disable=SC2086
          npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} "${INPUT_CHANGED_FILES[@]}" && exit_status=$? || exit_status=$?
        fi
      elif [[ -n ${IGNORE_PATH} ]]; then
        # shellcheck disable=SC2086
        npx eslint --config="${CONFIG_PATH}" --ignore-path="${IGNORE_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" "${INPUT_CHANGED_FILES[@]}" | reviewdog -f=rdjson \
          -name=eslint \
          -reporter=$INPUT_REPORTER \
          -filter-mode=$INPUT_FILTER_MODE \
          -fail-on-error && exit_status=$? || exit_status=$?
      else
        # shellcheck disable=SC2086
        npx eslint --config="${CONFIG_PATH}" ${EXTRA_ARGS} -f="${ESLINT_FORMATTER}" "${INPUT_CHANGED_FILES[@]}" | reviewdog -f=rdjson \
          -name=eslint \
          -reporter=$INPUT_REPORTER \
          -filter-mode=$INPUT_FILTER_MODE \
          -fail-on-error && exit_status=$? || exit_status=$?
      fi
      echo "::endgroup::"

      if [[ $exit_status -ne 0 ]]; then
        echo "::warning::Error running eslint."
        exit 1;
      fi
  else
      echo "Skipping: No files to lint"
      echo "::endgroup::"
      exit 0;
  fi
fi
