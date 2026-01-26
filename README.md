# kron-claude (DISCONTINUED)

**This project has been discontinued.**

If you previously installed kron-claude, the auto-update mechanism will automatically clean up your installation.

## Manual Cleanup

If you need to manually remove kron-claude:

```bash
cd ~/Documents/projects/archive/kron-claude  # or wherever you cloned it
./install.sh  # This now runs cleanup
```

Or manually:

```bash
# Remove cron job
crontab -r

# Remove scripts
rm -f ~/.claude/scripts/{auto-update,cleanup-agents,log-change,discover-services,scan-env-vars}.sh

# Remove skills
rm -rf ~/.claude/skills/{document,code-review,test-runner,git-workflow,build-agent}

# Remove plugin files
rm -rf ~/.claude/plugins/cache/thedotmack
rm -rf ~/.claude/plugins/marketplaces/thedotmack

# Clear hooks
echo '{"hooks":{}}' > ~/.claude/hooks.json
```

## Why Discontinued?

The hooks and plugins caused freezing issues in Claude Code. The auto-update cron job was also problematic.

## What's Preserved

The cleanup does NOT delete:
- `~/.claude/CLAUDE.md` - your configuration
- `~/.claude/KNOWLEDGE.md` - your accumulated data
- `~/.claude/settings.json` - Claude Code settings
- Other Claude Code plugins and data
