# claude

Settings for claude code and claude desktop.

## Claude Code

### Language Servers

* Go

    ```shell
    go install golang.org/x/tools/gopls@latest
    claude plugin install gopls-lsp@claude-plugins-official
    ```

* Python

    ```shell
    npm install -g pyright
    claude plugin install pyright-lsp@claude-plugins-official
    ```

* Typescript

    ```shell
    npm install -g typescript-language-server typescript
    claude plugin install typescript-lsp@claude-plugins-official
    ```

### MCP Servers

* Context7

[Context7](https://context7.com/) live docs lookup.

  ```shell
  claude plugin install context7@claude-plugins-official
  ```

* GitHub, plus per-machine servers

  User-scoped MCP servers live in `~/.claude.json`, so they can't be stowed. Register them with:

  ```shell
  ./_setup/claude-setup.sh
  ```

  GitHub uses [`bin/github-mcp`](../bin/github-mcp), which runs the official
  [github-mcp-server](https://github.com/github/github-mcp-server) with the `gh auth token`. It's
  registered twice: `github` (read-write) and `github-read-only` (`--read-only`, which only hides
  write tools; the token keeps all of its scopes). Other servers come from the `mcpServers` key in
  `settings.private.json` (see below), e.g. Notion on machines without the claude.ai Notion connector.

* Terraform

  ```shell
  claude plugin install terraform@claude-plugins-official
  ```

## How settings are split

`~/.dotfiles` is a public repo, so machine-specific and work settings never get committed.

| File | In git | Holds |
| --- | --- | --- |
| `.claude/settings.json` | yes (filtered) | shared settings: hooks, permissions, plugins, status line |
| `.claude/automode.dotfiles.json` | yes | shared auto mode `environment` entries |
| `.claude/settings.private.json` | no (gitignored) | this machine's `model`, auto mode `environment` entries, and `mcpServers` |

* A git clean/smudge filter ([`_tools/claude-settings-filter.sh`](../_tools/claude-settings-filter.sh),
  wired up by `.gitattributes`) strips `model` and `autoMode.environment` from `settings.json` on
  commit, and on checkout rebuilds them from `settings.private.json` plus `automode.dotfiles.json`.
  `mcpServers` is never copied into `settings.json`; `claude-setup.sh` registers those at user scope.
* The filter config lives in `.git/config`, which git never clones. `_setup/repo-setup.sh` sets it up
  (plus pre-commit) for each clone, and also repairs a clone whose filter points at an old path.
* A pre-commit hook ([`_tools/check-claude-settings.sh`](../_tools/check-claude-settings.sh)) fails if
  the staged `settings.json` still has `model` or `autoMode.environment`.
* `.stow-local-ignore` keeps `settings.private.json` and `automode.dotfiles.json` out of `~/.claude`;
  only the filter reads them.
* Each machine's `settings.private.json` is backed up as a 1Password document. The `op://` reference
  is stored only in this clone's git config (`git config dotfiles.claudePrivateOpRef`), so vault and
  item names never reach the repo. Don't write them into any tracked file.
* claude.ai connectors (for example Notion and Linear on the work account) come from the account, not
  this repo. Don't also add them as local MCP servers: a connected local server with the same URL appears to hide the
  connector.

## Set up Claude Code on a machine

For a new machine, `_setup/setup-new-machine.sh` runs steps 1 and 2. For a machine that already has
the repo checked out and Claude Code using its own local config:

1. Pull and configure the clone:

    ```shell
    cd ~/.dotfiles && git pull && _setup/repo-setup.sh
    ```

1. Run `_setup/claude-setup.sh`. It registers the GitHub MCP servers, asks once for this machine's
   `settings.private.json` 1Password reference (blank skips it), pulls the file (asking first if a
   local copy differs), re-runs the filter on `settings.json`, and registers that file's `mcpServers`.
1. Preview the stow, which changes nothing: `stow -n -v claude`. Every existing real file or directory
   in `~/.claude` that the package links (`settings.json`, `CLAUDE.md`, `remote-settings.json`,
   `agents/`, `commands/`, `docs/`, `hooks/`, `output-styles/`, `prompts/`, `rules/`, `scripts/`,
   `skills/`, `statusline/`) shows up as a conflict.
1. Move each conflict aside instead of deleting it:

    ```shell
    mkdir -p ~/.claude.pre-dotfiles && mv ~/.claude/{settings.json,CLAUDE.md,remote-settings.json} ~/.claude.pre-dotfiles/
    ```

    Add any directories step 3 listed. Never use `stow --adopt`: it moves the machine's local files
    into this public repo.
1. `stow claude`, then restart Claude Code. The hooks and status line need `jq` and `node` (both in
   `_setup/Brewfile`).
1. Compare `~/.claude.pre-dotfiles/settings.json` with the stowed one. Put machine-specific values
   (`model`, auto mode rules, MCP servers) in `settings.private.json` and upload them with
   `_tools/claude-private-sync.sh push`. Put general preferences in the shared `settings.json`.

### Notes for Claude

Claude Code's auto mode blocks Claude from changing its own configuration: `settings.json`,
`settings.private.json`, `automode.dotfiles.json`, MCP server config, and stowing over `~/.claude`.
When a step does that, give the user the command to run with a `!` prefix instead of running it or
working around the block.

## Maintenance

* After editing `settings.private.json`, run `_tools/claude-private-sync.sh push`, which overwrites the
  1Password copy. On other machines using the same document, run `_tools/claude-private-sync.sh pull`
  (`claude-setup.sh` runs it too). If the local file differs from 1Password, `pull` asks whether to
  open both in vimdiff and edit the local one (the 1Password side is read-only), overwrite local, or
  keep local. If they still differ afterwards, it prints the `push` command to make 1Password match.
* `/model` writes `model` into the live `settings.json`, which the filter strips on commit and the next
  checkout replaces. To keep a model on a machine, set it in that machine's `settings.private.json`.
* `_tools/claude-settings-filter.sh` runs on every checkout, `git add`, and `git status` that touches
  `settings.json`. If it moves, update `_setup/repo-setup.sh` and re-run it in every clone.
