#!/usr/bin/env bash

# shellcheck disable=SC3030
ASDF_PLUGINS=(
  "colima latest"
  "golang latest"
  "helm latest"
  "kubectl latest"
  "kustomize latest"
  "minikube latest"
  "nodejs latest"
  "nova latest"
  "pluto latest"
  "polaris latest"
  "python latest"
  "ruby latest"
  "terraform latest"
  "yarn latest"
)

if [[ ! $(command -v brew) ]]; then
  echo "Install homebrew first"
  return 1
fi

# install asdf
if [[ ! $(command -v asdf) ]]; then
  echo "Installing asdf..."
  brew install asdf
fi

# source asdf
[[ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]] && . "$(brew --prefix asdf)/libexec/asdf.sh"

# install asdf plugins
while read -r -a plugin; do
  asdf plugin-add ${plugin[0]};
done < <(printf '%s\n' "${ASDF_PLUGINS[@]}"| sort -u -k1,1)


while read -r plugin; do
  asdf install $plugin;
  asdf global $plugin;
done < <(printf '%s\n' "${ASDF_PLUGINS[@]}")
