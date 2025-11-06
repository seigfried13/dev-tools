### `ccpm/ccpm/commands/pm/epic-start-worktree.md`

```
/pm:epic-start <epic_name>
```

```bash
test -f .claude/epics/$ARGUMENTS/epic.md || echo "❌ Epic not found. Run: /pm:prd-parse $ARGUMENTS"
git worktree list | grep "epic-$ARGUMENTS"
# If worktree doesn't exist, create it
if ! git worktree list | grep -q "epic-$ARGUMENTS"; then
  git checkout main
  git pull origin main
  git worktree add ../epic-$ARGUMENTS -b epic/$ARGUMENTS
  echo "✅ Created worktree: ../epic-$ARGUMENTS"
else
  echo "✅ Using existing worktree: ../epic-$ARGUMENTS"
fi
# Check for analysis
if ! test -f .claude/epics/$ARGUMENTS/{issue}-analysis.md; then
  echo "Analyzing issue #{issue}..."
  # Run analysis (inline or via Task tool)
fi
echo "
Agents launched successfully!

Monitor progress:
  /pm:epic-status $ARGUMENTS

View worktree changes:
  cd ../epic-$ARGUMENTS && git status

Stop all agents:
  /pm:epic-stop $ARGUMENTS

Merge when complete:
  /pm:epic-merge $ARGUMENTS
"
```
