#!/usr/bin/env bash

# Environment
export TZ=US/Eastern
export EDITOR=$(which vim)

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# append to history file, don't overwrite
shopt -s histappend
# ignore duplicate lines
export HISTCONTROL=ignoredupes:ignorespace
# Larger bash history (32^3 entries)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
# set timestamps
export HISTTIMEFORMAT='%F %T '

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Add brew coreutils to $PATH
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# system bash completion
[ -f /etc/bash_completion ] && source /etc/bash_completion

# enable homebrew bash_completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi
# Load bash aliases if they exist
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Load bash_functions if they exist
if [ -f "$HOME/.bash_functions" ]; then
  . "$HOME/.bash_functions"
fi