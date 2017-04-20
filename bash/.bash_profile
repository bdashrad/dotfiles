#!/usr/bin/env bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{extra,path,exports,aliases,functions,bash_prompt}; do
  [ -f "$file" ] && [ -r "$file" ] && . "$file"
done
unset file

# to help sublimelinter etc with finding my PATHS
case $- in
  *i*) source ~/.extra
esac

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

if type shopt &> /dev/null; then
  # append to history file, don't overwrite
  shopt -s histappend

  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob

  # Auto-correct typos in path names when using `cd`
  shopt -s cdspell
fi

# Load the default .profile
[[ -s "$HOME/.profile" ]] && . "$HOME/.profile"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# z beats cd most of the time.
#  github.com/rupa/z
[[ -s "$HOME/bin/z/z.sh" ]] && . ~/bin/z/z.sh

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -s "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# system bash completion
[[ -f "/etc/bash_completion" ]] && . /etc/bash_completion

# enable homebrew bash_completion
[[ -f "$(brew --prefix)/etc/bash_completion" ]] && . "$(brew --prefix)/etc/bash_completion"
#[[ -e "$(brew --prefix)/share/bash-completion/bash_completion" ]] && . "$(brew --prefix)/share/bash-completion/bash_completion"

# enable aws-cli completion
[ -f "/usr/local/bin/aws_completer" ] && complete -C aws_completer aws

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# grc colorizing
[[ -e "$(brew --prefix)/etc/grc.bashrc" ]] && . "$(brew --prefix)/etc/grc.bashrc"

# include .bashrc if it exists
#[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# set up fzf keybindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# use local folder for CPAN instead of homebrew cellar
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
