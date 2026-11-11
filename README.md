# brad's dotfiles

Manage dotfiles, configs, etc. for macOS using bash, GNU stow, and more.

## How to use

1. Clone the repo: `git clone git@github.com:bdashrad/dotfiles.git ~/.dotfiles`
    * Clone it with git; a tarball download won't work. The Claude Code setup uses a git filter and this
      clone's git config to keep machine-specific settings out of the repo (see
      [claude/README.md](claude/README.md)), and the pre-commit hooks need git too.
1. `cd ~/.dotfiles`
1. `_setup/setup-new-machine.sh`
    * It asks before each optional step.
    * It stows every package, so there's no separate stow step. To add or re-check a single package
      later, preview it first with `stow -n -v <pkg>`, then run `stow <pkg>`.
1. Add machine-specific settings that shouldn't be committed (see [Local, uncommitted config](#local-uncommitted-config)).
1. Enjoy!

## Layout

Every top-level directory except `_setup/` and `_tools/` is a [stow](https://www.gnu.org/software/stow/)
package whose contents mirror `$HOME`, e.g. `bash/.bashrc` links to `~/.bashrc`. A few differ:

* `bin/` stows into `~/bin`, and `ssh/` into `~/.ssh`.
* `gnupg/gpg-agent.conf` isn't stowed; the setup script fills in the Homebrew prefix and writes it to `~/.gnupg/`.
* `iterm2/` stows `~/prefs`, which iTerm2 is configured to load its preferences from (and write them back to).
* `claude/` is the Claude Code config; see [claude/README.md](claude/README.md).

### `_setup/`

Run by, or alongside, `setup-new-machine.sh`.

| Path | What it does |
| --- | --- |
| `setup-new-machine.sh` | Full machine setup: Homebrew, Brewfiles, login shell, macOS defaults, stow, asdf, and the scripts below |
| `repo-setup.sh` | Configures this clone: the Claude settings git filter and pre-commit hooks. Needed in every clone, since git never copies `.git/config` |
| `claude-setup.sh` | Registers user-scoped MCP servers, and pulls `settings.private.json` from 1Password |
| `gh-cli.sh` | Installs GitHub CLI extensions |
| `install-ble.sh` | Installs [ble.sh](https://github.com/akinomyoga/ble.sh) |
| `osx.sh` | macOS defaults |
| `touchid_sudo.sh` | Enables Touch ID for `sudo` |
| `requirements.in` | Python packages to move to `uv` entries in the Brewfiles; nothing installs it |
| `krew-plugins.txt` | kubectl plugins, installed with the Kubernetes tools |

### Brewfiles

`Brewfile` is always installed. The setup script asks about each of the others, except `vscode.Brewfile`,
which it doesn't install.

| Brewfile | Contents |
| --- | --- |
| `Brewfile` | Base CLI tools and apps for every machine |
| `work.Brewfile` | Work-only apps |
| `home.Brewfile` | Personal-only apps |
| `safari.Brewfile` | Safari extensions (Mac App Store) |
| `cloud-iac.Brewfile` | Cloud and infrastructure-as-code tools, with the `gcloud` and `terraform` packages |
| `containers.Brewfile` | Container tools, with the `docker` and `colima` packages |
| `kubernetes.Brewfile` | Kubernetes tools |
| `vscode.Brewfile` | VS Code extensions |

Install one by hand with `brew bundle install --file _setup/<name>.Brewfile`.

### `_tools/`

Run occasionally, or by git and pre-commit, not during setup.

| Path | What it does |
| --- | --- |
| `claude-private-sync.sh pull\|push` | Syncs `claude/.claude/settings.private.json` with 1Password; pull asks before changing a local file that differs |
| `claude-settings-filter.sh` | The git clean and smudge filter for `claude/.claude/settings.json` |
| `check-claude-settings.sh` | pre-commit check that no machine-specific values are staged in `settings.json` |
| `bun-completion-patch.sh` | Patches bun's bash completion; re-run after `brew upgrade bun` |

## Local, uncommitted config

This repo is public, so secrets and machine-specific settings go in files it never tracks:

* `~/.extra`: sourced by `~/.bash_profile` before the other shell dotfiles, for environment variables,
  API keys, and anything else per machine. For example:

    ```bash
    export PLGO_PATH_ALIAS='~/code/mycompany=@MC,~/code/google=@'
    ```

* `~/.override.local`: sourced last by `~/.bash_profile`, after the committed `~/.override`, for settings that must
  win over everything else.
* `~/.gitconfig.local`: included at the end of the git config (`git/.config/git/config`), so it overrides
  it. Use it for a work email, signing key, or `includeIf` rules for work repos.
* `~/.ssh/config.d/`: every file in it is included at the top of `~/.ssh/config`, so its `Host` entries
  take precedence. The directory is stowed, but its contents are gitignored. `ssh/.ssh/config.example`
  shows the layout.
* `claude/.claude/settings.private.json`: machine-specific Claude Code settings, gitignored and synced
  with 1Password; see [claude/README.md](claude/README.md).

## Manual Migrations

Things this repo doesn't cover, to carry over from the old machine.

* [ ] Keybase: remove the old machine from your devices (keybase.io, or `keybase device remove` on it), then add
  the new machine as a new device
* [ ] gpg keys: import from Keybase (`keybase pgp export -s | gpg --allow-secret-key-import --import`) or
  1Password, and keep a copy in 1Password
* [ ] `~/.extra`, `~/.override.local`, `~/.gitconfig.local`, and `~/.ssh/config.d/`
* [ ] atuin: `atuin login` to sync shell history
* [ ] Sign in to CLIs: `gh auth login`, `gcloud auth login`, 1Password CLI, and kube contexts
* [ ] Apps and packages not in a Brewfile: on the old machine, run
  `brew bundle cleanup --file=<(cat _setup/Brewfile _setup/*.Brewfile)` and answer no at the prompt. Without
  `--force` it only lists the formulae, casks, taps, and Mac App Store apps no Brewfile mentions; add any you
  want to one. It fails on taps that aren't trusted on that machine, so leave out Brewfiles you didn't install
* [ ] krew plugins, on machines with Kubernetes: `kubectl krew list > _setup/krew-plugins.txt`, then commit it
* [ ] Global npm packages (`npm list -g --depth=0`) and gems (`gem list`) missing from `node-modules.txt` or
  `Gemfile`
* [ ] Python packages listed in `_setup/requirements.in`, until they move to the Brewfiles
* [ ] Install Package Control for Sublime Text 3 from `sublime/`
* [ ] If they aren't in iCloud:
  * Wi-Fi networks and passwords: the System keychain, and `/Library/Preferences/com.apple.wifi.known-networks.plist`
  * Documents folder
* [ ] Automator scripts in `~/Library/Services`
* [ ] `/etc/hosts`
* [ ] App settings that don't sync on their own, like Alfred
* [ ] Anything in `~/.config/` that isn't stowed

## Thanks to

Lots of this content taken from various people, but particularly

[paulirish](https://github.com/paulirish/dotfiles/)

[mathiasbynens](https://github.com/mathiasbynens/dotfiles/)
