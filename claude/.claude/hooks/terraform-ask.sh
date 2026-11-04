#!/usr/bin/env bash

# PreToolUse (Bash) hook: always prompt before a local Terraform / OpenTofu command that changes
# infrastructure or state, or before switching to the read-write Terraform service account.

set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')

# terraform|tofu|tf-wrapper.sh [flags] apply|destroy|import|force-unlock, state changes,
# init -migrate-state, and the gcp-* stage repos' read-write service account switch
tf='(terraform|tofu|tf-wrapper\.sh)([[:space:]]+[^|;&]*)?[[:space:]]'
patterns=(
  "${tf}(apply|destroy|import|force-unlock)([[:space:]]|$)"
  "${tf}state[[:space:]]+(rm|mv|push|replace-provider)([[:space:]]|$)"
  "${tf}init([[:space:]]+[^|;&]*)?[[:space:]]-migrate-state"
  'use-sa\.sh[[:space:]]+readwrite'
)

for re in "${patterns[@]}"; do
  if [[ "$cmd" =~ $re ]]; then
    jq -n --arg m "${BASH_REMATCH[0]}" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: ("Changes infrastructure or Terraform state (matched: " + $m + "); always confirm")
      }
    }'
    exit 0
  fi
done
