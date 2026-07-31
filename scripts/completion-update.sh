#!/usr/bin/env bash

eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

DATAHOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
USER_COMPLETION_DIR="${DATAHOME}/bash-completion/completions"

# setup lazy loading for homebrew bash completions
mkdir -p "${USER_COMPLETION_DIR}"

# Link all legacy completion files
for completion in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
  echo "${completion}"
  # echo "$(readlink -f ${completion})"
	ln -s "${completion}" "${USER_COMPLETION_DIR}/"
done

# Link known completions with incorrect names to their correct names

## aws
ln -sf "${USER_COMPLETION_DIR}/aws_bash_completer" "${USER_COMPLETION_DIR}/aws"

## git
ln -sf "${USER_COMPLETION_DIR}/git-completion.bash" "${USER_COMPLETION_DIR}/git"

## hub
ln -sf "${USER_COMPLETION_DIR}/hub.bash_completion.sh" "${USER_COMPLETION_DIR}/hub"
