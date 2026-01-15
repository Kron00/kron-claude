#!/bin/bash
# uninstall.sh - Remove kron-claude configuration
# Usage: ./uninstall.sh
#
# This script removes the kron-claude configuration but preserves:
# - KNOWLEDGE.md (your accumulated data)
# - Any backups created during install

set -e

CLAUDE_DIR="$HOME/.claude"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           kron-claude Configuration Uninstaller               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

read -p "This will remove kron-claude configuration. Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "Removing configuration..."

# Remove CLAUDE.md (but keep backups)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    rm "$CLAUDE_DIR/CLAUDE.md"
    echo "  ✓ Removed CLAUDE.md"
fi

# Remove skills
for skill in document code-review test-runner git-workflow; do
    if [ -d "$CLAUDE_DIR/skills/$skill" ]; then
        rm -rf "$CLAUDE_DIR/skills/$skill"
        echo "  ✓ Removed skill: $skill"
    fi
done

# Remove scripts
for script in log-change.sh discover-services.sh scan-env-vars.sh; do
    if [ -f "$CLAUDE_DIR/scripts/$script" ]; then
        rm "$CLAUDE_DIR/scripts/$script"
        echo "  ✓ Removed script: $script"
    fi
done

echo ""
echo "Preserved:"
echo "  - KNOWLEDGE.md (your data)"
echo "  - Any .backup files"
echo "  - Other Claude Code data"
echo ""
echo "Uninstall complete."
