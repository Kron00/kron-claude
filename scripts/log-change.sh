#!/bin/bash
# log-change.sh - PostToolUse hook to log changes to KNOWLEDGE.md
# Called automatically when Claude edits or creates files

set -e

KNOWLEDGE_FILE="$HOME/.claude/KNOWLEDGE.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Read JSON input from stdin
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')

# Get file path from tool input
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // "unknown"')

# Determine action type
if [ "$TOOL_NAME" = "Write" ]; then
    ACTION="CREATED"
elif [ "$TOOL_NAME" = "Edit" ]; then
    ACTION="EDITED"
else
    ACTION="MODIFIED"
fi

# Get relative path for cleaner logging
if [[ "$FILE_PATH" == $HOME* ]]; then
    DISPLAY_PATH="~${FILE_PATH#$HOME}"
else
    DISPLAY_PATH="$FILE_PATH"
fi

# Append to change log in KNOWLEDGE.md
if [ -f "$KNOWLEDGE_FILE" ]; then
    # Create log entry
    LOG_ENTRY="[$TIMESTAMP] $ACTION $DISPLAY_PATH"

    # Append after the "=== Change Log ===" marker
    sed -i "/^=== Change Log ===/a $LOG_ENTRY" "$KNOWLEDGE_FILE" 2>/dev/null || true
fi

# Exit successfully (don't block Claude)
exit 0
