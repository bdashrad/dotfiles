# brad's dotfiles

Manage dotfiles, configs, etc using bash, gnu stow, and more.

## How to use

1. Download dotfiles
    * Clone repo: `git clone git@github.com:bdashrad/dotfiles.git ~/dotfiles`
    * Install without git: `mkdir -p ~/.dotfiles; curl -#L https://github.com/bdashrad/dotfiles/tarball/main | tar -xzv --strip-components=1 -C ~/.dotfiles/`
2. `cd ~/dotfiles`
3. `setup-new-machine.sh`
4. use [stow](https://www.gnu.org/software/stow/) to install various config files:
    * standards
      * `stow {bash,fzf,git,hugo,ruby,screen,tmux,vagrant,vim}`
    * ~/home/bin
      * `mkdir -p ~/bin`
      * `stow -t ~/bin/ bin`
    * sublime text 3
      * `stow -t ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/ sublime/`
5. Enjoy!

## Manual Migrations

* [ ] python
  * [ ] install from `requirements.txt`
  * [ ] updates in `requirements.in` and generated with `pip-compile` see [pip-tools](https://github.com/jazzband/pip-tools)
* [ ] keybase.io device
* [ ] gpg keys
* [ ] .app's I really want and aren't in my caskfile.
* [ ] read `brew list` and `brew cask list` to see whats worth reinstalling
* [ ] read `npm list -g --depth=0` to see global npm packages
* [ ] read `gem list` to see gems
* [ ] missing .osx settings?
* [ ] bash history?
* [ ] Install Package Control for Sublime Text 3 from `sublime/`
* [ ] Wifi Settings and passwords
  * `/Volumes/MacintoshHD/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist`
* [ ] `.extra`
* [ ] `.gitconfig.local`
* [ ] extra `.ssh`
* [ ] `.gnupg`
* [ ] `~/.config/`
* [ ] Tunnelblick Profiles
* [ ] Automator scripts
  * `~/Library/Services`
* [ ] Documents folder
* [ ] /etc/hosts
* [ ] [kubectl krew](https://github.com/kubernetes-sigs/krew)
  * [access-matrix](https://github.com/corneliusweig/rakkess)
  * [nginx-ingress](https://kubernetes.github.io/ingress-nginx/kubectl-plugin/)

## Thanks to

Lots of this content taken from various people, but particularly

[paulirish](https://github.com/paulirish/dotfiles/)

[mathiasbynens](https://github.com/mathiasbynens/dotfiles/)
