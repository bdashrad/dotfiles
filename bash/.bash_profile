#!/usr/bin/env bash

# shellcheck shell=bash

# uncomment to enable tracing output of your bash_profile to find loading issues
# exec 5> /tmp/profile-tracing.log
# BASH_XTRACEFD="5"
# set -x

# ble.sh
# shellcheck disable=SC1091
[[ -f ${HOME}/.blesh.load ]] && source "${HOME}/.blesh.load"


if [[ "$(uname)" == "Darwin" ]]; then
  if [[ "$(arch)" == "arm64" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi
fi
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# shellcheck disable=SC1090
for file in ${HOME}/.{extra,bash_prompt,path,exports,aliases,functions}; do
  [[ -f "${file}" ]] && [[ -r "${file}" ]] && . "${file}"
done
unset file

# to help sublimelinter etc with finding my PATHS
case $- in
  *i*) [[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
  ;;

  *)
  ;;
esac

if type shopt &> /dev/null; then
  # append to history file, don't overwrite
  shopt -s histappend

  # Save multi-line commands as one command
  shopt -s cmdhist

  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob

  # Auto-correct typos in path names when using `cd`
  shopt -s cdspell

  # Autocorrect on directory names to match a glob.
  # shopt -s dirspell
fi

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
# bind Space:magic-space

# Save and reload the history after each command finishes
# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Load the default .profile
# [ -s "$HOME/.profile" ] && . "$HOME/.profile"

# z beats cd most of the time.
#  github.com/rupa/z
# shellcheck disable=SC1091
[[ -s "${HOMEBREW_PREFIX}/etc/profile.d/z.sh" ]] && . "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"

# grc colorizing
# shellcheck disable=SC1091
[[ -e "${HOMEBREW_PREFIX}/etc/grc.bashrc" ]] && . "${HOMEBREW_PREFIX}/etc/grc.bashrc"

# generic colouriser
GRC=$(command -v grc)
if [[ "${TERM}" != dumb ]] && [[ -n "${GRC}" ]]
  then
    # shellcheck disable=SC2139
    alias colourify="${GRC} -es --colour=auto"
    alias configure='colourify ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
      # shellcheck disable=SC2139
      alias "${app}"='colourify '${app}
  done
fi

# # use local folder for CPAN instead of homebrew cellar
# eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# # Start GPG agent
# if [[ -f ~/.gnupg/.gpg-agent-info && -n "$(pgrep gpg-agent)" ]]; then
#   . "$HOME/.gnupg/.gpg-agent-info"
#   export GPG_AGENT_INFO
#   GPG_TTY=$(tty)
#   export GPG_TTY
# else
#   eval $(gpg-agent --daemon)
# fi

# start with kube-ps1 off
# export KUBE_PS1_ENABLED=off

# 1password plugins
# shellcheck disable=SC1091
[[ -f "${HOME}/.config/op/plugins.sh" ]] && . "${HOME}/.config/op/plugins.sh"

# shell completion
# shellcheck disable=SC1091
[[ -f "${HOME}/.completion" ]] && . "${HOME}/.completion"

# # set up fzf keybindings
# # shellcheck disable=SC1091
# [[ -f "${HOME}/.fzf.bash" ]] && . "${HOME}/.fzf.bash"

# atuin
# atuin requires ble.sh above
# shellcheck disable=SC1091
[[ -f "${HOME}/.atuin.load" ]] && source "${HOME}/.atuin.load"

# source override last for overrides
# shellcheck disable=SC1091
[[ -f "${HOME}/.override" ]] && . "${HOME}/.override"

# ble.sh
# shellcheck disable=SC1091
[[ -f "${HOME}/.blesh.start" ]] && source "${HOME}/.blesh.start"


# uncomment to enable tracing output of your bash_profile to find loading issues
# set +x
# unset BASH_XTRACEFD
