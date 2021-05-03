#!/usr/bin/env bash

# Install native apps

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# brew install caskroom/cask/brew-cask
# brew tap caskroom/cask
# brew tap caskroom/versions

# add brew-cask-upgrade
brew tap buo/cask-upgrade

# always
brew install --cask alfred
# brew install --cask dropbox
brew install --cask evernote
brew install --cask firefox
brew install --cask google-chrome
# brew install --cask google-drive
brew install --cask spectacle
brew install --cask stay
brew install --cask the-unarchiver
brew install --cask transmission
brew install --cask xquartz

# communication
brew install --cask slack
brew install --cask zoom

# development
brew install --cask iterm2
# brew install --cask menumeters
# brew install --cask kdiff3
brew install --cask p4v # p4merge
brew install --cask sublime-text
# brew install --cask vagrant
# brew install --cask vagrant-manager
# brew install --cask virtualbox
# brew install --cask virtualbox-extension-pack
brew install --cask visual-studio-code
# brew install --cask wireshark

# multimedia
# brew install --cask exiftool
brew install --cask gyazo
# brew install --cask lastfm
brew install --cask skitch
brew install --cask spotify
brew install --cask vlc

# quicklook plugins
# brew install --cask betterzipql
# brew install --cask qlcolorcode
# brew install --cask qlmarkdown
# brew install --cask qlprettypatch
# brew install --cask qlstephen
# brew install --cask quicklook-csv
# brew install --cask quicklook-json
# brew install --cask suspicious-package

# security
brew install --cask 1password
brew install --cask keybase
# brew install --cask lastpass
brew install --cask secretive
brew install --cask tunnelblick

# utilities
brew install --cask filebot
# brew install --cask krisp
brew install --cask oversight
brew install --cask tripmode
