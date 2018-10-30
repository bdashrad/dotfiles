#!/usr/bin/env bash

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

# install rvm stable
echo "Installing rvm..."
\curl -sSL https://get.rvm.io | bash -s stable

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

# install pip and apps
sudo easy_install pip
./pip-applications.sh

# install ruby gems
gem install bundler
bundle install

# install cask applications
./brew-cask.sh
