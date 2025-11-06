### `ccpm/ccpm/rules/worktree-operations.md`

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create worktree for epic
git worktree add ../epic-{name} -b epic/{name}
# Working directory is the worktree
cd ../epic-{name}

# Normal git operations work
git add {files}
git commit -m "Issue #{number}: {change}"

# View worktree status
git status
# Agent A works on API
git add src/api/*
git commit -m "Issue #1234: Add user endpoints"

# Agent B works on UI (no conflict!)
git add src/ui/*
git commit -m "Issue #1235: Add dashboard component"
# From main repository (not worktree)
cd {main-repo}
git checkout main
git pull origin main

# Merge epic branch
git merge epic/{name}

# If successful, clean up
git worktree remove ../epic-{name}
git branch -d epic/{name}
# Conflicts will be shown
git status

# Human resolves conflicts
# Then continue merge
git add {resolved-files}
git commit
git worktree list
# If worktree directory was deleted
git worktree prune

# Force remove worktree
git worktree remove --force ../epic-{name}
# From main repo
cd ../epic-{name} && git status && cd -
# Remove old worktree first
git worktree remove ../epic-{name}
# Then create new one
# Delete old branch
git branch -D epic/{name}
# Or use existing branch
git worktree add ../epic-{name} epic/{name}
# Force removal
git worktree remove --force ../epic-{name}
# Clean up references
git worktree prune
```
