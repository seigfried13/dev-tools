### `ccpm/ccpm/commands/pm/sync.md`

```
/pm:sync [epic_name]
```

```bash
# Get all epic and task issues
gh issue list --label "epic" --limit 1000 --json number,title,state,body,labels,updatedAt
gh issue list --label "task" --limit 1000 --json number,title,state,body,labels,updatedAt
gh issue edit {number} --body-file {local_file}
```
