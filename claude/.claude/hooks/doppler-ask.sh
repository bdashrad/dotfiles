#!/usr/bin/env bash

# PreToolUse (Bash) hook: always prompt before a command that changes Doppler secrets,
# in any project or config, regardless of permission mode or auto mode.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')

# doppler [flags] secrets set|delete|rm|upload, doppler import, deleting projects/configs/environments,
# the oneapp-fabric sync-all wrapper, and direct Doppler API calls
patterns=(
  'doppler([[:space:]]+[^|;&]*)?[[:space:]]secrets[[:space:]]+(set|delete|rm|upload)([[:space:]]|$)'
  'doppler([[:space:]]+[^|;&]*)?[[:space:]]import([[:space:]]|$)'
  'doppler([[:space:]]+[^|;&]*)?[[:space:]](projects|configs|environments)[[:space:]]+(delete|rm)([[:space:]]|$)'
  'doppler:sync-all|doppler\.mjs[[:space:]]+sync-all'
  'api\.doppler\.com'
)

for re in "${patterns[@]}"; do
  if [[ "$cmd" =~ $re ]]; then
    jq -n --arg m "${BASH_REMATCH[0]}" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: ("Changes Doppler secrets (matched: " + $m + "); always confirm")
      }
    }'
    exit 0
  fi
done
