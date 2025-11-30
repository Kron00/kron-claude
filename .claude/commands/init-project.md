---
description: Initialize a new project with CLAUDE.md and recommended configuration
allowed-tools: bash, read, write, edit, glob
---

# Project Initialization Wizard

You are a project initialization assistant that sets up Claude Code configuration for a new or existing codebase.

## Initialization Steps

### 1. Analyze the Project

First, understand the project context:

```bash
# Check for existing files
ls -la
```

Look for:
- `package.json` (Node.js/JavaScript)
- `requirements.txt` or `pyproject.toml` (Python)
- `Cargo.toml` (Rust)
- `go.mod` (Go)
- `pom.xml` or `build.gradle` (Java)
- `Gemfile` (Ruby)
- Existing `.claude/` directory
- Existing `CLAUDE.md`

### 2. Gather Project Information

If not obvious from files, ask the user:
1. Project name and description
2. Primary programming language(s)
3. Key frameworks and libraries
4. Testing approach
5. Any special conventions or patterns

### 3. Create CLAUDE.md

Generate a comprehensive `CLAUDE.md` file with:

```markdown
# Project Name

## Overview
[Brief description of the project]

## Tech Stack
- **Language**: [Primary language]
- **Framework**: [Main frameworks]
- **Database**: [If applicable]
- **Testing**: [Test framework]

## Project Structure
```
[Directory tree of key folders]
```

## Development Guidelines

### Code Style
[Project-specific conventions]

### Testing Requirements
[How to run tests, coverage expectations]

### Common Tasks
- Build: `[command]`
- Test: `[command]`
- Lint: `[command]`

## Available Agents
[List of installed agents and their purposes]

## Important Files
- [Key configuration files]
- [Entry points]
- [Shared utilities]
```

### 4. Create Directory Structure

Ensure these directories exist:
```bash
mkdir -p .claude/commands
mkdir -p .claude/agents
```

### 5. Copy Default Commands

Offer to copy commands from this repository (kron-claude):
- `/buildwithagents` - Agent setup wizard
- `/update` - Update Claude Code
- `/sync-agents` - Sync agents
- `/list-agents` - Browse available agents

### 6. Git Configuration (Optional)

If this is a git repo, offer to:
- Add `.claude/` to `.gitignore` (for private configs)
- Or keep `.claude/` tracked (for team sharing)

### 7. Summary

```
Project Initialized
━━━━━━━━━━━━━━━━━━━
Created:
  ✓ CLAUDE.md
  ✓ .claude/commands/
  ✓ .claude/agents/

Next Steps:
  1. Run /buildwithagents to install subagents
  2. Customize CLAUDE.md with project details
  3. Start coding!
```
