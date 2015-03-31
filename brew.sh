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
brew install gnu-sed --default-names

# Install Bash 4
brew install bash

# Install bash-completion
brew tap homebrew/versions
brew install homebrew/versions/bash-completion2
brew install bash-completion
brew tap homebrew/completions
brew install vagrant-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/screen

# Install everything else
brew install ack
brew install bfg
brew install gist
brew install git
brew install grepcidr
brew install hub
brew install logstalgia
brew install mtr
brew install nmap
brew install node
brew install pv
brew install rename
brew install speedtest_cli
brew install swig
brew install tree
brew install terminal-notifier

# Install some linters
install shellcheck

# Remove outdated versions from the cellar
brew cleanup
