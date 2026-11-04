#!/usr/bin/env bash

# git clean/smudge filter for claude/.claude/settings.json (see .gitattributes)
# clean: strip autoMode.environment and model so machine-specific values are never committed
# smudge: rebuild environment from settings.private.json (per machine) + automode.dotfiles.json (shared),
#         and restore model from settings.private.json

set -euo pipefail

private=claude/.claude/settings.private.json
shared=claude/.claude/automode.dotfiles.json

# print a file's autoMode.environment as a JSON array, or [] if missing/invalid
env_of() {
  if [[ -f "$1" ]]; then
    jq -c '.autoMode.environment // [] | if type == "array" then . else [] end' "$1"
  else
    echo '[]'
  fi
}

# print a file's model as a JSON string, or null if missing/invalid
model_of() {
  if [[ -f "$1" ]]; then
    jq -c '.model // null | if type == "string" then . else null end' "$1"
  else
    echo null
  fi
}

case "${1:-}" in
  clean)
    jq 'del(.autoMode.environment) | if .autoMode == {} then del(.autoMode) else . end | del(.model)'
    ;;
  smudge)
    # machine entries first, then shared; keep the built-in list if neither includes $defaults
    entries=$(jq -cn --argjson p "$(env_of "$private")" --argjson s "$(env_of "$shared")" \
      '($p + $s) as $e | if ($e | length) == 0 or any($e[]; . == "$defaults") then $e else ["$defaults"] + $e end')
    jq --argjson e "$entries" --argjson m "$(model_of "$private")" \
      '(if ($e | length) > 0 then .autoMode.environment = $e else . end) | if $m then .model = $m else . end'
    ;;
  *)
    echo "usage: $0 clean|smudge" >&2
    exit 1
    ;;
esac
