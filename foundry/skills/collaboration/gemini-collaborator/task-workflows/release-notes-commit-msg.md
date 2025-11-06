### 4\. Release Notes / Commit Message

**Goal:** Summarize changes for a commit or release.

**Bash Command (Piping content):**

```bash
git log --oneline main..HEAD | gemini -p "Generate a changelog in markdown format based on these commit messages. Group them by 'Features', 'Fixes', and 'Chores'."
```