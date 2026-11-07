#!/usr/bin/env bash

# pre-commit check: fail if the staged claude/.claude/settings.json has machine-specific values.
# The clean filter strips them, so this only trips when the filter isn't configured (e.g. a fresh clone
# before setup-new-machine.sh ran) or is broken. Checks the staged blob, not the smudged working copy.

set -euo pipefail

file=claude/.claude/settings.json

# nothing staged for this path (or it was deleted)
git cat-file -e ":${file}" 2> /dev/null || exit 0

if git show ":${file}" | jq -e 'has("model") or (.autoMode.environment != null)' > /dev/null; then
  echo "Error: staged ${file} has model or autoMode.environment; the claude-settings git filter isn't working." >&2
  echo "Configure it (see _setup/setup-new-machine.sh), then: git add --renormalize ${file}" >&2
  exit 1
fi
