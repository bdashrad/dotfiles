# Brewfile for things I want on all of my Macs

# add cask-versions to install alternate versions of Casks
tap "homebrew/cask-versions"

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew "coreutils"
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# Don't forget to add `$(brew --prefix findutils)/libexec/gnubin` to `$PATH`.
brew "findutils"
# Install some other useful utilities like `sponge`
brew "moreutils"
# Install GNU `sed`, overwriting the built-in `sed`
# Don't forget to add `$(brew --prefix gnu-sed)/libexec/gnubin` to `$PATH`.
brew "gnu-sed"
# Install GNU `grep`
# Don't forget to add `$(brew --prefix grep)/libexec/gnubin` to `$PATH`.
brew "grep"

# Install Bash 5
brew "bash"

# Install/Upgrade some languages
# brew "coffeescript"  # still need for legacy hubot scripts

# stow is used to manage these dotfiles
brew "stow"

# Install bash-completion
brew "bash-completion@2"
brew "brew-cask-completion"

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew "grc"

# Install r
# brew r
# mkdir -p ~/Library/R/3.2/library

# Install more recent versions of some tools
brew "screen"
brew "vim"
brew "wget"  # Install wget with IRI support

# run this script when this file changes guy.
brew "entr"

# find stuff
brew "ack"
brew "fzf"
brew "the_silver_searcher"
brew "z"  # jump around paths by frecency

# dev stuff
brew "asdf"
brew "autoconf"
brew "automake"
brew "bat"
brew "bats-core"
# brew "bfg"
brew "gh"
brew "gist"
brew "git"
tap "git-chglog/git-chglog"
brew "git-chglog"
brew "git-delta"
tap "norwoodj/tap"
brew "helm-docs"
brew "hub"
brew "jc"
brew "jd"
brew "jq"
brew "ijq"
tap "noahgorstein/tap"
brew "noahgorstein/tap/jqp"
brew "openssh"
brew "openssl@1.1"
brew "tmate"
brew "yamllint"
brew "yq"

# python things
# cask "miniconda"

# install heroku-cli
# tap "heroku/brew"
# brew "heroku"

# network stuff
brew "grepcidr"
brew "mtr"
brew "mosh"
brew "nmap"
brew "speedtest-cli"

# Install everything else
# brew "aws-elasticbeanstalk"
# brew "awscli"
brew "direnv"
# tap "fullscreen/tap"
# brew "aws-rotate-key"
# brew "ffmpeg" --with-libvpx
brew "graphviz"
brew "htop"
brew "imagemagick"
brew "markdownlint-cli"
brew "mas"
brew "ncdu"
brew "optipng"
brew "pngcrush"
brew "pngquant"
brew "pv"
# brew "qemu"
brew "rename"
brew "swig"
# brew "travis"
brew "tree"
brew "terminal-notifier"
brew "watch"
brew "whalebrew"

# prompt
brew "powerline-go"
cask "homebrew/cask-fonts/font-powerline-symbols"

# Install pgp stuff
brew "gpg"
brew "gnupg"
brew "pinentry-mac"

# Install compression stuff
brew "p7zip"
brew "xz"

# Install some linters
brew "shellcheck"

################################
# Casks
################################

# Install native apps

# Link casks in `/Applications` rather than `~/Applications`
# export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# add brew-cask-upgrade
tap "buo/cask-upgrade"

# always
# cask "1password"
# brew "1password-cli"
cask "1password-beta"
brew "1password-cli-beta"
cask "alfred"
cask "anylist"
cask "authy"
cask "barrier"
cask "brave-browser"
cask "cron"
# cask "rancher"
# cask "dropbox"
cask "evernote"
cask "firefox"
cask "keybase"
cask "google-chrome"
# cask "google-drive"
cask "MonitorControl"
# qmk toolbox is in cask-drivers
tap "homebrew/cask-drivers"
cask "qmk-toolbox"
cask "rectangle"
cask "soundsource"
cask "stay"
cask "the-unarchiver"
cask "todoist"
cask "transmission"
# cask "xquartz"

# communication
cask "coscreen"
# cask "discord"
cask "discord-canary"
cask "krisp"
cask "pop"
cask "slack"
# cask "zoom"

# development
# cask "fig"
cask "iterm2"
# cask "menumeters"
# cask "kdiff3"
cask "p4v" # p4merge
# cask "sublime-text"
# cask "vagrant"
# cask "vagrant-manager"
# cask "virtualbox"
# cask "virtualbox-extension-pack"
cask "visual-studio-code"
# cask "warp"
tap "get-woke/tap"
brew "woke"

# networking
cask "ngrok"
cask "private-internet-access"
cask "tripmode"
# cask "tunnelblick" # OpenVPN client
# cask "wireshark"
mas "NextDNS", id: 1464122853
mas "Tailscale", id: 1475387142
mas "Wireguard", id: 1451685025

# fonts
# https://www.nerdfonts.com/font-downloads
tap "homebrew/cask-fonts"
cask "font-b612"
cask "font-b612-mono"
cask "font-hack-nerd-font"
cask "font-monaspace"

# multimedia
cask "ears"
# cask "exiftool"
cask "gyazo"
# cask "lastfm"
cask "skitch"
cask "spotify"
# cask "vlc"

# quicklook plugins
# cask "betterzipql"
# cask "qlcolorcode"
# cask "qlmarkdown"
# cask "qlprettypatch"
# cask "qlstephen"
# cask "quicklook-csv"
# cask "quicklook-json"
# cask "suspicious-package"

# security
# cask "yubico-yubikey-manager"

# utilities
cask "bartender"
cask "notunes"
# cask "oversight"
mas "Amphetamine", id: 937984704
# mas "Clocker", id: 1056643111
mas "Display Menu", id: 549083868

# virtualization and containerization
# cask "docker"
brew "docker"
brew "docker-compose"
brew "docker-buildx"
brew "lima"
tap "snyk/tap"
brew "snyk"
# cask "utm"

mas "Home Assistant", id: 1099568401
mas "Ivory", id: 6444602274
mas "SongBook", id: 447755419

mas "GarageBand", id: 682658836
mas "iMovie", id: 408981434
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541

# safari extensions
mas "1Password for Safari", id: 1569813296
mas "Archive Page Extension", id: 6446372766
mas "Baking Soda", id: 1601151613
mas "Consent-O-Matic", id: 1606897889
mas "Evernote Web Clipper", id: 1481669779
mas "Hush", id: 1544743900
mas "Keepa - Price Tracker", id: 1533805339

