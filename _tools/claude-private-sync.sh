#!/usr/bin/env bash

# Sync claude/.claude/settings.private.json with the 1Password document this clone points at.
# The secret reference lives only in this clone's git config, so vault and item names are never committed:
#   git config dotfiles.claudePrivateOpRef 'op://<vault>/<item>/<file>'
#
# Usage:
#   claude-private-sync.sh pull   # 1Password -> local file, then re-smudge settings.json; if the local file
#                                 # differs, asks to vimdiff, overwrite, or keep it
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
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "${tmpdir}"' EXIT
    # named so it's recognizable in vimdiff
    remote="${tmpdir}/settings.private.1password.json"
    op read --force --out-file "${remote}" "${ref}" > /dev/null
    jq -e . "${remote}" > /dev/null || { echo "Error: ${ref} is not valid JSON." >&2; exit 1; }

    if [[ -f "${private}" ]] && cmp -s "${private}" "${remote}"; then
      echo "Already up to date: ${private}"
      exit 0
    fi

    if [[ -f "${private}" ]]; then
      # never overwrite local changes without asking
      [[ -t 0 ]] || { echo "Error: ${private} differs from 1Password; re-run interactively." >&2; exit 1; }
      echo "${private} differs from the 1Password copy."
      read -r -p "[v]imdiff and edit local, [o]verwrite local with 1Password, or [k]eep local? [v/o/K] " reply
      case "${reply}" in
        [Vv])
          # left: local file (editable); right: 1Password copy (read-only). ]c/[c jump between changes,
          # `do` copies the 1Password side's change into local; :wqa saves and quits
          vim -d "${private}" "${remote}" -c 'wincmd l' -c 'setlocal nomodifiable' -c 'wincmd h'
          jq -e . "${private}" > /dev/null || { echo "Error: ${private} is no longer valid JSON." >&2; exit 1; }
          ;;
        [Oo])
          cp "${remote}" "${private}"
          echo "Wrote ${private}"
          ;;
        *)
          echo "Kept ${private}."
          ;;
      esac
      if ! cmp -s "${private}" "${remote}" 2> /dev/null; then
        echo "Local and 1Password still differ. To make 1Password match local, run:"
        echo "  ${repo}/_tools/claude-private-sync.sh push"
      fi
    else
      cp "${remote}" "${private}"
      echo "Wrote ${private}"
    fi
    chmod 600 "${private}"

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
