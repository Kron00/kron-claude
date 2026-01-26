#!/bin/bash
# install.sh - DEPRECATED: Now performs cleanup/uninstall
#
# This project has been discontinued. Running this script will:
# - Remove kron-claude configuration
# - Remove claude-mem plugin and hooks
# - Remove the auto-update cron job
# - Clean up all related files

set -e

CLAUDE_DIR="$HOME/.claude"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         kron-claude has been DISCONTINUED                     ║"
echo "║         This script will clean up your installation           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

#######################################
# REMOVE CRON JOB
#######################################
echo "Step 1: Removing auto-update cron job..."
if crontab -l 2>/dev/null | grep -q "kron-claude\|auto-update.sh"; then
    crontab -l 2>/dev/null | grep -v "kron-claude" | grep -v "auto-update.sh" | crontab - 2>/dev/null || crontab -r 2>/dev/null || true
    echo "  ✓ Removed cron job"
else
    echo "  (no cron job found)"
fi

#######################################
# REMOVE CLAUDE-MEM PLUGIN
#######################################
echo ""
echo "Step 2: Removing claude-mem plugin..."
if command -v claude &> /dev/null; then
    claude plugin uninstall claude-mem@thedotmack 2>/dev/null || true
    echo "  ✓ Uninstalled claude-mem plugin"
else
    echo "  (claude CLI not found, skipping plugin removal)"
fi

# Remove plugin cache and marketplace files
rm -rf "$CLAUDE_DIR/plugins/cache/thedotmack" 2>/dev/null || true
rm -rf "$CLAUDE_DIR/plugins/marketplaces/thedotmack" 2>/dev/null || true
echo "  ✓ Removed plugin files"

#######################################
# REMOVE HOOKS
#######################################
echo ""
echo "Step 3: Removing hooks..."
if command -v claude &> /dev/null; then
    claude config set hooks '[]' 2>/dev/null || true
    echo "  ✓ Cleared hooks configuration"
fi

# Clear hooks.json
if [ -f "$CLAUDE_DIR/hooks.json" ]; then
    echo '{"hooks":{}}' > "$CLAUDE_DIR/hooks.json"
    echo "  ✓ Cleared hooks.json"
fi

# Remove hookify PostToolUse hooks
HOOKIFY_FILE="$CLAUDE_DIR/plugins/marketplaces/claude-plugins-official/plugins/hookify/hooks/hooks.json"
if [ -f "$HOOKIFY_FILE" ]; then
    cat > "$HOOKIFY_FILE" << 'EOF'
{
  "description": "Hookify plugin - disabled",
  "hooks": {}
}
EOF
    echo "  ✓ Disabled hookify hooks"
fi

#######################################
# REMOVE KRON-CLAUDE SCRIPTS
#######################################
echo ""
echo "Step 4: Removing kron-claude scripts..."
for script in log-change.sh discover-services.sh scan-env-vars.sh auto-update.sh cleanup-agents.sh; do
    if [ -f "$CLAUDE_DIR/scripts/$script" ]; then
        rm "$CLAUDE_DIR/scripts/$script"
        echo "  ✓ Removed $script"
    fi
done

#######################################
# REMOVE SKILLS
#######################################
echo ""
echo "Step 5: Removing kron-claude skills..."
for skill in document code-review test-runner git-workflow build-agent; do
    if [ -d "$CLAUDE_DIR/skills/$skill" ]; then
        rm -rf "$CLAUDE_DIR/skills/$skill"
        echo "  ✓ Removed skill: $skill"
    fi
done

#######################################
# REMOVE SYMLINKS
#######################################
echo ""
echo "Step 6: Removing symlinks..."
if [ -L "$HOME/bin/kron-install" ]; then
    rm "$HOME/bin/kron-install"
    echo "  ✓ Removed ~/bin/kron-install"
fi

#######################################
# REMOVE LOG FILES
#######################################
echo ""
echo "Step 7: Cleaning up logs..."
rm -f "$CLAUDE_DIR/auto-update.log" 2>/dev/null || true
echo "  ✓ Removed auto-update.log"

#######################################
# REMOVE SETTINGS AND KNOWLEDGE
#######################################
echo ""
echo "Step 8: Removing settings and knowledge files..."
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    rm -f "$CLAUDE_DIR/settings.json"
    echo "  ✓ Removed settings.json"
fi
if [ -f "$CLAUDE_DIR/KNOWLEDGE.md" ]; then
    rm -f "$CLAUDE_DIR/KNOWLEDGE.md"
    echo "  ✓ Removed KNOWLEDGE.md"
fi

#######################################
# PRESERVE USER DATA
#######################################
echo ""
echo "Preserved (not deleted):"
echo "  - ~/.claude/CLAUDE.md (your configuration)"
echo "  - Other Claude Code data and plugins"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              Cleanup Complete!                                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "kron-claude has been removed from your system."
echo "You may delete this repository: rm -rf ~/Documents/projects/archive/kron-claude"
echo ""
echo "Restart Claude Code for changes to take effect."
echo ""
