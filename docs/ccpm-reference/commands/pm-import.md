### `ccpm/ccpm/commands/pm/import.md`

```
/pm:import [--epic <epic_name>] [--label <label>]
```

```bash
# Get issues based on filters
if [[ "$ARGUMENTS" == *"--label"* ]]; then
  gh issue list --label "{label}" --limit 1000 --json number,title,body,state,labels,createdAt,updatedAt
else
  gh issue list --limit 1000 --json number,title,body,state,labels,createdAt,updatedAt
fi
mkdir -p .claude/epics/{epic_name}
```
