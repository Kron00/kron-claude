#!/bin/bash
# install.sh - Install kron-claude configuration
# Usage: ./install.sh
#
# This script sets up the complete Claude Code configuration:
# - CLAUDE.md (main config)
# - KNOWLEDGE.md (persistent memory)
# - Skills (document, code-review, test-runner, git-workflow)
# - Scripts (change logging, service discovery)
# - Hooks (auto-logging)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           kron-claude Configuration Installer                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating $CLAUDE_DIR..."
    mkdir -p "$CLAUDE_DIR"
fi

# Backup existing files
backup_if_exists() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up $file to $backup"
        cp "$file" "$backup"
    fi
}

echo ""
echo "Step 1: Installing CLAUDE.md..."
backup_if_exists "$CLAUDE_DIR/CLAUDE.md"
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  ✓ CLAUDE.md installed"

echo ""
echo "Step 2: Installing KNOWLEDGE.md..."
if [ -f "$CLAUDE_DIR/KNOWLEDGE.md" ]; then
    echo "  KNOWLEDGE.md already exists, preserving existing data"
    echo "  (New template available at $SCRIPT_DIR/KNOWLEDGE.md)"
else
    cp "$SCRIPT_DIR/KNOWLEDGE.md" "$CLAUDE_DIR/KNOWLEDGE.md"
    echo "  ✓ KNOWLEDGE.md installed"
fi

echo ""
echo "Step 3: Installing skills..."
mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/"
    echo "  ✓ Skill: $skill_name"
done

echo ""
echo "Step 4: Installing scripts..."
mkdir -p "$CLAUDE_DIR/scripts"
cp "$SCRIPT_DIR/scripts/"*.sh "$CLAUDE_DIR/scripts/"
chmod +x "$CLAUDE_DIR/scripts/"*.sh
echo "  ✓ Scripts installed and made executable"

echo ""
echo "Step 5: Setting up hooks..."
# Check if settings.json exists and has hooks configured
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
    # Check if hooks are already configured
    if grep -q '"hooks"' "$SETTINGS_FILE" 2>/dev/null; then
        echo "  Hooks already configured in settings.json"
        echo "  To add change logging, ensure this hook exists:"
        echo '  {"event": "PostToolUse", "matcher": "Edit|Write", "command": "~/.claude/scripts/log-change.sh"}'
    else
        echo "  Note: Add hooks to $SETTINGS_FILE manually or via Claude Code settings"
    fi
else
    echo "  Note: No settings.json found. Hooks will need to be configured via Claude Code."
    echo "  Run: claude config set hooks '[{\"event\":\"PostToolUse\",\"matcher\":\"Edit|Write\",\"command\":\"~/.claude/scripts/log-change.sh\"}]'"
fi

echo ""
echo "Step 6: Installing claude-mem plugin..."
# Check if claude CLI is available
if command -v claude &> /dev/null; then
    # Add marketplace (|| true to not fail if already added)
    echo "  Adding marketplace..."
    claude plugin marketplace add thedotmack/claude-mem 2>/dev/null || true

    # Update marketplace
    echo "  Updating marketplace..."
    claude plugin marketplace update thedotmack 2>/dev/null || true

    # Install plugin
    echo "  Installing claude-mem..."
    if claude plugin install claude-mem@thedotmack 2>/dev/null; then
        echo "  ✓ claude-mem plugin installed"
    else
        echo "  Note: claude-mem may already be installed or requires manual installation"
        echo "  Run manually: claude plugin install claude-mem@thedotmack"
    fi
else
    echo "  Claude CLI not found. Install claude-mem manually after installing Claude Code:"
    echo "  claude plugin marketplace add thedotmack/claude-mem"
    echo "  claude plugin install claude-mem@thedotmack"
fi
echo ""

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   Installation Complete!                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Installed to: $CLAUDE_DIR"
echo ""
echo "Files installed:"
echo "  - CLAUDE.md         (main configuration)"
echo "  - KNOWLEDGE.md      (persistent memory/service registry)"
echo "  - skills/           (document, code-review, test-runner, git-workflow)"
echo "  - scripts/          (log-change.sh, discover-services.sh, scan-env-vars.sh)"
echo ""
echo "Quick start:"
echo "  1. Start Claude Code"
echo "  2. Run: ~/.claude/scripts/discover-services.sh  (optional: discover existing projects)"
echo "  3. Run: ~/.claude/scripts/scan-env-vars.sh      (optional: find env vars)"
echo ""
echo "To sync across machines:"
echo "  1. Commit changes to kron-claude repo"
echo "  2. On new machine: git clone && ./install.sh"
echo ""
