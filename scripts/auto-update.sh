#!/bin/bash
# auto-update.sh - Check for updates and pull latest kron-claude config
# Designed to run via cron every 10 minutes

set -e

REPO_DIR="$HOME/Documents/projects/kron-claude"
LOG_FILE="$HOME/.claude/auto-update.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Check if repo exists
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "[$TIMESTAMP] ERROR: kron-claude repo not found at $REPO_DIR" >> "$LOG_FILE"
    exit 1
fi

cd "$REPO_DIR"

# Fetch latest from remote
git fetch origin main --quiet 2>/dev/null || {
    echo "[$TIMESTAMP] ERROR: Failed to fetch from origin" >> "$LOG_FILE"
    exit 1
}

# Check if there are updates
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$TIMESTAMP] Updates found, pulling..." >> "$LOG_FILE"

    # Pull changes
    if git pull --quiet origin main 2>/dev/null; then
        echo "[$TIMESTAMP] Successfully pulled updates" >> "$LOG_FILE"

        # Re-run install to apply changes (skip plugin install to avoid issues in cron)
        if [ -f "$REPO_DIR/install.sh" ]; then
            # Copy updated files to ~/.claude
            cp "$REPO_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" 2>/dev/null || true

            # Update skills
            for skill_dir in "$REPO_DIR/skills"/*/; do
                skill_name=$(basename "$skill_dir")
                mkdir -p "$HOME/.claude/skills/$skill_name"
                cp -r "$skill_dir"* "$HOME/.claude/skills/$skill_name/" 2>/dev/null || true
            done

            # Update scripts
            cp "$REPO_DIR/scripts/"*.sh "$HOME/.claude/scripts/" 2>/dev/null || true
            chmod +x "$HOME/.claude/scripts/"*.sh 2>/dev/null || true

            echo "[$TIMESTAMP] Configuration files updated" >> "$LOG_FILE"
        fi
    else
        echo "[$TIMESTAMP] ERROR: Failed to pull updates" >> "$LOG_FILE"
        exit 1
    fi
else
    # No updates - only log occasionally to avoid huge log files
    MINUTE=$(date '+%M')
    if [ "$MINUTE" = "00" ]; then
        echo "[$TIMESTAMP] No updates available" >> "$LOG_FILE"
    fi
fi

# Trim log file if too large (keep last 500 lines)
if [ -f "$LOG_FILE" ] && [ $(wc -l < "$LOG_FILE") -gt 500 ]; then
    tail -200 "$LOG_FILE" > "$LOG_FILE.tmp"
    mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

exit 0
