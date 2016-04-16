#!/usr/bin/env bash

[ -n "$PS1" ] && source ~/.bash_profile

export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
