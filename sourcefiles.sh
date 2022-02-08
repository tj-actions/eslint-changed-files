#!/usr/bin/env bash

set -eu

IGNORED_FILES=()

if [[ -n $INPUT_IGNORE_PATH ]]; then
  for file in $INPUT_IGNORE_PATH
  do
    while read -r fileName; do
      IGNORED_FILES+=("!$fileName")
    done <"$file"
  done
fi

IFS=$'\n' read -r -d '' -a FILES <<< "$INPUT_FILES"

ALL_FILES=("${FILES[@]}" "${IGNORED_FILES[@]}")

echo "::set-output name=all_files::${ALL_FILES[*]}"
