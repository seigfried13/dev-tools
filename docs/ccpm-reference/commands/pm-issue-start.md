### `ccpm/ccpm/commands/pm/issue-start.md`

```
/pm:issue-start <issue_number>
```

```bash
gh issue view $ARGUMENTS --json state,title,labels,body
test -f .claude/epics/*/$ARGUMENTS-analysis.md || echo "❌ No analysis found for issue #$ARGUMENTS

Run: /pm:issue-analyze $ARGUMENTS first
Or: /pm:issue-start $ARGUMENTS --analyze to do both"
# Find epic name from task file
epic_name={extracted_from_path}

# Check worktree
if ! git worktree list | grep -q "epic-$epic_name"; then
  echo "❌ No worktree for epic. Run: /pm:epic-start $epic_name"
  exit 1
fi
date -u +"%Y-%m-%dT%H:%M:%SZ"
mkdir -p .claude/epics/{epic_name}/updates/$ARGUMENTS
# Assign to self and mark in-progress
gh issue edit $ARGUMENTS --add-assignee @me --add-label "in-progress"
```
