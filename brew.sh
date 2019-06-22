#!/usr/bin/env bash

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# Don't forget to add `$(brew --prefix findutils)/libexec/gnubin` to `$PATH`.
brew install findutils
# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `sed`, overwriting the built-in `sed`
# Don't forget to add `$(brew --prefix gnu-sed)/libexec/gnubin` to `$PATH`.
brew install gnu-sed
# Install GNU `grep`
# Don't forget to add `$(brew --prefix grep)/libexec/gnubin` to `$PATH`.
brew install grep

# Install Bash 4
brew install bash

# Install/Upgrade some languages
brew install go
brew install node
brew install python

# stow is used to manage these dotfiles
brew install stow

# Install bash-completion
brew install bash-completion
brew install brew-cask-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget

# Install r
# brew install r
# mkdir -p ~/Library/R/3.2/library

# Install more recent versions of some OS X tools
brew install vim
brew install screen

# run this script when this file changes guy.
brew install entr

# find stuff
brew install ack
brew install fzf
brew install the_silver_searcher
brew install z

# dev stuff
brew install autoconf
brew install automake
# brew install bfg
brew install gist
brew install git
brew install jq
brew install openssl@1.1

# install heroku-cli
brew tap heroku/brew
brew install heroku

# network stuff
brew install grepcidr
brew install mtr
brew install nmap
brew install speedtest_cli

# Install everything else
brew install aws-elasticbeanstalk
brew install awscli
brew install fullscreen/tap/aws-rotate-key
# brew install ffmpeg --with-libvpx
brew install graphviz
brew install htop
brew install imagemagick
brew install ncdu
brew install pv
brew install rename
brew install swig
brew install tree
brew install terminal-notifier

# Install pgp stuff
brew install gpg
brew install gpg-agent
brew install pinentry-mac

# Install compression stuff
brew install p7zip
brew install unrar
brew install xz

# Install some linters
brew install shellcheck

# Remove outdated versions from the cellar
brew cleanup
