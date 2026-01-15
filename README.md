# kron-claude

Portable Claude Code configuration with persistent memory, skills, and automated change tracking.

## Features

- **Persistent Memory**: KNOWLEDGE.md tracks services, env vars, and changes across sessions
- **Auto Change Logging**: PostToolUse hooks automatically log what Claude modifies
- **Skills**: Pre-built skills for documentation, code review, testing, and git workflows
- **Service Discovery**: Scripts to scan and document your project ecosystem
- **Parallel Agents**: Configured for 5 parallel Task agents for faster research/exploration
- **Minimal Questions**: Claude assumes reasonable defaults instead of asking excessive questions

## Quick Install

```bash
git clone https://github.com/Kron00/kron-claude.git
cd kron-claude
chmod +x install.sh
./install.sh
```

## What Gets Installed

```
~/.claude/
├── CLAUDE.md              # Main configuration
├── KNOWLEDGE.md           # Persistent memory & service registry
├── skills/
│   ├── document/          # /document - Generate docs, READMEs
│   ├── code-review/       # /code-review - Review code for issues
│   ├── test-runner/       # /test-runner - Run and fix tests
│   └── git-workflow/      # /git-workflow - Safe git operations
└── scripts/
    ├── log-change.sh      # Hook: auto-log file changes
    ├── discover-services.sh   # Scan projects for services
    └── scan-env-vars.sh   # Find env vars across projects
```

## Configuration Highlights

### Plan Mode
Claude enters plan mode for any non-trivial task (code changes, multi-step operations).

### Parallel Agents
Always launches up to 5 Task agents in parallel for research and exploration.

### Question Policy
Claude assumes reasonable defaults and only asks when:
- Requirements are genuinely ambiguous
- Decisions have significant consequences
- User explicitly asked for input

### Memory System
KNOWLEDGE.md stores:
- Services registry (name, path, tech stack, port)
- Environment variables across projects
- Recent changes log (auto-updated by hooks)
- Architectural decisions and rationale

## Usage

### Discover Existing Services
```bash
~/.claude/scripts/discover-services.sh
```

### Scan for Environment Variables
```bash
~/.claude/scripts/scan-env-vars.sh
```

### Skills (Auto-Invoked)
Skills are automatically invoked when relevant:
- Ask Claude to "document this code" → `/document` skill
- Ask Claude to "review this code" → `/code-review` skill
- Ask Claude to "run tests" → `/test-runner` skill
- Ask Claude to "commit changes" → `/git-workflow` skill

### Enable Change Logging Hook
Add to Claude Code settings:
```bash
claude config set hooks '[{"event":"PostToolUse","matcher":"Edit|Write","command":"~/.claude/scripts/log-change.sh"}]'
```

## Auto-Installed: claude-mem Plugin

The install script automatically installs **claude-mem** for full memory capture across sessions. This plugin:
- Captures everything Claude does during sessions
- Compresses and stores context
- Injects relevant context back in future sessions

If auto-install fails, run manually:
```bash
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack
```

## Syncing Across Machines

1. Make changes to your configuration
2. Commit and push:
   ```bash
   cd ~/Documents/projects/kron-claude
   git add -A
   git commit -m "Update configuration"
   git push
   ```
3. On new machine:
   ```bash
   git clone https://github.com/Kron00/kron-claude.git
   cd kron-claude
   ./install.sh
   ```

## Updating

```bash
cd ~/Documents/projects/kron-claude
git pull
./install.sh
```

## Uninstalling

```bash
cd ~/Documents/projects/kron-claude
./uninstall.sh
```

This preserves KNOWLEDGE.md (your accumulated data) and any backups.

## File Structure

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Main Claude Code configuration |
| `KNOWLEDGE.md` | Persistent memory, service registry, change log |
| `install.sh` | Install configuration to ~/.claude |
| `uninstall.sh` | Remove configuration (preserves data) |
| `skills/*/SKILL.md` | Skill definitions |
| `scripts/*.sh` | Utility scripts and hooks |

## Customization

### Adding Services
Edit `~/.claude/KNOWLEDGE.md` and add rows to the Services Registry table.

### Adding Skills
Create a new directory in `skills/` with a `SKILL.md` file:
```yaml
---
name: my-skill
description: What triggers this skill
---

# Instructions for Claude
```

### Adding Hooks
See [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks)

## License

MIT
