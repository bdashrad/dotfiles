#!/usr/bin/env bash

# Install native apps
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# applications
brew cask install adium
brew cask install atom
brew cask install alfred
brew cask install caffeine
brew cask install dropbox
brew cask install evernote
brew cask install firefox
brew cask install flux
brew cask install google-chrome
brew cask install google-drive
brew cask install iterm2
brew cask install lastpass
brew cask install menumeters
brew cask install kdiff3
brew cask install slack
brew cask install spectacle
brew cask install spotify
brew cask install stay
brew cask install sublime-text3
brew cask install transmission
brew cask install tunnelblick
brew cask install vagrant
brew cask install vagrant-manager
brew cask install virtualbox
brew cask install vlc

# quicklook plugins
brew cask install betterzipql
brew cask install qlcolorcode
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install suspicious-package
