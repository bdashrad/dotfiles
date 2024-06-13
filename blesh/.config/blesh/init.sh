#!/usr/bin/env bash

# .blerc
# ble.sh config file

# fzf bindings

# set completion to be case insensitive
# bind 'set completion-ignore-case on'

# auto-complete delay (milliseconds)
bleopt complete_auto_delay=500

## If you want to accept the suggestion by auto-complete using TAB, please use
## the following keybindings.  By default, <right> key can be used to accept
## the suggestion, and <TAB> is assigned to the normal TAB completion which is
## independent of auto-complete.
# ble-bind -m auto_complete -f C-i auto_complete/insert
# ble-bind -m auto_complete -f TAB auto_complete/insert

## With the following settings, M-backspace (whose actual key sequence
## depends on your terminal) will kill the backward word as in the default
## readline
ble-bind -f 'M-C-?' kill-backward-cword # macos
# ble-bind -f 'M-DEL' kill-backward-cword
# ble-bind -f 'M-C-h' kill-backward-cword
# ble-bind -f 'M-BS'  kill-backward-cword
