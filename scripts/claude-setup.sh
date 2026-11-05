#!/usr/bin/env bash

# Configure Claude Code pieces that can't be stowed.
# User-scoped MCP servers live in ~/.claude.json (per-machine state), so register them here.
# Safe to re-run: existing servers are left alone.

set -euo pipefail

for dep in claude gh; do
  command -v "${dep}" > /dev/null || { echo "Error: \`${dep}\` not found in \$PATH." >&2; exit 1; }
done

# bin/github-mcp runs the official github-mcp-server with the gh login token
gh auth status &> /dev/null || gh auth login

claude mcp get github &> /dev/null ||
  claude mcp add github -s user -- "${HOME}/bin/github-mcp"
claude mcp get github-read-only &> /dev/null ||
  claude mcp add github-read-only -s user -- "${HOME}/bin/github-mcp" --read-only

# OAuth happens on first use (/mcp)
claude mcp get notion &> /dev/null ||
  claude mcp add notion -s user --transport http https://mcp.notion.com/mcp

claude mcp list | grep -E '^(github|notion)'
