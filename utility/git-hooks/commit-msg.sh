#!/usr/bin/env bash
. "$(dirname "$0")"/_config.sh

TASK_LINK_REGEX="(${TASK_LINK_PATTERN}|merge)"
ERROR_MESSAGE="\n ${RED}[ERROR] Commit failed.${NO_COLOR} The commit message doesn't reference a ${TASK_SOURCE} task in a valid format ('${TASK_LINK_SAMPLE}').\n\n"

if ! grep --extended-regexp --ignore-case --quiet "${TASK_LINK_REGEX}" "$1"; then
  printf "$ERROR_MESSAGE"
  exit 1
fi
