#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --with-default-names

# Install Bash 4
brew install bash

# Install bash-completion
brew tap homebrew/versions
brew install bash-completion
#brew install bash-completion2
brew tap homebrew/completions
brew install brew-cask-completion
brew install vagrant-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --with-iri

# Install r
brew tap homebrew/science
brew install r
mkdir -p ~/Library/R/3.2/library

# Install more recent versions of some OS X tools
brew install vim --with-override-system-vi
brew install homebrew/dupes/grep --default-names
brew install homebrew/dupes/screen

# run this script when this file changes guy.
brew install entr

# find stuff
brew install ack
brew install fzf
brew install the_silver_searcher

# dev stuff
brew install autoconf
brew install automake
# brew install bfg
brew install gist
brew install git
brew install go
brew install heroku
brew install hub
brew install jq
brew install node
brew install openssl@1.1
brew install python

# network stuff
brew install grepcidr
brew install mtr
brew install nmap
brew install speedtest_cli

# log parsing things
brew install lnav
brew install logstalgia

# infra management
brew install ansible
brew install terraform
brew install vault

# Install everything else
brew install aws-elasticbeanstalk
brew install awscli
# brew install ffmpeg --with-libvpx
brew install graphviz
brew install htop
brew install imagemagick
brew install ncdu
brew install pv
brew install rename
brew install stow
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
