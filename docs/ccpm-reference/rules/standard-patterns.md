### `ccpm/ccpm/rules/standard-patterns.md`

```bash
date -u +"%Y-%m-%dT%H:%M:%SZ"
mkdir -p .claude/{directory} 2>/dev/null
gh {command} || echo "❌ GitHub CLI failed. Run: gh auth login"
gh issue view {number} --json state,title,body
```
