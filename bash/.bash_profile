#!/usr/bin/env bash

# shellcheck shell=bash

# uncomment to enable tracing output of your bash_profile to find loading issues
# exec 5> /tmp/profile-tracing.log
# BASH_XTRACEFD="5"
# set -x

if [[ "$(uname)" == "Darwin" ]]; then
  if [[ "$(arch)" == "arm64" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi
fi

# ble.sh
# shellcheck disable=SC1091
[[ -f ${HOME}/.blesh.load ]] && source "${HOME}/.blesh.load"

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
    alias colourify="$GRC -es --colour=auto"
    alias configure='colourify ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
      alias "$app"='colourify '$app
  done
fi

# set up fzf keybindings
# shellcheck disable=SC1091
[[ -f ~/.fzf.bash ]] && . "${HOME}/.fzf.bash"

# travis-cli
# shellcheck disable=SC1091
[[ -f "$HOME/.travis/travis.sh" ]] && . "${HOME}/.travis/travis.sh"

# asdf
# shellcheck disable=SC1091
ASDF_DIR="${HOMEBREW_PREFIX}/opt/asdf/libexec"
[[ -f "${ASDF_DIR}/asdf.sh" ]] && . "${ASDF_DIR}/asdf.sh"

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

##
## Completion
##

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# [[ -s "$HOME/.ssh/config" ]] && \
#   complete -o "default" -o "nospace" -W "$(awk '$1=="Host" {if ($2!="*"); for (i=2; i<=NF;i++){print $i}}' ~/.ssh/config)" scp sftp ssh
for file in "${HOME}/.ssh/config" "${HOME}"/.ssh/config.d/*; do
  if [[ -s "${file}" ]]; then
    hosts="$(awk '$1=="Host" {if ($2!="*"); for (i=2; i<=NF;i++){print $i}}' "${file}")"
    complete -o "default" -o "nospace" -W "${hosts}" scp sftp ssh
  fi
done
unset file

# system bash completion
# [[ -f "/etc/bash_completion" ]] && . /etc/bash_completion\\s

# enable homebrew bash_completion
if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck disable=SC1091
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
else
  # shellcheck disable=SC2312
  find "${HOMEBREW_PREFIX}/etc/bash_completion.d/" -not -type d -print0 \
  | while read -r -d $'\0' COMPLETION; do
    # shellcheck disable=SC1090
    [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
fi

# enable aws-cli completion
[[ -f "${HOMEBREW_PREFIX}/bin/aws_completer" ]] && complete -C aws_completer aws

# enable hugo completion
# [[ -f "$HOME/.hugo/hugo.sh" ]] && . "$HOME/.hugo/hugo.sh"

# enable vault completion
[[ -f "${HOMEBREW_PREFIX}/bin/vault" ]] && complete -C "${HOMEBREW_PREFIX}/bin/vault" vault

# enable git completion
[[ -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-completion.bash" ]] && . "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-completion.bash"

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# terraform complete
command -v terraform >/dev/null 2>&1 && complete -C "$(command -v terraform)" terraform tf

# gcloud
# shellcheck disable=SC1091,2154
if [[ -f ${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc ]]; then
  . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
  . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

# 1password completion
# shellcheck disable=SC1090,SC2015
command -v op >/dev/null 2>&1 && . <(op completion bash) || true

# dbt completion
# shellcheck disable=SC1091
[[ -f "${HOME}/.dbt-completion.bash" ]] && source "${HOME}/.dbt-completion.bash"

# start with kube-ps1 off
# export KUBE_PS1_ENABLED=off

# enable kube completion
if command -v kubectl >/dev/null 2>&1; then
  k8s_complete
  eval "$(complete -p kubectl | awk '{$NF="k"; print}')"
  command -v helm >/dev/null 2>&1 && helm_complete
  command -v kustomize >/dev/null 2>&1 && . <(kustomize completion bash)
fi

# 1password plugins
# shellcheck disable=SC1091
[[ -f "${HOME}/.config/op/plugins.sh" ]] && . "${HOME}/.config/op/plugins.sh"

# ble.sh
# shellcheck disable=SC1091
[[ -f "${HOME}/.blesh.start" ]] && source "${HOME}/.blesh.start"

# atuin
# atuin requires ble.sh above
# shellcheck disable=SC1091
[[ -f "${HOME}/.atuin.load" ]] && source "${HOME}/.atuin.load"

# source override last for overrides
# shellcheck disable=SC1091
[[ -f "${HOME}/.override" ]] && . "${HOME}/.override"

# uncomment to enable tracing output of your bash_profile to find loading issues
# set +x
# unset BASH_XTRACEFD
