#!/usr/bin/env bash

# Patch the bun bash completion script because of a bug in bun where re_comp_word_script is undefined
# See https://github.com/oven-sh/bun/issues/24847
# The file lives in bun's Cellar dir, so `brew upgrade bun` reverts this; re-run it after upgrading.
# Safe to re-run: an already patched file is left alone.

set -euo pipefail

COMPLETION_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion}/completions"
COMPLETION_FILE="${COMPLETION_DIR}/bun"

command -v bun > /dev/null || { echo "bun not installed, nothing to patch."; exit 0; }
[[ -e "${COMPLETION_FILE}" ]] || { echo "Error: ${COMPLETION_FILE} not found." >&2; exit 1; }

# edit the symlink target rather than replacing the symlink with a regular file
COMPLETION_FILE="$(readlink -f "${COMPLETION_FILE}")"

if grep -q 'return; local re_prev_script=' "${COMPLETION_FILE}"; then
  echo "Already patched: ${COMPLETION_FILE}"
  exit 0
fi

# -i.bak works with both GNU and BSD sed
sed -i.bak 's/local re_prev_script=/return; local re_prev_script=/' "${COMPLETION_FILE}"
rm -f "${COMPLETION_FILE}.bak"
echo "Patched: ${COMPLETION_FILE}"
