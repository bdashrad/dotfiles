#!/usr/bin/env bash

# check for ble.sh
if ! [[ -f "${HOME}/.local/share/blesh/ble.sh" ]]; then
  # echo "ble.sh is not installed. Please install it"
  # exit 1
  echo "ble.sh is not installed. Installing it now"
  tempdir=$(mktemp -d)
  curl -s \
    -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz \
    -o "${tempdir}/ble-nightly.tar.xz"
  tar xJf "${tempdir}/ble-nightly.tar.xz" -C "${tempdir}"
  bash "${tempdir}/ble-nightly/ble.sh" --install "${HOME}/.local/share"
  # shellcheck disable=SC1091
  source "${HOME}/.local/share/blesh/ble.sh"
else
  echo "ble.sh is already installed. Skipping installation."
  echo "You can update ble.sh by running the following command:"
  echo "  ble-update"
fi
