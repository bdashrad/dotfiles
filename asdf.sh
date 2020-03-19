#!/usr/bin/env bash

ASDF_PLUGINS=(
  "helm 2.7.0"
  "helm 2.13.1"
  "kubectl 1.10.5"
  "kubectl 1.12.9"
  "kops 1.9.1"
  "terraform 0.11.11"
)

if [[ ! $(command -v brew) ]]; then
  echo "Install homebrew first"
  return 1
fi

# install asdf
if [[ ! -f "$(brew --prefix asdf)/asdf.sh" ]]; then
  echo "Installing asdf..."
  brew install asdf
fi

# source asdf
[[ -f "$(brew --prefix asdf)/asdf.sh" ]] && . "$(brew --prefix asdf)/asdf.sh"

# install asdf plugins
while read -r -a plugin; do
  asdf plugin-add ${plugin[0]};
done < <(printf '%s\n' "${ASDF_PLUGINS[@]}"| sort -u -k1,1)


while read -r plugin; do
  asdf install $plugin;
done < <(printf '%s\n' "${ASDF_PLUGINS[@]}")
