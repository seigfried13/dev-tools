### `ccpm/ccpm/rules/branch-operations.md`

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create branch for epic
git checkout -b epic/{name}
git push -u origin epic/{name}
# Working directory is the current directory
# (no need to change directories like with worktrees)

# Normal git operations work
git add {files}
git commit -m "Issue #{number}: {change}"

# View branch status
git status
git log --oneline -5
# Agent A works on API
git add src/api/*
git commit -m "Issue #1234: Add user endpoints"

# Agent B works on UI (coordinate to avoid conflicts!)
git pull origin epic/{name}  # Get latest changes
git add src/ui/*
git commit -m "Issue #1235: Add dashboard component"
# From main repository
git checkout main
git pull origin main

# Merge epic branch
git merge epic/{name}

# If successful, clean up
git branch -d epic/{name}
git push origin --delete epic/{name}
# Conflicts will be shown
git status

# Human resolves conflicts
# Then continue merge
git add {resolved-files}
git commit
git branch -a
# Delete local branch
git branch -d epic/{name}

# Delete remote branch
git push origin --delete epic/{name}
# Current branch info
git branch -v

# Compare with main
git log --oneline main..epic/{name}
# Delete old branch first
git branch -D epic/{name}
git push origin --delete epic/{name}
# Then create new one
# Check if branch exists remotely
git ls-remote origin epic/{name}

# Push with upstream
git push -u origin epic/{name}
# Stash changes if needed
git stash

# Pull and rebase
git pull --rebase origin epic/{name}

# Restore changes
git stash pop
```
