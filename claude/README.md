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

* GitHub

  With [gh cli plugin for auth](https://github.com/shuymn/gh-mcp)

  ```shell
  gh extension install shuymn/gh-mcp
  ```

  * Install the MCP server in read-only mode:

    ```shell
    GITHUB_READ_ONLY=1
    claude mcp add-json github '{"command":"gh","args":["mcp"],"env":{"GITHUB_READ_ONLY":"1"}}'
    ```

  * Install the MCP server in read-write mode:

    ```shell
    claude mcp add-json github '{"command":"gh","args":["mcp"]}'
    ```

* Terraform

  ```shell
  claude plugin install terraform@claude-plugins-official
  ```
