#!/usr/bin/env bash

export BREWPATH=$(brew --prefix)

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ${HOME}/.{extra,path,exports,aliases,functions,bash_prompt}; do
  [ -f "$file" ] && [ -r "$file" ] && . "$file"
done
unset file

# to help sublimelinter etc with finding my PATHS
case $- in
  *i*) [ -f "~/.extra" ] && source ~/.extra
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
  shopt -s dirspell
fi

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Save and reload the history after each command finishes
# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Load the default .profile
# [ -s "$HOME/.profile" ] && . "$HOME/.profile"

# Load RVM into a shell session *as a function*
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

# z beats cd most of the time.
#  github.com/rupa/z
[ -s "${BREWPATH}/etc/profile.d/z.sh" ] && . "${BREWPATH}/etc/profile.d/z.sh"

# grc colorizing
[ -e "${BREWPATH}/etc/grc.bashrc" ] && . "${BREWPATH}/etc/grc.bashrc"

# generic colouriser
GRC=$(command -v grc)
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
  then
    alias colourify="$GRC -es --colour=auto"
    alias configure='colourify ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
      alias "$app"='colourify '$app
  done
fi

# include .bashrc if it exists
#[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# set up fzf keybindings
[ -f ~/.fzf.bash ] && . "$HOME/.fzf.bash"

# use local folder for CPAN instead of homebrew cellar
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# Start GPG agent
if [[ -f ~/.gnupg/.gpg-agent-info && -n "$(pgrep gpg-agent)" ]]; then
  . "$HOME/.gnupg/.gpg-agent-info"
  export GPG_AGENT_INFO
  GPG_TTY=$(tty)
  export GPG_TTY
else
  eval $(gpg-agent --daemon)
fi

##
## Competion
##

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -s "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# system bash completion
[ -f "/etc/bash_completion" ] && . /etc/bash_completion

# enable homebrew bash_completion
[ -f "${BREWPATH}/etc/bash_completion" ] && . "${BREWPATH}/etc/bash_completion"
[ -r "${BREWPATH}/etc/profile.d/bash_completion.sh" ] && . "${BREWPATH}/etc/profile.d/bash_completion.sh"
#[ -e "${BREWPATH}/share/bash-completion/bash_completion" ] && . "${BREWPATH}/share/bash-completion/bash_completion"

# enable aws-cli completion
[ -f "${BREWPATH}/bin/aws_completer" ] && complete -C aws_completer aws

# enable hugo completion
[ -f "$HOME/.hugo/hugo.sh" ] && . "$HOME/.hugo/hugo.sh"

# enable vault completion
[ -f "${BREWPATH}/bin/vault" ] && complete -C "${BREWPATH}/bin/vault" vault

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# travis completion
[ -f ~/.travis/travis.sh ] && . ~/.travis/travis.sh

# source nvm
# [ -s "${BREWPATH}/opt/nvm/nvm.sh" ] && . "${BREWPATH}/opt/nvm/nvm.sh"

# asdf
[ -f "${BREWPATH}/opt/asdf/asdf.sh" ] && source "${BREWPATH}/opt/asdf/asdf.sh"


# travis-cli
[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

# source extra last for overrides
[ -f "${HOME}/.extra" ] && [ -r "${HOME}/.extra" ] && . "${HOME}/.extra"
