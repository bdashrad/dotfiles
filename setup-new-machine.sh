#!/usr/bin/env bash

function confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    true
  else
    false
  fi
}

# Ask for the administrator password upfront
sudo -v

# update osx
sudo softwareupdate -i -a

### XCode Command Line Tools
#      thx https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh

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

    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

fi
###

# install homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
fi

# install brew apps
echo "Installing brew apps..."
./brew.sh

# change to bash 4 (installed by homebrew)
BASHPATH=$(brew --prefix)/bin/bash
echo "$BASHPATH" | sudo tee -a /etc/shells > /dev/null
chsh -s "$BASHPATH" # will set for current user only.
echo "$BASH_VERSION" # should be 4.x not the old 3.2.X

# install fzf keybindings
"$(brew --prefix fzf)/install" --keybindings --completion --no-update-rc

# create bin directory
mkdir -p ~/bin

# install rvm stable
echo "Installing rvm..."
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
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

# install pip and apps
# sudo easy_install pip
./pip-applications.sh

# setup cpan
sudo cpan local::lib

# install cask applications
./brew-cask.sh

# add symlink to iCloud drive
if confirm "Are you signed into iCloud? [y/N] "; then
  ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/icloud"
else
  echo "After you sign into iCloud you can manually create the symlink to \`$HOME/Library/Mobile Documents/com~apple~CloudDocs/\`"
fi

if confirm "Install work applications? [y/N] "; then
  ./brew-work.sh
  ./asdf.sh
else
  echo "Not installing, review \`./brew-work.sh\` and \`asdf.sh\` to see if there is anything you want from there."
fi
