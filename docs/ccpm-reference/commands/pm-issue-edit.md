### `ccpm/ccpm/commands/pm/issue-edit.md`

```
/pm:issue-edit <issue_number>
```

```bash
# Get from GitHub
gh issue view $ARGUMENTS --json title,body,labels

# Find local task file
# Search for file with github:.*issues/$ARGUMENTS
date -u +"%Y-%m-%dT%H:%M:%SZ"
gh issue edit $ARGUMENTS --title "{new_title}"
gh issue edit $ARGUMENTS --body-file {updated_task_file}
gh issue edit $ARGUMENTS --add-label "{new_labels}"
gh issue edit $ARGUMENTS --remove-label "{removed_labels}"
```
