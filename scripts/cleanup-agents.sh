#!/usr/bin/env bash
# cleanup-agents.sh - SessionStart hook to kill zombie Claude agent processes
#
# Claude Code's Task tool spawns background agents that sometimes don't exit
# after completing. This hook runs on session start to clean up accumulated
# zombie processes and free memory.

set -e

# Kill Task agents (identified by --resume flag in command line)
pkill -f 'claude.*--resume' 2>/dev/null || true

# Kill orphaned claude processes that are:
# - Older than 30 minutes
# - Not attached to a terminal (background processes)
# - Running as 'claude' binary
for proc in /proc/[0-9]*; do
    pid=$(basename "$proc")

    # Skip if we can't read the process
    [ -r "$proc/cmdline" ] || continue

    # Check if it's a claude process
    cmd=$(tr '\0' ' ' < "$proc/cmdline" 2>/dev/null) || continue
    echo "$cmd" | grep -qE '^claude ' || continue

    # Check if it has a controlling terminal (skip if it does - it's interactive)
    if [ -e "$proc/fd/0" ] && [ -c "$proc/fd/0" ]; then
        continue
    fi

    # Check process age (skip if younger than 30 minutes)
    stat_time=$(stat -c %Y "$proc" 2>/dev/null) || continue
    now=$(date +%s)
    age_minutes=$(( (now - stat_time) / 60 ))
    [ "$age_minutes" -gt 30 ] || continue

    # Kill the zombie process
    kill -9 "$pid" 2>/dev/null || true
done

exit 0
