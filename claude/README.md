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

* GitHub and Notion

  User-scoped MCP servers live in `~/.claude.json`, so they can't be stowed. Register them with:

  ```shell
  ./_setup/claude-setup.sh
  ```

  GitHub uses [`bin/github-mcp`](../bin/github-mcp), which runs the official
  [github-mcp-server](https://github.com/github/github-mcp-server) with the `gh auth token`. It's
  registered twice: `github` (read-write) and `github-read-only` (`--read-only`, which only hides
  write tools; the token keeps all of its scopes).

* Terraform

  ```shell
  claude plugin install terraform@claude-plugins-official
  ```
