#!/bin/bash

# Constants
readonly NOTIFIER="/opt/homebrew/bin/terminal-notifier"

# Get the name of the current directory for context
readonly CURRENT_DIR
CURRENT_DIR=$(basename "${PWD}")

# Set notification parameters based on type (input validation via case)
case "$1" in
permission)
  title="🚧 Claude Code"
  subtitle="Permission Required"
  message="Claude needs approval in [$CURRENT_DIR]."
  sound="Glass"
  ;;
plan)
  title="📋 Claude Code"
  subtitle="Plan Ready"
  message="Please review the plan in [$CURRENT_DIR]."
  sound="Ping"
  ;;
stop)
  title="✅ Claude Code"
  subtitle="Completed"
  message="Task completed in [$CURRENT_DIR]."
  sound="Hero"
  ;;
idle)
  title="💬 Claude Code"
  subtitle="Ready for Input"
  message="Claude is waiting for you in [$CURRENT_DIR]."
  sound="Glass"
  ;;
*)
  # Invalid input - exit silently
  exit 0
  ;;
esac

# Send notification with terminal-notifier (all variables quoted)
"$NOTIFIER" \
  -title "$title" \
  -subtitle "$subtitle" \
  -message "$message" \
  -sound "$sound" \
  -group "claude-code"
