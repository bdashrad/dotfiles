#!/usr/bin/env bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && . "$file"
done
unset file

# append to history file, don't overwrite
shopt -s histappend

# Load the default .profile
[[ -s "$HOME/.profile" ]] && . "$HOME/.profile"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# set PATH so it includes user's private bin if it exists
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -s "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# system bash completion
[[ -e /etc/bash_completion ]] && . /etc/bash_completion

# enable homebrew bash_completion
[[ -e $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion

# enable aws-cli completion
[ -f "/usr/local/bin/aws_completer" ] && complete -C aws_completer aws

# include .bashrc if it exists
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
