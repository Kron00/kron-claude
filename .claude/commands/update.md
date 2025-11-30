---
description: Update Claude Code to the latest version and sync all configurations
allowed-tools: bash
---

# Claude Code Update Assistant

You are helping the user update their Claude Code installation and configurations.

## Update Sequence

### 1. Check Current Version
```bash
claude --version
```
Report the current version to the user.

### 2. Update Claude Code
Run the appropriate update command based on how Claude Code was installed:

**NPM (most common):**
```bash
npm update -g @anthropic-ai/claude-code
```

**If that fails, try:**
```bash
npm install -g @anthropic-ai/claude-code@latest
```

### 3. Verify Update
```bash
claude --version
```
Confirm the new version.

### 4. Check for Configuration Updates
Review and report on:
- Any new features in the changelog
- Deprecated settings that need updating
- New recommended configurations

### 5. Sync Subagents (Optional)
Ask the user if they want to sync their subagents with the latest versions from the repository.

If yes, for each agent in `.claude/agents/`:
1. Check if there's a newer version at the source repo
2. Report any differences
3. Offer to update while preserving customizations

## Post-Update Summary
Provide a summary:
```
Update Complete
━━━━━━━━━━━━━━━
Previous: vX.X.X
Current:  vY.Y.Y
Status:   ✓ Success

Changes:
- [list any notable changes]
```

## Troubleshooting
If the update fails:
1. Check npm permissions
2. Suggest using `sudo` if needed (with appropriate warnings)
3. Check for conflicting global packages
4. Provide alternative installation methods
