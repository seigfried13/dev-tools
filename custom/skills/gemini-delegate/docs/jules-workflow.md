# Jules Workflow

Use the `/jules` command (via `ask-gemini`) for tasks that are complex or time-consuming. This workflow uses Git worktrees and requires your code to be on GitHub.

**Step 1: Prepare for Delegation**
Commit and push your changes to GitHub.

```bash
git add .
git commit -m "Ready for Jules task"
git push origin <your-branch-name>
```

**Step 2: Delegate the Task**
Use the `ask-gemini` tool with a prompt that includes the `/jules` command to describe the task.

```
ask-gemini prompt="/jules prompt <detailed task description>"
```

**Step 3: Integrate the Results**
Once Jules is done, fetch the changes from GitHub and merge them.

```bash
git fetch origin jules/<branch-name>
git merge origin/jules/<branch-name>
```