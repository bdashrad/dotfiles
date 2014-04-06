#!/usr/bin/env bash

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return
fd=0  # stdin
if ! [[ -t "$fd" || -p /dev/stdin ]]; then
  return
fi