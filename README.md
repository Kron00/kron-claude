# kron-claude

> Portable Claude Code configuration with persistent memory, pre-built skills, and automated workflows. Install once, use everywhere.

## Why Use This?

Claude Code is powerful, but starts fresh every session. This configuration gives you:

- **Persistent Memory** - Track services, env vars, and changes across sessions
- **Pre-built Skills** - Documentation, code review, testing, and git workflows ready to go
- **Smarter Defaults** - 5 parallel agents, minimal questions, plan mode for complex tasks
- **One Command Setup** - Clone, install, done. Works on any machine.

---

## Quick Start

### First Time Setup

```bash
# Clone the repo
git clone https://github.com/Kron00/kron-claude.git
cd kron-claude

# Install globally
./install.sh

# Activate the kron-install command (one time only)
source ~/.bashrc
```

That's it. Claude Code now has your full configuration on this machine.

### New Project Setup

From any project directory:

```bash
cd ~/my-new-project
kron-install --project
```

This creates a `.claude/` folder with project-specific config that overrides global settings.

---

## What Gets Installed

### Global Install (`kron-install`)

```
~/.claude/
├── CLAUDE.md              # Main configuration (behavior, rules, workflows)
├── KNOWLEDGE.md           # Persistent memory (services, env vars, changes)
├── skills/
│   ├── document/          # Generate docs and READMEs
│   ├── code-review/       # Review code for bugs and security
│   ├── test-runner/       # Run tests and fix failures
│   └── git-workflow/      # Safe git operations
└── scripts/
    ├── log-change.sh      # Hook: auto-log file changes
    ├── discover-services.sh   # Scan for services
    └── scan-env-vars.sh   # Find env vars across projects

~/bin/
└── kron-install           # Symlink for easy access anywhere
```

**Also installs:**
- `claude-mem` plugin for automatic session memory

### Project Install (`kron-install --project`)

```
your-project/.claude/
├── CLAUDE.md              # Project-specific overrides
├── skills/                # Project-specific skills
└── commands/              # Project-specific slash commands
```

---

## Configuration Hierarchy

| Level | Location | Scope |
|-------|----------|-------|
| Global | `~/.claude/` | All projects on this machine |
| Project | `./.claude/` | Only this project (overrides global) |

Project config **overrides** global. Use global for your preferences, project for project-specific rules.

---

## Features

### Plan Mode (Default for Complex Tasks)

Claude enters plan mode before writing code or making multi-step changes. This ensures you approve the approach before execution.

### Parallel Agents (5x Speed)

Research and exploration tasks launch up to 5 agents simultaneously:
```
User: "Research authentication options"
Claude: [Launches 5 agents exploring different aspects in parallel]
```

### Minimal Questions

Claude assumes reasonable defaults instead of asking endless clarifying questions. Only asks when:
- Requirements are genuinely ambiguous
- Decisions have significant consequences
- You explicitly asked for options

### Persistent Memory

`KNOWLEDGE.md` tracks across sessions:
- Services registry (name, tech stack, port, path)
- Environment variables across projects
- Recent changes log (auto-updated)
- Architectural decisions

### Pre-built Skills

| Skill | Trigger | What It Does |
|-------|---------|--------------|
| `/document` | "document this", "create README" | Generate documentation |
| `/code-review` | "review this code", "check for bugs" | Security, performance, style review |
| `/test-runner` | "run tests", "fix failing tests" | Execute and fix tests |
| `/git-workflow` | "commit this", "create PR" | Safe git operations |

Skills are invoked automatically when relevant.

---

## Usage

### Install Commands

```bash
kron-install              # Global install (or re-run to update)
kron-install --project    # Project install in current directory
kron-install --help       # Show help
```

### Utility Scripts

```bash
# Discover services in ~/Documents/projects/
~/.claude/scripts/discover-services.sh

# Find environment variables across projects
~/.claude/scripts/scan-env-vars.sh
```

### Enable Auto-Logging Hook (Optional)

```bash
claude config set hooks '[{"event":"PostToolUse","matcher":"Edit|Write","command":"~/.claude/scripts/log-change.sh"}]'
```

This logs all file changes to `KNOWLEDGE.md` automatically.

---

## Syncing Across Machines

### Push Your Changes

```bash
cd ~/Documents/projects/kron-claude
git add -A
git commit -m "Update configuration"
git push
```

### Setup New Machine

```bash
git clone https://github.com/Kron00/kron-claude.git
cd kron-claude
./install.sh
source ~/.bashrc
```

Done. Full configuration restored.

---

## Customization

### Edit Global Config

```bash
nano ~/.claude/CLAUDE.md      # Behavior and rules
nano ~/.claude/KNOWLEDGE.md   # Memory and services
```

### Add a Custom Skill

```bash
mkdir ~/.claude/skills/my-skill
nano ~/.claude/skills/my-skill/SKILL.md
```

Template:
```yaml
---
name: my-skill
description: When to trigger this skill (used for semantic matching)
---

# Skill Name

Instructions for Claude when this skill is active...
```

### Add Project-Specific Config

```bash
cd your-project
kron-install --project
nano .claude/CLAUDE.md    # Edit with project details
```

---

## Updating

```bash
cd ~/Documents/projects/kron-claude
git pull
kron-install
```

## Uninstalling

```bash
cd ~/Documents/projects/kron-claude
./uninstall.sh
```

This preserves `KNOWLEDGE.md` (your accumulated data) and any backups.

---

## File Reference

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Main Claude Code configuration |
| `KNOWLEDGE.md` | Persistent memory and service registry |
| `install.sh` | Global and project installer |
| `uninstall.sh` | Remove configuration (preserves data) |
| `skills/*/SKILL.md` | Skill definitions |
| `scripts/*.sh` | Utility scripts and hooks |

---

## Requirements

- [Claude Code](https://claude.ai/code) installed
- Bash shell (Linux/macOS/WSL)
- Git

---

## License

MIT
