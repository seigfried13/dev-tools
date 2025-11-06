### 1\. Code Review

**Goal:** Review a file or `git diff` for bugs, style, and security.

**Bash Command (Piping content):**

```bash
# For a specific file
cat src/utils/api.js | gemini -p "Review this code for security, bugs, and style. Provide a summary of issues and suggestions for improvement."

# For staged git changes
git diff --cached | gemini -p "You are a senior code reviewer. Write a concise code review for these changes. Focus on logic, security, and adherence to best practices. Format your review in markdown."
```