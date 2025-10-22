#!/usr/bin/env bash

ASDF_PLUGIN_MANAGER_VERSION="1.4.0"

# shellcheck disable=SC3030
ASDF_PLUGINS=(
  "argo latest"
  "colima latest"
  "golang latest"
  "helm latest"
  "kubeconform latest"
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
  echo "Install homebrew first."
  return 1
fi

# install asdf
if [[ ! $(command -v asdf) ]]; then
  echo "Install asdf before continuing."
  return 1
  # brew install asdf
fi

# source asdf
[[ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]] && . "$(brew --prefix asdf)/libexec/asdf.sh"

# install asdf-plugin-manager plugin
asdf plugin add asdf-plugin-manager https://github.com/asdf-community/asdf-plugin-manager.git
asdf plugin update asdf-plugin-manager "tags/v${ASDF_PLUGIN_MANAGER_VERSION}"

# install asdf-plugin-manager cli
asdf install asdf-plugin-manager ${ASDF_PLUGIN_MANAGER_VERSION}

# # install asdf plugins
# while read -r -a plugin; do
#   asdf plugin-add ${plugin[0]};
# done < <(printf '%s\n' "${ASDF_PLUGINS[@]}"| sort -u -k1,1)


# while read -r plugin; do
#   asdf install $plugin;
#   asdf global $plugin;
# done < <(printf '%s\n' "${ASDF_PLUGINS[@]}")
