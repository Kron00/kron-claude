---
name: git-workflow
description: Handle git operations including commits, branches, PRs, and merge conflicts. Use when asked to commit, push, create PR, resolve conflicts, or manage branches.
---

# Git Workflow Skill

Handle git operations safely and consistently.

## Commit Messages

Use Conventional Commits format:
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
- `feat(auth): add OAuth2 login support`
- `fix(api): handle null response from external service`
- `refactor(utils): simplify date formatting logic`

## Safe Git Operations

### Before Any Git Operation
```bash
git status              # Check current state
git branch              # Verify current branch
git stash list          # Check for stashed changes
```

### Committing
```bash
git status                    # See what's changed
git diff                      # Review changes
git add <files>               # Stage specific files
git commit -m "type: message" # Commit with message
```

### Branching
```bash
git checkout -b feature/name  # Create and switch
git push -u origin HEAD       # Push with tracking
```

### Pull Requests
```bash
gh pr create --title "Title" --body "Description"
```

## NEVER Do Without Explicit Request

- `git push --force` (destructive)
- `git reset --hard` (loses changes)
- `git rebase` on shared branches
- `git commit --amend` after push
- Push to main/master directly

## Merge Conflict Resolution

1. Identify conflicting files: `git status`
2. Open each file, find `<<<<<<<` markers
3. Understand both versions
4. Choose correct resolution (may combine both)
5. Remove conflict markers
6. Stage resolved files: `git add <file>`
7. Continue merge/rebase: `git merge --continue`

## Instructions

1. Always check `git status` before operations
2. Review diffs before committing
3. Use descriptive branch names
4. Keep commits atomic (one logical change)
5. Never force push without explicit permission
