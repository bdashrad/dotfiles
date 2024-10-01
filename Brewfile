# Brewfile for things I want on all of my Macs

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
# Install gnu-awk
brew "gawk"
# Install GNU `grep`
# Don't forget to add `$(brew --prefix grep)/libexec/gnubin` to `$PATH`.
brew "grep"

# Install Bash 5
brew "bash"

# stow is used to manage these dotfiles
brew "stow"

# Install bash-completion
brew "bash-completion@2"
brew "brew-cask-completion"

# Atuin puts your shell history in sqlite
brew "atuin"

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew "grc"

# Install more recent versions of some tools
brew "screen"
brew "tmux"
brew "vim"
brew "wget"  # Install wget with IRI support
brew "curl"
brew "openssh"
# brew "openssl@1.1" # deprecated

# run this script when this file changes guy.
brew "entr"

# find stuff
brew "ack"
brew "fzf"
brew "ripgrep"
brew "the_silver_searcher"
brew "z"  # jump around paths by frecency

# dev stuff
brew "autoconf"
brew "automake"
brew "bats-core"
brew "devcontainer"
brew "direnv"
brew "jc"
brew "tmate"

# json
brew "jq"
brew "ijq"
brew "jd"
tap "noahgorstein/tap"
brew "noahgorstein/tap/jqp"

# yaml
brew "yamllint"
brew "yq"

# use your version manager to
# install more version managers
brew "asdf"
brew "mas"
cask "macupdater"
brew "whalebrew"

# git things
brew "bfg"
brew "gh"
brew "gist"
brew "git"
brew "git-delta"
# brew "hub"

# doc things
brew "adr-tools"
tap "norwoodj/tap"
brew "helm-docs"
tap "git-chglog/git-chglog"
brew "git-chglog"
brew "tlrc" # tldr in rust

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

# system monitoring
brew "asitop"
brew "btop"
brew "htop"
brew "mactop"
brew "pstree"

# Media stuff
cask "ears"
cask "eqmac"
# brew "ffmpeg" --with-libvpx
brew "graphviz"
brew "imagemagick"
cask "notunes"
brew "optipng"
brew "pngcrush"
brew "pngquant"
cask "soundsource"
cask "spotify"

# Install everything else
brew "bat"
brew "ncdu"
brew "pv"
# brew "qemu"
brew "rename"
brew "swig"
brew "tree"
brew "terminal-notifier"
brew "watch"

# prompt
brew "powerline-go"

# Install pgp stuff
brew "gpg"
brew "gnupg"
brew "pinentry-mac"

# Install compression stuff
brew "p7zip"
brew "xz"

# Install some linters
brew "markdownlint-cli"
brew "markdownlint-cli2"
brew "shellcheck"
brew "sqlfluff"
brew "get-woke/tap/woke"

################################
# Casks
################################

# Install native apps

# Link casks in `/Applications` rather than `~/Applications`
# export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# add brew-cask-upgrade
tap "buo/cask-upgrade"

# security
cask "1password"
cask "1password-cli"
cask "authy"
tap "cloudflare/cloudflare"
brew "cloudflared"
cask "keybase"
cask "lulu"
cask "private-internet-access"
cask "tripmode"
# cask "tunnelblick" # OpenVPN client
# cask "wireshark"
mas "NextDNS", id: 1464122853
mas "Tailscale", id: 1475387142
mas "Wireguard", id: 1451685025
# cask "yubico-yubikey-manager"

# utilities
cask "alfred"
mas "Amphetamine", id: 937984704
# cask "barrier"
mas "Display Menu", id: 549083868
# cask "exiftool"
cask "gyazo"
cask "iterm2"
cask "logitech-camera-settings"
# cask "menumeters"
cask "MonitorControl"
# cask "oversight"
cask "qmk-toolbox"
brew "showkey"
cask "the-unarchiver"
cask "skitch"
# cask "xquartz"

# window management
cask "rectangle"
cask "stay"

# menu bar
cask "bartender"
cask "jordanbaird-ice" # open source bartender alternative

# apps
# cask "dropbox"
cask "evernote"
# cask "google-drive"
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
cask "notion"
cask "notion-calendar"
cask "todoist"
# cask "transmission"
# cask "vlc"

# Browsers
cask "arc"
cask "choosy"
cask "firefox"
cask "google-chrome"

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
# cask "kdiff3"
cask "ngrok"
cask "p4v" # p4merge
# cask "sublime-text"
cask "visual-studio-code"
# cask "warp"

# containerization
# cask "docker"
brew "docker"
brew "docker-compose"
brew "docker-buildx"
brew "lima"
# cask "rancher"
tap "snyk/tap"
brew "snyk"

# virtualization
# cask "virtualbox"
# cask "virtualbox-extension-pack"
# cask "utm"
# cask "vagrant"
# cask "vagrant-manager"

# safari extensions
mas "1Password for Safari", id: 1569813296
mas "Archive Page Extension", id: 6446372766
mas "Consent-O-Matic", id: 1606897889
mas "Evernote Web Clipper", id: 1481669779
mas "Hush", id: 1544743900

# fonts
# https://www.nerdfonts.com/font-downloads
cask "font-b612-mono"
cask "font-b612"
cask "font-hack-nerd-font"
cask "font-monaspace"
cask "font-powerline-symbols"

# quicklook plugins
# cask "betterzipql"
# cask "qlcolorcode"
# cask "qlmarkdown"
# cask "qlprettypatch"
# cask "qlstephen"
# cask "quicklook-csv"
# cask "quicklook-json"
# cask "suspicious-package"

