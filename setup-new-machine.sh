#!/usr/bin/env bash

function confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    true
  else
    false
  fi
}

bold=$(tput bold)
green=$(tput setaf 2)
normal=$(tput sgr0)

title() {
  echo "${bold}==> $1${normal}"
  echo
}

# Ask for the administrator password upfront
title "Ask for sudo access at start"
sudo -v

if [[ "$(uname)" == "Darwin" ]]; then
  title "Setting initial path."
  if [[ "$(arch)" == "arm64" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi

  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew";
  export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:${PATH}}";
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:${MANPATH}}";
  export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}";

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

      # Point the `xcode-select` developer directory to
      # the appropriate directory from within `Xcode.app`
      # https://github.com/alrra/dotfiles/issues/13

      sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
      print_result $? 'Make "xcode-select" developer directory point to Xcode'

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      # Prompt user to agree to the terms of the Xcode license
      # https://github.com/alrra/dotfiles/issues/10

      # sudo xcodebuild -license
      # print_result $? 'Agree with the XCode Command Line Tools licence'

  fi
  ###

  # install homebrew
  title "Install Hombrew"
  if test ! $(which brew)
  then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew doctor
  fi

  title "Use Touch ID for sudo."
  sudo ./scripts/touchid_sudo.sh || echo "Configuring sudo failed!"

  # install brew apps
  title "Installing brew apps..."
  brew bundle

  # Ensure Brew Bash is a valid shell option
  if ! grep -q "${HOMEBREW_PREFIX}/bin/bash" /etc/shells ; then
    title "Adding Homebrew Bash to list of allowed shells."
    BASHPATH="${HOMEBREW_PREFIX}/bin/bash"
    echo "${BASHPATH}" | sudo tee -a /etc/shells > /dev/null
  fi

  if grep -q "${HOMEBREW_PREFIX}/bin/bash" /etc/shells ; then
    # change to bash 4 (installed by homebrew)
    title "Changing to homebrew bash"
    chsh -s "${BASHPATH}" # will set for current user only.
    echo "${BASH_VERSION}" # should be 4.x not the old 3.2.X
  fi

  # install fzf keybindings
  title "Install fzf keybindings"
  "$(brew --prefix fzf)/install" --key-bindings --completion --no-update-rc

  # add symlink to iCloud drive
  title "Add symlink ~/icloud for iCloud drive"
  if confirm "Are you signed into iCloud? [y/N] "; then
    ln -s "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/" "${HOME}/icloud"
  else
    echo "After you sign into iCloud you can manually create the symlink to \`${HOME}/Library/Mobile Documents/com~apple~CloudDocs/\`"
  fi

  if confirm "Install work applications? [y/N] "; then
    title "Install brew work.Bundlefile"
    brew bundle install --file work.Brewfile
    title "Install asdf plugins."
    ./scripts/asdf.sh
  else
    echo "Not installing, review \`./work.Brewfile\` and \`asdf.sh\` to see if there is anything you want from there."
  fi

  if confirm "Configure macOS defaults? [y/N] "; then
    title "Configuring macOS defaults."
    ./scripts/osx.sh
  else
    echo "Not configuring defaults, review \`./scripts/osx.sh\` for any settings you want to configure"
  fi

  # gpg
  title "Configuring and restarting gpg-agent."
  "${HOMEBREW_PREFIX}/bin/gsed" "s@HOMEBREW_PREFIX@${HOMEBREW_PREFIX}@g" gnupg/gpg-agent.conf > ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent

  # iterm2
  title "Configuring iterm2."

  # Iterm: Configure to use preferences in dotfiles directory
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/prefs"

  # zoom
  pkill "ZoomOpener"; rm -rf "${HOME}/.zoomus"; touch "${HOME}/.zoomus" && chmod 000 "${HOME}/.zoomus";
  defaults write us.zoom.config ZDisableVideo 1
  sudo defaults -currentHost write us.zoom.config ZDisableVideo 1
fi

# ssh stuff
title "Set up .ssh directory"
mkdir -p /.ssh/control/
stow -t ${HOME}/.ssh ssh
[[ ! -f "${HOME}/.ssh/authorized_keys" ]] && \
  curl -o "${HOME}/.ssh/authorized_keys" https://github.com/bdashrad.keys

title "Stow dotfiles"
stow {bash,git,ruby,screen,tmux,vim}
mkdir -p "${HOME}/bin"
stow -t "${HOME}/bin/" bin

title "Create code folder"
mkdir -p "${HOME}/code"

# install rvm stable
if confirm "Install rvm and ruby bundles?"; then
  title "Installing rvm stable"
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  if confirm "Have you disabled your anti-virus? [y/N] "; then
    echo "Anti-virus must be disabled to compile ruby. Only installing RVM."
    \curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
    echo "After manually installing an RVM ruby, please install bundler and the Gemfile."
  else
    echo "Installing RVM and ruby."
    \curl -sSL https://get.rvm.io | bash -s stable --ruby --ignore-dotfiles
  
    # install ruby gems
    gem install bundler
    bundle install
  fi
else
  echo "Review \`Gemfile\` for uninstalled ruby gems."
fi

# install pip and apps
# sudo easy_install pip
# ./pip-applications.sh

# setup cpan
sudo cpan local::lib
