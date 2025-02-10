#!/usr/bin/env bash

gh_extensions=(
  # https://github.com/matt-bartel/gh-clone-org
  matt-bartel/gh-clone-org
  # https://github.com/seachicken/gh-poi
  seachicken/gh-poi
  # https://github.com/actions/gh-actions-cache
  actions/gh-actions-cache
  # https://github.com/github/gh-net
  github/gh-net
)

# check if `gh` is installed
if command -v gh > /dev/null; then
  # install extensions listed above
  for extension in "${gh_extensions[@]}"; do
    gh extension install "${extension}"
  done
else
  echo "Error: \`gh\` not found in \$PATH."
  exit 1
fi
