#!/usr/bin/env bash

# Get the absolute path of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# stow and the ./_setup, ./_tools paths below expect the repo root (~/.dotfiles) as the working directory
cd "${SCRIPT_DIR}/.." || exit 1

if [[ -f "${SCRIPT_DIR}/../bash/.utils.sh" ]]; then
  echo "found .utils.sh"
  source "${SCRIPT_DIR}/../bash/.utils.sh"
else
  echo "Could not find .utils.sh in ${SCRIPT_DIR}/../bash/.utils.sh"
  exit 1
fi

# create XDG directories
mkdir -p "${HOME}"/{.config,.cache,.local/{bin,share,state}}

# Ask for the administrator password upfront
title "Ask for sudo access at start"
sudo -v
# keep sudo alive through long brew bundle runs; the trap stops the loop when this script exits, and the
# loop also exits on its own if this script is gone (e.g. killed before the trap could run)
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "${SUDO_KEEPALIVE_PID}" 2> /dev/null' EXIT

if [[ "$(uname)" == "Darwin" ]]; then
  title "Setting initial path."
  if [[ "$(arch)" == "arm64" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi

  # update osx
  title "Run softwareupdate."
  sudo softwareupdate -i -a

  ### XCode Command Line Tools
  #      thx https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh

  title "Check for XCode command line tools"
  if ! xcode-select --print-path &> /dev/null; then

      # Prompt user to install the XCode Command Line Tools
      xcode-select --install &> /dev/null

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      # Wait until the XCode Command Line Tools are installed
      until xcode-select --print-path &> /dev/null; do
          sleep 5
      done

      print_result $? 'Install XCode Command Line Tools'


      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      # Prompt user to agree to the terms of the Xcode license
      # https://github.com/alrra/dotfiles/issues/10

      # sudo xcodebuild -license
      # print_result $? 'Agree with the XCode Command Line Tools licence'

  fi
  ###

  # install homebrew
  title "Install Homebrew"
  if [[ ! -x "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    # the installer doesn't put brew on this shell's PATH
    eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
    brew doctor
  fi

  # source brew shell environment
  eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"

  title "Use Touch ID for sudo."
  sudo ./_setup/touchid_sudo.sh || echo "Configuring sudo failed!"

  # set a stable hostname (used by atuin, etc.). With HostName unset, `hostname` comes from DHCP or
  # reverse DNS, or falls back to LocalHostName.local, so it changes with the network. Set all three so
  # the Sharing name, the Bonjour name, and `hostname` match; use letters, digits, and hyphens only
  title "Set a stable hostname."
  CURRENT_HOSTNAME="$(scutil --get HostName 2> /dev/null || scutil --get LocalHostName)"
  echo "Current hostname: ${CURRENT_HOSTNAME}"
  if confirm "Set a static hostname with scutil? [y/N] "; then
    read -r -p "Hostname [${CURRENT_HOSTNAME}]: " NEW_HOSTNAME
    for name in ComputerName LocalHostName HostName; do
      sudo scutil --set "${name}" "${NEW_HOSTNAME:-${CURRENT_HOSTNAME}}"
    done
  fi

  # mas can't sign in or check sign-in status, so pause here; without it only the mas entries fail
  title "Sign in to the App Store"
  open -a "App Store"
  read -r -p "Sign in to the App Store (needed for mas apps), then press Enter to continue... "

  # install brew apps
  title "Installing brew apps..."
  brew bundle --file "${SCRIPT_DIR}/Brewfile"

  # Ensure Brew Bash is a valid shell option, then make it the login shell
  BASHPATH="${HOMEBREW_PREFIX}/bin/bash"
  if ! grep -qx "${BASHPATH}" /etc/shells; then
    title "Adding Homebrew Bash to list of allowed shells."
    echo "${BASHPATH}" | sudo tee -a /etc/shells > /dev/null
  fi

  if [[ "$(dscl . -read "/Users/${USER}" UserShell | awk '{ print $2 }')" != "${BASHPATH}" ]]; then
    title "Changing to homebrew bash"
    chsh -s "${BASHPATH}" # will set for current user only.
  fi
  "${BASHPATH}" --version | head -1 # should be 5.x, not the macOS 3.2.x

  # add symlink to iCloud drive
  title "Add symlink ~/icloud for iCloud drive"
  if confirm "Are you signed into iCloud? [y/N] "; then
    ln -sfn "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/" "${HOME}/icloud"
  else
    echo "After you sign into iCloud you can manually create the symlink to \`${HOME}/Library/Mobile Documents/com~apple~CloudDocs/\`"
  fi

  if confirm "Install work applications? [y/N] "; then
    title "Install brew work.Brewfile"
    brew bundle install --file "${SCRIPT_DIR}/work.Brewfile"
  else
    echo "Not installing, review \`./_setup/work.Brewfile\` to see if there is anything you want from there."
  fi

  if confirm "Install home applications? [y/N] "; then
    title "Install brew home.Brewfile"
    brew bundle install --file "${SCRIPT_DIR}/home.Brewfile"
  else
    echo "Not installing, review \`./_setup/home.Brewfile\` to see if there is anything you want from there."
  fi

  # mas needs an App Store sign-in, and each app must already be owned by that Apple ID
  if confirm "Install Safari extensions? [y/N] "; then
    title "Install brew safari.Brewfile"
    brew bundle install --file "${SCRIPT_DIR}/safari.Brewfile"
  else
    echo "Not installing, review \`./_setup/safari.Brewfile\` to see if there is anything you want from there."
  fi

  if confirm "Configure macOS defaults? [y/N] "; then
    title "Configuring macOS defaults."
    ./_setup/osx.sh
  else
    echo "Not configuring defaults, review \`./_setup/osx.sh\` for any settings you want to configure"
  fi

  # gpg
  title "Configuring and restarting gpg-agent."
  mkdir -p "${HOME}/.gnupg" && chmod 700 "${HOME}/.gnupg"
  "${HOMEBREW_PREFIX}/bin/gsed" "s@HOMEBREW_PREFIX@${HOMEBREW_PREFIX}@g" gnupg/gpg-agent.conf > ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent

  # iterm2
  title "Configuring iterm2."

  # Iterm: Configure to use preferences in dotfiles directory
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/prefs"

  # zoom: join meetings with video off
  defaults write us.zoom.config ZDisableVideo 1
  sudo defaults -currentHost write us.zoom.config ZDisableVideo 1
fi

# ssh stuff
title "Set up .ssh directory"
mkdir -p "${HOME}/.ssh/control/"
stow -t "${HOME}/.ssh" ssh
[[ ! -f "${HOME}/.ssh/authorized_keys" ]] && \
  curl -o "${HOME}/.ssh/authorized_keys" https://github.com/bdashrad.keys

# setup lazy loading for homebrew bash completions: formulae with modern completions already land in
# bash-completion's own dir, this exposes the legacy etc/bash_completion.d ones (see bash/.completion)
mkdir -p "${HOME}/.local/share/bash-completion"
# -n replaces an existing link instead of creating a self-loop inside etc/bash_completion.d
ln -sfn "${HOMEBREW_PREFIX}/etc/bash_completion.d" "${HOME}/.local/share/bash-completion/completions"
./_tools/bun-completion-patch.sh


title "Stow dotfiles"
# create these first so stow links their files instead of folding the whole dir into the repo,
# otherwise tools write credentials and runtime state into ~/.dotfiles
mkdir -p "${HOME}"/{bin,.agents/skills,.claude,.codex,.colima,.config/gcloud}
stow {agents,asdf,atuin,bash,blesh,btop,claude,git,linters,powerline-go,screen,tmux,vim}
stow -t "${HOME}/bin/" bin
# ble.sh needs the BSD stty, not the coreutils one from gnubin; absolute
# symlinks can't be stowed, so link it directly
ln -sfn /bin/stty "${HOME}/bin/stty"
# blesh only stows the config; install ble.sh itself
./_setup/install-ble.sh

if [[ "$(uname)" == "Darwin" ]]; then
  stow {iterm2,rectangle}
fi

title "Configure dotfiles repo git filters and hooks"
./_setup/repo-setup.sh

if confirm "Stow Codex dotfiles? [y/N] "; then
  stow codex
fi

if confirm "Set up cloud / IaC (gcloud, terraform dotfiles and cloud-iac.Brewfile)? [y/N] "; then
  if command -v brew &> /dev/null; then
    brew bundle install --file "${SCRIPT_DIR}/cloud-iac.Brewfile"
  fi
  stow {gcloud,terraform}
fi

if confirm "Stow Go dotfiles? [y/N] "; then
  stow golang
fi

if confirm "Stow Ruby dotfiles? [y/N] "; then
  stow ruby
fi

if confirm "Set up containers (docker, colima dotfiles and containers.Brewfile)? [y/N] "; then
  if command -v brew &> /dev/null; then
    brew bundle install --file "${SCRIPT_DIR}/containers.Brewfile"
  fi
  stow {docker,colima}
fi

if confirm "Set up Kubernetes tooling (kubernetes.Brewfile)? [y/N] "; then
  if command -v brew &> /dev/null; then
    brew bundle install --file "${SCRIPT_DIR}/kubernetes.Brewfile"
  fi
  # brew bundle can't manage krew plugins; update the list from a machine with
  # `kubectl krew list > _setup/krew-plugins.txt`
  if command -v kubectl-krew &> /dev/null; then
    title "Installing krew plugins"
    kubectl-krew install < "${SCRIPT_DIR}/krew-plugins.txt"
  fi
fi

title "Install asdf plugins and tools"
# bootstrap asdf-plugin-manager at the ref and version pinned in the stowed asdf package, then let it
# add every plugin from ~/.plugin-versions and install every tool from ~/.tool-versions
if command -v asdf &> /dev/null; then
  apm_ref="$(awk '$1 == "asdf-plugin-manager" { print $3 }' "${HOME}/.plugin-versions")"
  apm_version="$(awk '$1 == "asdf-plugin-manager" { print $2 }' "${HOME}/.tool-versions")"
  asdf plugin add asdf-plugin-manager https://github.com/asdf-community/asdf-plugin-manager.git
  asdf plugin update asdf-plugin-manager "${apm_ref}"
  asdf install asdf-plugin-manager "${apm_version}"
  (cd "${HOME}" && asdf exec asdf-plugin-manager add-all && asdf install)
else
  echo "asdf not found, skipping plugins; install it with brew and re-run this step."
fi

if confirm "Install GitHub CLI extensions (gh-clone-org, gh-poi)? [y/N] "; then
  title "Installing GitHub CLI extensions."
  ./_setup/gh-cli.sh
else
  echo "Not installing, review \`./_setup/gh-cli.sh\` for the extension list."
fi

if confirm "Configure Claude Code (MCP servers, settings.private.json)? [y/N] "; then
  title "Configuring Claude Code."
  ./_setup/claude-setup.sh
else
  echo "Not configuring, review \`./_setup/claude-setup.sh\` for anything you want to set up."
fi

title "Create code folder"
mkdir -p "${HOME}/code"

# ruby itself comes from asdf (.tool-versions); bundler ships with it
if confirm "Install ruby gems from the Gemfile? [y/N] "; then
  title "Installing ruby gems"
  if command -v asdf &> /dev/null; then
    asdf exec bundle install
  else
    echo "asdf not found; install ruby with asdf, then run \`bundle install\` here."
  fi
else
  echo "Review \`Gemfile\` for uninstalled ruby gems."
fi

# install pip and apps
# sudo easy_install pip
# ./pip-applications.sh

# setup cpan
cpan local::lib
