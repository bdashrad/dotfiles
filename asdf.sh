#!/usr/bin/env bash

ASDF_PLUGINS=(
  "helm 3.5.4"
  "kubectl 1.17.17"
  "kubectl 1.18.18"
  "kubectl 1.19.10"
  "terraform 0.15.3"
  "pluto 4.1.2"
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
