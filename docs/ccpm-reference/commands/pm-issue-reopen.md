### `ccpm/ccpm/commands/pm/issue-reopen.md`

```
/pm:issue-reopen <issue_number> [reason]
```

```bash
date -u +"%Y-%m-%dT%H:%M:%SZ"
# Reopen with comment
echo "🔄 Reopening issue

Reason: $ARGUMENTS

---
Reopened at: {timestamp}" | gh issue comment $ARGUMENTS --body-file -

# Reopen the issue
gh issue reopen $ARGUMENTS
```
