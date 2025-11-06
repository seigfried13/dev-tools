### `ccpm/ccpm/commands/pm/issue-sync.md`

```
/pm:issue-sync <issue_number>
```

```bash
remote_url=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$remote_url" == *"automazeio/ccpm"* ]]; then
  echo "❌ ERROR: Cannot sync to CCPM template repository!"
  echo "Update your remote: git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
  exit 1
fi
gh auth status
gh issue view $ARGUMENTS --json state
date -u +"%Y-%m-%dT%H:%M:%SZ"
gh issue comment #$ARGUMENTS --body-file {temp_comment_file}
date -u +"%Y-%m-%dT%H:%M:%SZ"
```
