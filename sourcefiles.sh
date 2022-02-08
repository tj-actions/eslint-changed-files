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

IFS=" " read -r -a FILES <<< "$(echo "${INPUT_FILES}" | awk -v d=" " '{s=(NR==1?s:s d)$0}END{print s}')"

# shellcheck disable=SC2199
if [[ ${IGNORED_FILES[@]:0} -ne 0 ]]; then
  ALL_FILES=("${FILES[@]}" "${IGNORED_FILES[@]}")
else
  ALL_FILES=("${FILES[@]}")
fi

echo "::set-output name=all_files::${ALL_FILES[*]}"
