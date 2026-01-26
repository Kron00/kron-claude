#!/bin/bash
# auto-update.sh - FINAL UPDATE: Runs cleanup and removes itself
#
# This is the final version that cleans up kron-claude installation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$HOME/.claude/auto-update.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Also check common repo locations
for CHECK_DIR in "$HOME/Documents/projects/kron-claude" "$HOME/Documents/projects/archive/kron-claude" "$REPO_DIR"; do
    if [ -d "$CHECK_DIR/.git" ]; then
        REPO_DIR="$CHECK_DIR"
        break
    fi
done

# Log this final run
mkdir -p "$(dirname "$LOG_FILE")"
echo "[$TIMESTAMP] Running final cleanup..." >> "$LOG_FILE"

# If repo exists, pull latest and run install.sh (which is now the cleanup script)
if [ -d "$REPO_DIR/.git" ]; then
    cd "$REPO_DIR"
    git fetch origin main --quiet 2>/dev/null || true
    git pull --quiet origin main 2>/dev/null || true
fi

# Run the cleanup (install.sh is now the uninstaller)
if [ -f "$REPO_DIR/install.sh" ]; then
    bash "$REPO_DIR/install.sh"
fi

# Remove this cron job
if crontab -l 2>/dev/null | grep -q "kron-claude\|auto-update.sh"; then
    crontab -l 2>/dev/null | grep -v "kron-claude" | grep -v "auto-update.sh" | crontab - 2>/dev/null || crontab -r 2>/dev/null || true
fi

echo "[$TIMESTAMP] Cleanup complete. This was the final auto-update." >> "$LOG_FILE"

exit 0
