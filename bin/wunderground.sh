#!/usr/bin/env bash

set -a ; set -o errexit ; set -o nounset

function usage() {
    cat <<EOF
    Usage: ${0} ARG
    OPTIONS:
      -h        Show usage
      -l        Locale (Locality_Name)
      -s        State (XX)
EOF
exit
}

while getopts ":hl:s:" OPTION; do
  case $OPTION in
    h) usage                   ;;
    l) WU_LOCALE="$OPTARG"     ;;
    s) WU_STATE="$OPTARG"      ;;
  esac
done

if [[ ! -f $HOME/.wunderground ]]; then
  printf 'Enter API key for Wunderground: '
  read -rs WU_API_KEY
  echo
  echo "${WU_API_KEY}" \
    > "$HOME/.wunderground"
fi

BASE_URL='http://api.wunderground.com/api/'
WU_AUTH=$(cat "$HOME/.wunderground")

curl -sS ${BASE_URL}${WU_AUTH}/conditions/q/${WU_STATE}/${WU_LOCALE}.json \
  | jq '.current_observation
     | "Weather Report for " + .display_location.city + ", "
       + .display_location.state_name + ". " + .observation_time
       + ". Current conditions are " + .weather + " with visibility of " + .visibility_mi
       + " miles. The temperature is \(.temp_f) degrees Farhenheit and feels like "
       + .feelslike_f + ". Wind is " + .wind_string + "."' \
  | sed 's/\.0//g'

