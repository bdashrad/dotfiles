#!/usr/bin/env bash

# Configure this clone of the dotfiles repo: the claude settings.json git filter and pre-commit hooks.
# Git never clones .git/config, so every clone needs this; setup-new-machine.sh runs it.
# Safe to re-run, and also repairs a clone whose filter config points at an old path.

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
settings=claude/.claude/settings.json

# keep claude autoMode.environment and model out of git; see .gitattributes and the filter script
git -C "${repo}" config filter.claude-settings.clean '_tools/claude-settings-filter.sh clean'
git -C "${repo}" config filter.claude-settings.smudge '_tools/claude-settings-filter.sh smudge'
git -C "${repo}" config filter.claude-settings.required true

# the clone happened before the filter existed; re-checkout so smudge adds the machine-specific values.
# skipped if settings.json has local edits, so nothing is lost
if git -C "${repo}" diff --quiet -- "${settings}"; then
  rm "${repo}/${settings}" && git -C "${repo}" checkout -- "${settings}"
else
  echo "Skipping re-checkout: ${settings} has local edits." >&2
fi

if command -v pre-commit > /dev/null; then
  (cd "${repo}" && pre-commit install)
else
  echo "pre-commit not found; install it, then run: (cd ${repo} && pre-commit install)" >&2
fi
