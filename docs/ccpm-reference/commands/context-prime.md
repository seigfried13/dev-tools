### `ccpm/ccpm/commands/context/prime.md`

```bash
ls -la .claude/context/ 2>/dev/null
ls -1 .claude/context/*.md 2>/dev/null | wc -l
test -r ".claude/context/{file}" && echo "readable"
test -s ".claude/context/{file}" && echo "has content"
git status --short 2>/dev/null
git branch --show-current 2>/dev/null
git ls-files --others --exclude-standard | head -20
```
