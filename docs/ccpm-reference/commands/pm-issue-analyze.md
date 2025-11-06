### `ccpm/ccpm/commands/pm/issue-analyze.md`

```
/pm:issue-analyze <issue_number>
```

```bash
test -f .claude/epics/*/$ARGUMENTS-analysis.md && echo "⚠️ Analysis already exists. Overwrite? (yes/no)"
gh issue view $ARGUMENTS --json title,body,labels
date -u +"%Y-%m-%dT%H:%M:%SZ"
```
