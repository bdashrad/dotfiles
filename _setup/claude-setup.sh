#!/usr/bin/env bash

# Configure Claude Code pieces that can't be stowed.
# User-scoped MCP servers live in ~/.claude.json (per-machine state), so register them here.
# Safe to re-run: existing servers are left alone.

set -euo pipefail

for dep in claude gh jq; do
  command -v "${dep}" > /dev/null || { echo "Error: \`${dep}\` not found in \$PATH." >&2; exit 1; }
done

# bin/github-mcp runs the official github-mcp-server with the gh login token
gh auth status &> /dev/null || gh auth login

claude mcp get github &> /dev/null ||
  claude mcp add github -s user -- "${HOME}/bin/github-mcp"
claude mcp get github-read-only &> /dev/null ||
  claude mcp add github-read-only -s user -- "${HOME}/bin/github-mcp" --read-only

# settings.private.json (machine-specific auto mode rules and model) is gitignored. Ask once for the
# 1Password reference to pull it from and keep it in this clone's git config, so vault and item names are
# never committed. _tools/claude-private-sync.sh pull|push uses the same reference later.
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
private="${repo}/claude/.claude/settings.private.json"
op_ref="$(git -C "${repo}" config --get dotfiles.claudePrivateOpRef || true)"
if [[ -z "${op_ref}" ]] && command -v op > /dev/null; then
  read -r -p "1Password reference for settings.private.json (op://<vault>/<item>/<file>), blank to skip: " op_ref
  if [[ "${op_ref}" == op://* ]]; then
    git -C "${repo}" config dotfiles.claudePrivateOpRef "${op_ref}"
  elif [[ -n "${op_ref}" ]]; then
    echo "Not an op:// reference; skipping." >&2
    op_ref=""
  fi
fi
if [[ -n "${op_ref}" && ! -f "${private}" ]]; then
  "${repo}/_tools/claude-private-sync.sh" pull || echo "Could not pull settings.private.json; skipping." >&2
fi

# machine-specific user-scoped MCP servers, from settings.private.json's mcpServers (same shape as
# ~/.claude.json); the settings filter ignores this key, so it never reaches settings.json
if [[ -f "${private}" ]]; then
  while IFS=$'\t' read -r name config; do
    claude mcp get "${name}" &> /dev/null || claude mcp add-json -s user "${name}" "${config}"
  done < <(jq -r '.mcpServers // {} | to_entries[] | "\(.key)\t\(.value | tojson)"' "${private}")
fi

claude mcp list
