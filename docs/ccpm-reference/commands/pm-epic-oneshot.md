### `ccpm/ccpm/commands/pm/epic-oneshot.md`

```
/pm:epic-oneshot <feature_name>
```

```bash
# Epic must exist
test -f .claude/epics/$ARGUMENTS/epic.md || echo "❌ Epic not found. Run: /pm:prd-parse $ARGUMENTS"

# Check for existing tasks
if ls .claude/epics/$ARGUMENTS/[0-9]*.md 2>/dev/null | grep -q .; then
  echo "⚠️ Tasks already exist. This will create duplicates."
  echo "Delete existing tasks or use /pm:epic-sync instead."
  exit 1
fi

# Check if already synced
if grep -q "github:" .claude/epics/$ARGUMENTS/epic.md; then
  echo "⚠️ Epic already synced to GitHub."
  echo "Use /pm:epic-sync to update."
  exit 1
fi
```
