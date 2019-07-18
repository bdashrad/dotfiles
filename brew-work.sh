#!/usr/bin/env bash

# work stuff

# log parsing things
# brew install logstalgia
# brew install lnav
brew install goaccess

# infra management
# brew install ansible
# brew install ansible-lint
brew install packer
# brew install terraform
brew install terraform-docs
brew install terraform_landscape
brew install vault

# Install kubernetes stuff
# brew install kubernetes-cli
# brew install kubernetes-helm
# brew install kops
brew install kube-ps1
brew install kubectx

# zoom
pkill "ZoomOpener"; rm -rf ~/.zoomus; touch ~/.zoomus && chmod 000 ~/.zoomus;
brew cask install zoomus
defaults write ~/Library/Preferences/us.zoom.config.plist ZDisableVideo 1
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1


# Remove outdated versions from the cellar
brew cleanup
