#!/bin/bash
# install.sh - Install kron-claude configuration
#
# Usage:
#   ./install.sh           # Global install to ~/.claude/
#   ./install.sh --project # Project install to ./.claude/
#
# Global install sets up:
#   - CLAUDE.md, KNOWLEDGE.md, skills, scripts, hooks, claude-mem plugin
#
# Project install sets up:
#   - Project-specific .claude/ directory with CLAUDE.md and optional skills

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_MODE="global"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project|-p)
            INSTALL_MODE="project"
            shift
            ;;
        --help|-h)
            echo "Usage: ./install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  (no args)     Global install to ~/.claude/"
            echo "  --project, -p Project install to ./.claude/ (current directory)"
            echo "  --help, -h    Show this help message"
            echo ""
            echo "Global install includes: CLAUDE.md, KNOWLEDGE.md, skills, scripts, plugins"
            echo "Project install includes: Project-specific CLAUDE.md template"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Backup existing files
backup_if_exists() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "  Backing up to $(basename "$backup")"
        cp "$file" "$backup"
    fi
}

#######################################
# PROJECT INSTALL
#######################################
if [ "$INSTALL_MODE" = "project" ]; then
    PROJECT_DIR="$(pwd)"
    CLAUDE_DIR="$PROJECT_DIR/.claude"

    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║         kron-claude Project Configuration Installer          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Installing to: $CLAUDE_DIR"
    echo ""

    # Create .claude directory
    mkdir -p "$CLAUDE_DIR"

    # Create project CLAUDE.md
    echo "Creating project CLAUDE.md..."
    backup_if_exists "$CLAUDE_DIR/CLAUDE.md"

    cat > "$CLAUDE_DIR/CLAUDE.md" << 'PROJECTMD'
# Project: [PROJECT_NAME]

Project-specific configuration. This overrides global ~/.claude/CLAUDE.md settings.

## Project Overview

- **Description**: [What this project does]
- **Tech Stack**: [Languages, frameworks, tools]
- **Repository**: [URL if applicable]

## Build & Test Commands

```bash
# Build
[build command]

# Test
[test command]

# Run
[run command]
```

## Project Structure

```
[key directories and their purposes]
```

## Coding Conventions

- [Project-specific conventions that override or extend global settings]

## Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| | | |

## Important Files

- [Key files and their purposes]

## Notes

- [Any project-specific notes for Claude]
PROJECTMD

    echo "  ✓ Created $CLAUDE_DIR/CLAUDE.md"

    # Create optional directories
    mkdir -p "$CLAUDE_DIR/skills"
    mkdir -p "$CLAUDE_DIR/commands"

    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Project Installation Complete!                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Created:"
    echo "  $CLAUDE_DIR/"
    echo "  ├── CLAUDE.md    # Edit this with project-specific info"
    echo "  ├── skills/      # Add project-specific skills here"
    echo "  └── commands/    # Add project-specific slash commands here"
    echo ""
    echo "Next steps:"
    echo "  1. Edit .claude/CLAUDE.md with your project details"
    echo "  2. Add to .gitignore if you don't want to commit: echo '.claude/' >> .gitignore"
    echo "  3. Or commit to share with team: git add .claude/"
    echo ""
    exit 0
fi

#######################################
# GLOBAL INSTALL
#######################################
CLAUDE_DIR="$HOME/.claude"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         kron-claude Global Configuration Installer           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating $CLAUDE_DIR..."
    mkdir -p "$CLAUDE_DIR"
fi

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
if command -v claude &> /dev/null; then
    # Define hooks: SessionStart for cleanup, PostToolUse for change logging
    HOOKS_CONFIG='[
        {"event":"SessionStart","command":"~/.claude/scripts/cleanup-agents.sh"},
        {"event":"PostToolUse","matcher":"Edit|Write","command":"~/.claude/scripts/log-change.sh"}
    ]'
    # Minify for claude config (remove newlines and extra spaces)
    HOOKS_MINIFIED=$(echo "$HOOKS_CONFIG" | tr -d '\n' | sed 's/  */ /g')

    if claude config set hooks "$HOOKS_MINIFIED" 2>/dev/null; then
        echo "  ✓ SessionStart hook: cleanup-agents.sh (kills zombie agent processes)"
        echo "  ✓ PostToolUse hook: log-change.sh (logs file changes to KNOWLEDGE.md)"
    else
        echo "  Note: Could not auto-configure hooks. Configure manually:"
        echo "  claude config set hooks '$HOOKS_MINIFIED'"
    fi
else
    echo "  Note: Claude CLI not found. Configure hooks after installing Claude Code:"
    echo "  claude config set hooks '[{\"event\":\"SessionStart\",\"command\":\"~/.claude/scripts/cleanup-agents.sh\"},{\"event\":\"PostToolUse\",\"matcher\":\"Edit|Write\",\"command\":\"~/.claude/scripts/log-change.sh\"}]'"
fi

echo ""
echo "Step 6: Installing claude-mem plugin..."
if command -v claude &> /dev/null; then
    echo "  Adding marketplace..."
    claude plugin marketplace add thedotmack/claude-mem 2>/dev/null || true

    echo "  Updating marketplace..."
    claude plugin marketplace update thedotmack 2>/dev/null || true

    echo "  Installing claude-mem..."
    if claude plugin install claude-mem@thedotmack 2>/dev/null; then
        echo "  ✓ claude-mem plugin installed"
    else
        echo "  Note: claude-mem may already be installed or requires manual installation"
    fi

    # Ensure bun is accessible for hooks (claude-mem uses bun)
    if [ -f "$HOME/.bun/bin/bun" ] && [ ! -f "$HOME/.local/bin/bun" ]; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.bun/bin/bun" "$HOME/.local/bin/bun"
        echo "  ✓ Created bun symlink in ~/.local/bin (required for hooks)"
    fi
else
    echo "  Claude CLI not found. Install manually after installing Claude Code:"
    echo "  claude plugin marketplace add thedotmack/claude-mem"
    echo "  claude plugin install claude-mem@thedotmack"
fi

echo ""
echo "Step 7: Setting up kron-install command..."
mkdir -p "$HOME/bin"
ln -sf "$SCRIPT_DIR/install.sh" "$HOME/bin/kron-install"
echo "  ✓ Created ~/bin/kron-install symlink"

# Add ~/bin to PATH if not already there
SHELL_RC=""
if [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
else
    # Fallback to checking $SHELL
    case "$(basename "$SHELL")" in
        bash) SHELL_RC="$HOME/.bashrc" ;;
        zsh)  SHELL_RC="$HOME/.zshrc" ;;
    esac
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
        echo "  ✓ Added ~/bin to PATH in $SHELL_RC"
        NEED_SOURCE=true
    else
        echo "  ~/bin already in PATH"
    fi
fi

echo ""
echo "Step 8: Setting up auto-updates (cron)..."
CRON_CMD="*/10 * * * * $HOME/.claude/scripts/auto-update.sh >/dev/null 2>&1"
CRON_MARKER="# kron-claude auto-update"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "kron-claude auto-update"; then
    echo "  Auto-update cron job already exists"
else
    # Add cron job
    (crontab -l 2>/dev/null || true; echo "$CRON_MARKER"; echo "$CRON_CMD") | crontab -
    echo "  ✓ Added cron job (checks for updates every 10 minutes)"
fi
echo "  Log file: ~/.claude/auto-update.log"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              Global Installation Complete!                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Installed to: $CLAUDE_DIR"
echo ""
echo "Files installed:"
echo "  - CLAUDE.md         (main configuration)"
echo "  - KNOWLEDGE.md      (persistent memory/service registry)"
echo "  - skills/           (document, code-review, test-runner, git-workflow)"
echo "  - scripts/          (log-change.sh, discover-services.sh, scan-env-vars.sh)"
echo "  - ~/bin/kron-install (symlink for easy access)"
echo ""
if [ "$NEED_SOURCE" = true ]; then
echo "IMPORTANT: Run this to activate kron-install command:"
echo "  source $SHELL_RC"
echo ""
fi
echo "Usage:"
echo "  kron-install           # Global install (re-run to update)"
echo "  kron-install --project # Project install (run in any project folder)"
echo ""
echo "To sync across machines:"
echo "  git clone https://github.com/Kron00/kron-claude.git && cd kron-claude && ./install.sh"
echo ""
