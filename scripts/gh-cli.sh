#!/usr/bin/env bash

# Install GitHub CLI extensions. brew bundle can't manage these.
# Safe to re-run: --force upgrades extensions that are already installed.

set -euo pipefail

gh_extensions=(
  # https://github.com/matt-bartel/gh-clone-org
  matt-bartel/gh-clone-org
  # https://github.com/seachicken/gh-poi
  seachicken/gh-poi
)

command -v gh > /dev/null || { echo "Error: \`gh\` not found in \$PATH." >&2; exit 1; }

for extension in "${gh_extensions[@]}"; do
  gh extension install --force "${extension}"
done
