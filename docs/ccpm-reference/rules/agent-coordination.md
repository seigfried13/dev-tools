### `ccpm/ccpm/rules/agent-coordination.md`

```bash
# Check if file is being modified
git status {file}

# If modified by another agent, wait
if [[ $(git status --porcelain {file}) ]]; then
  echo "Waiting for {file} to be available..."
  sleep 30
  # Retry
fi
# Good - Single purpose commit
git add src/api/users.ts src/api/users.test.ts
git commit -m "Issue #1234: Add user CRUD endpoints"

# Bad - Mixed concerns
git add src/api/* src/db/* src/ui/*
git commit -m "Issue #1234: Multiple changes"
# Agent checks what others have done
git log --oneline -10

# Agent pulls latest changes
git pull origin epic/{name}
# If commit fails due to conflict
git commit -m "Issue #1234: Update"
# Error: conflicts exist

# Agent should report and wait
echo "❌ Conflict detected in {files}"
echo "Human intervention needed"
# Pull latest changes
git pull --rebase origin epic/{name}

# If conflicts, stop and report
if [[ $? -ne 0 ]]; then
  echo "❌ Sync failed - human help needed"
  exit 1
fi
# Update progress file every significant step
echo "✅ Completed: Database schema" >> stream-A.md
git add stream-A.md
git commit -m "Progress: Stream A - schema complete"
# These can happen simultaneously
Agent-A: git commit -m "Issue #1234: Update database"
Agent-B: git commit -m "Issue #1235: Update UI"
Agent-C: git commit -m "Issue #1236: Add tests"
# Agent A commits first
git add src/types/index.ts
git commit -m "Issue #1234: Update type definitions"

# Agent B waits, then proceeds
# (After A's commit)
git pull
git add src/api/users.ts
git commit -m "Issue #1235: Use new types"
1. cd ../epic-{name}
2. git pull
3. Check {issue}-analysis.md for assignment
4. Update stream-{X}.md with "started"
5. Begin work on assigned files
1. Make changes to assigned files
2. Commit with clear message
3. Update progress file
4. Check for new commits from others
5. Continue or coordinate as needed
1. Final commit for stream
2. Update stream-{X}.md with "completed"
3. Check if other streams need help
4. Report completion
```
