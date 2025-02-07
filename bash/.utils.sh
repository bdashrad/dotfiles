#!/usr/bin/env bash

# colors for formatting text
normal=$(tput sgr0)
bold=$(tput bold)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# functions for formatting output
function title() {
  >&2 printf "%s==> $1%s\n" "${bold}" "${normal}"
}

function print_success() {
  # Print output in green
  # printf "\e[0;32m  [✔] $1\e[0m\n"
  >&2 printf "%s  [✔] $1%s\n" "${green}" "${normal}"
}

function print_error() {
  # Print output in red
  # printf "\e[0;31m  [✖] $1 $2\e[0m\n"
  >&2 printf "%s  [✖] $1 $2%s\n" "${red}" "${normal}"
}

function print_info() {
  # Print output in purple
  # printf "\n\e[0;35m $1\e[0m\n\n"
  >&2 fprintf "\n%s $1%s\n\n" "${magenta}" "${normal}"
}

function print_question() {
  # Print output in yellow
  # printf "\e[0;33m  [?] $1\e[0m"
  >&2 printf "%s  [?] $1%s" "${yellow}" "${normal}"
}

function print_result() {
  ([[ $1 -eq 0 ]] \
    && print_success "$2") \
    || print_error "$2"

  # Exit on non-zero if the third parameter is true
  [[ "$3" == "true" ]] && [[ $1 -ne 0 ]] \
    && exit
}

function answer_is_yes() {
  [[ "${REPLY}" =~ ^([yY][eE][sS]|[yY])$ ]] \
    && return 0 \
    || return 1
}

function ask() {
  print_question "$1"
  read -r
}

function ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -rn 1
  >&2 printf "\n"
}

function confirm() {
  ask_for_confirmation "${1:-Are you sure?}"
  # read -r -p "${1:-Are you sure? [y/N]} "
  if answer_is_yes; then
    true
  else
    false
  fi
}

function ask_for_sudo() {
  # Ask for the administrator password upfront
  sudo -v

  # Update existing `sudo` time stamp until this script has finished
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &

}

function cmd_exists() {
  command -v "$1"  >/dev/null 2>&1 \
    && printf 0 \
    || printf 1
}

function execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

function get_answer() {
  printf "%s" "${REPLY}"
}

function get_os() {
  declare -r OS_NAME="$(uname -s)"
  local os=""

  if [[ "${OS_NAME}" == "Darwin" ]]; then
    os="osx"
  elif [[ "${OS_NAME}" == "Linux" ]] && [ -e "/etc/lsb-release" ]; then
    os="ubuntu"
  fi

  printf "%s" "${os}"
}

function is_git_repository() {
  [[ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ]] \
    && return 0 \
    || return 1
}

function mkd() {
  if [[ -n "$1" ]]; then
    if [[ -e "$1" ]]; then
      if [[ ! -d "$1" ]]; then
        print_error "$1 - a file with the same name already exists!"
      else
        print_success "$1"
      fi
    else
      execute "mkdir -p $1" "$1"
    fi
  fi
}

function path_append() {
  if [[ ":${PATH}:" != *":$1:"* ]]; then
    print_info "$1 is not in the PATH, adding it."
    NEWPATH="${PATH:+"${PATH}:"}$1"
  else
    print_success "$1 is already in the PATH, not modifying."
  fi
  printf "%s" "${NEWPATH}"
}

function path_prepend() {
  if [[ ":${PATH}:" != *":$1:"* ]]; then
    print_info "$1 is not in the PATH, adding it."
    NEWPATH="$1:${PATH:+"${PATH}"}"
  else
    print_success "$1 is already in the PATH, not modifying."
  fi
  printf "%s" "${NEWPATH}"
}
