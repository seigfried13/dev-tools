### `ccpm/ccpm/commands/pm/epic-refresh.md`

```
/pm:epic-refresh <epic_name>
```

```bash
# Get epic issue number from epic.md frontmatter
epic_issue={extract_from_github_field}

if [ ! -z "$epic_issue" ]; then
  # Get current epic body
  gh issue view $epic_issue --json body -q .body > /tmp/epic-body.md
  
  # For each task, check its status and update checkbox
  for task_file in .claude/epics/$ARGUMENTS/[0-9]*.md; do
    # Extract task issue number
    task_github_line=$(grep 'github:' "$task_file" 2>/dev/null || true)
    if [ -n "$task_github_line" ]; then
      task_issue=$(echo "$task_github_line" | grep -oE '[0-9]+$' || true)
    else
      task_issue=""
    fi
    task_status=$(grep 'status:' $task_file | cut -d: -f2 | tr -d ' ')
    
    if [ "$task_status" = "closed" ]; then
      # Mark as checked
      sed -i "s/- \[ \] #$task_issue/- [x] #$task_issue/" /tmp/epic-body.md
    else
      # Ensure unchecked (in case manually checked)
      sed -i "s/- \[x\] #$task_issue/- [ ] #$task_issue/" /tmp/epic-body.md
    fi
  done
  
  # Update epic issue
  gh issue edit $epic_issue --body-file /tmp/epic-body.md
fi
date -u +"%Y-%m-%dT%H:%M:%SZ"
```
