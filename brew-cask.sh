#!/usr/bin/env bash

# Install native apps

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# brew install caskroom/cask/brew-cask
brew tap caskroom/cask
brew tap caskroom/versions

# always
brew cask install alfred
# brew cask install bettertouchtool
brew cask install caffeine
brew cask install dropbox
brew cask install evernote
brew cask install firefox
brew cask install flux
brew cask install google-chrome
brew cask install google-drive
brew cask install karabiner
brew cask install rescuetime
brew cask install spectacle
brew cask install stay
brew cask install the-unarchiver
brew cask install transmission
brew cask install xquartz

# chat
# brew cask install adium
brew cask install google-hangouts
# brew cask install mumble
# brew cask install skype
brew cask install slack

# development
brew cask install atom
brew cask install iterm2
# brew cask install menumeters
brew cask install kdiff3
brew cask install p4merge
brew cask install sublime-text
brew cask install vagrant
brew cask install vagrant-manager
brew cask install virtualbox
brew cask install wireshark

# multimedia
# brew cask install exiftool
brew cask install gyazo
# brew cask install lastfm
brew cask install skitch
brew cask install spotify
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

# security
# brew cask install keepassx0
brew cask install 1password
brew cask install keybase
brew cask install lastpass
brew cask install torbrowser
brew cask install tunnelblick

# utilities
# brew cask install amethyst
brew cask install capsee
brew cask install screenhero
# brew cask install logitech-unifying
