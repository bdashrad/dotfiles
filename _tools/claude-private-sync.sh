#!/usr/bin/env bash

# Sync claude/.claude/settings.private.json with the 1Password document this clone points at.
# The secret reference lives only in this clone's git config, so vault and item names are never committed:
#   git config dotfiles.claudePrivateOpRef 'op://<vault>/<item>/<file>'
#
# Usage:
#   claude-private-sync.sh pull   # 1Password -> local file (overwrites it), then re-smudge settings.json
#   claude-private-sync.sh push   # local file -> 1Password document (overwrites it)

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
private="${repo}/claude/.claude/settings.private.json"
settings=claude/.claude/settings.json

for dep in op jq; do
  command -v "${dep}" > /dev/null || { echo "Error: \`${dep}\` not found in \$PATH." >&2; exit 1; }
done

ref="$(git -C "${repo}" config --get dotfiles.claudePrivateOpRef || true)"
if [[ "${ref}" != op://* ]]; then
  echo "Error: no 1Password reference set; run _setup/claude-setup.sh or:" >&2
  echo "  git -C ${repo} config dotfiles.claudePrivateOpRef 'op://<vault>/<item>/<file>'" >&2
  exit 1
fi

case "${1:-}" in
  pull)
    tmp="$(mktemp)"
    trap 'rm -f "${tmp}"' EXIT
    op read --force --out-file "${tmp}" "${ref}" > /dev/null
    jq -e . "${tmp}" > /dev/null || { echo "Error: ${ref} is not valid JSON." >&2; exit 1; }
    mv "${tmp}" "${private}"
    chmod 600 "${private}"
    echo "Wrote ${private}"
    # re-smudge settings.json if the filter is set up and the file has no local edits
    if git -C "${repo}" config --get filter.claude-settings.smudge > /dev/null &&
      git -C "${repo}" diff --quiet -- "${settings}"; then
      rm "${repo}/${settings}"
      git -C "${repo}" checkout -- "${settings}"
    fi
    ;;
  push)
    jq -e . "${private}" > /dev/null || { echo "Error: ${private} is not valid JSON." >&2; exit 1; }
    # op://<vault>/<item>/<file>; op document edit takes the item and vault separately
    path="${ref#op://}"
    vault="${path%%/*}"
    path="${path#*/}"
    item="${path%%/*}"
    op document edit "${item}" --vault "${vault}" "${private}"
    echo "Updated 1Password document from ${private}"
    ;;
  *)
    echo "usage: $0 pull|push" >&2
    exit 1
    ;;
esac
