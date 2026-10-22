#!/usr/bin/env bash

# inspired by https://forum.atuin.sh/t/changing-the-host-associated-with-commands-in-history/888/5

ATUIN_DIR="${HOME}/.local/share/atuin"
HISTORY_DB="${ATUIN_DIR}/history.db"
BACKUP_DIR="${HOME}/atuin-rename-backups"
TEMP_DB="$(mktemp "${TMPDIR:-/tmp}/atuin_transform.XXXXXX")"

trap 'rm -f "${TEMP_DB}"' EXIT

function sql_quote() {
  local s="${1//\'/\'\'}"
  printf "'%s'" "$s"
}

function list_hosts() {
  sqlite3 "${TEMP_DB}" "SELECT hostname FROM history GROUP BY hostname ORDER BY hostname;"
}

function backup_history() {
  # .backup gives us a clean, non-WAL working copy
  echo "[+] Backing up Atuin history to ${TEMP_DB}..."
  rm -f "${TEMP_DB}"
  sqlite3 "${HISTORY_DB}" ".backup '${TEMP_DB}'"

  # Keep a persistent, timestamped copy of the original (pre-rename) DB
  mkdir -p "${BACKUP_DIR}"
  local saved
  saved="${BACKUP_DIR}/history-$(date +%Y%m%d-%H%M%S).db"
  cp "${TEMP_DB}" "${saved}"
  echo "[+] Original saved to ${saved}"
}

function pick_host() {
  # usage: pick_host "prompt" [allow_other]; sets PICKED, returns 1 on cancel
  local prompt="$1" allow_other="$2" hosts=() choices
  # shellcheck disable=SC2312
  while IFS= read -r h; do hosts+=("${h}"); done < <(list_hosts)
  choices=("${hosts[@]}")
  [[ -n "${allow_other}" ]] && choices+=("other")
  choices+=("cancel")

  echo "${prompt}"
  PS3="> "
  select choice in "${choices[@]}"; do
    case "${choice}" in
      "") echo "Invalid selection." ;;
      cancel) return 1 ;;
      other)
        read -r -p "New hostname:user: " PICKED
        [[ -n "${PICKED}" ]] && return 0
        ;;
      *)
        PICKED="${choice}"
        return 0
        ;;
    esac
  done
  return 1
}

function rename_host() {
  local old new count
  pick_host "Which hostname:user to rename?" || return 0
  old="${PICKED}"
  pick_host "Rename '${old}' to:" other || return 0
  new="${PICKED}"

  if [[ "${old}" == "${new}" ]]; then
    echo "[-] Old and new are identical; nothing to do."
    return 0
  fi

  # shellcheck disable=SC2312
  count=$(sqlite3 "${TEMP_DB}" "SELECT COUNT(*) FROM history WHERE hostname = $(sql_quote "${old}");")
  echo "[+] Renaming ${count} rows: '${old}' -> '${new}'"
  # shellcheck disable=SC2312
  sqlite3 "${TEMP_DB}" "UPDATE history SET hostname = $(sql_quote "${new}") WHERE hostname = $(sql_quote "${old}");"
}

function save_to_atuin() {
  echo "[+] Vacuuming temporary database..."
  sqlite3 "${TEMP_DB}" "VACUUM;"

  echo "[+] Restoring transformed history to Atuin..."
  sqlite3 "${HISTORY_DB}" ".restore '${TEMP_DB}'"

  rm -f "${ATUIN_DIR}/records.db"*
  atuin history init-store

  echo "[!] Local database updated via .restore. Ready for 'atuin store push --force'."
}

backup_history

while true; do
  rename_host
  echo
  PS3="Next action> "
  select action in "Rename another hostname:user" "Save to atuin" "Exit without saving"; do
    case "${action}" in
      "Rename another hostname:user") break ;;
      "Save to atuin")
        save_to_atuin
        exit 0
        ;;
      "Exit without saving")
        echo "[+] Discarding changes."
        exit 0
        ;;
      *) echo "Invalid selection." ;;
    esac
  done
done
