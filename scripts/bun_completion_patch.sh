#!/usr/bin/env bash

COMPLETION_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.config}/bash-completion/completions}"

# shellcheck disable=SC2016
if command -v bun >/dev/null 2>&1; then
    COMPLETION_FILE="${COMPLETION_DIR}/bun"
    # Edit the symlink target rather than replacing the symlink with a regular file.
    # Prefer GNU sed; BSD sed (macOS) has no --follow-symlinks and requires an explicit empty extension for -i
    if command -v gsed >/dev/null 2>&1; then
        SED_INPLACE=(gsed -i --follow-symlinks)
    else
        SED_INPLACE=(sed -i '')
        COMPLETION_FILE=$(readlink -f "${COMPLETION_FILE}")
    fi
    # Patch the bun completion script because of a bug in bun where re_comp_word_script is undefined
    # See https://github.com/oven-sh/bun/issues/24847
    "${SED_INPLACE[@]}" "s/local re_prev_script=/return; local re_prev_script=/" "${COMPLETION_FILE}"
fi
