---
name: prd-to-github-issues
description: Deconstructs a Product Requirements Document (PRD) into actionable GitHub issues, optimized for parallel development in Git worktrees.
allowed-tools: Bash, Read
---

# PRD to GitHub Issues Decomposer

## Goal
To read a provided Product Requirements Document (PRD), analyze its features, and break it down into the smallest logical, independent tasks. Each task will be formatted as a GitHub issue, ready for an agent to pick up and work on in a separate Git worktree.

## Workflow

This is a **plan-validate-execute** workflow. You MUST follow these steps in order.

### Step 1: Read the PRD

Use the `Read` tool to ingest the PRD file provided by the user. If the user provided the text directly, use that. If no PRD is present, ask the user for the file path or to paste the content.

### Step 2: Plan & Deconstruct

You must now think step-by-step to deconstruct the PRD. Your goal is to create tasks that are:
* **Independent:** Can be worked on without blocking other tasks.
* **Parallelizable:** Can be developed simultaneously by different agents.
* **Clear:** Have enough detail for an agent to complete the task.

**Your internal thought process:**
> "I will read the PRD to identify all major features and user stories. For each feature, I will break it down into the smallest possible, independent sub-tasks (e.g., 'Update API endpoint', 'Create frontend component', 'Write unit tests for X'). Each sub-task will become one GitHub issue. This aligns with the 'Git worktree' development model."

Create a structured plan (e.g., a JSON list or markdown checklist) of all the issues you intend to create. Each planned issue must have a `title`, `body`, and `labels`.

**Issue Body Template:**
```markdown
**User Story / Task:**
[Clearly state the goal of this task]

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**Technical Notes:**
[Any hints for the agent, e.g., files to modify, specific functions to update]
```

Step 3: Review and Approve (Validate)
Do not create any issues yet.

Present your structured plan (the list of proposed issues) to the user for review. Ask the user explicitly:

"I have deconstructed the PRD into the following [X] tasks. Here is the plan.

[Present the list of planned issues]

Do you approve? Shall I proceed with creating these issues on GitHub?"

Step 4: Execute (Create Issues)
Once the user approves, iterate through your plan and create each GitHub issue using the Bash tool.

You should use the GitHub CLI (gh) for this.

Bash Command Example:

```bash
gh issue create --title "Implement /auth/login Endpoint" --body "**User Story / Task:**
As a user, I need to be able to log in.

**Acceptance Criteria:**
- [ ] Endpoint accepts POST request with email/password.
- [ ] Endpoint returns a JWT on success.

**Technical Notes:**
- Modify 'src/routes/auth.js'
" --label "task,backend,auth"
```
Step 5: Final Report
After all issues are created, provide a formatted list to the user with the issue number and the direct URL for each. This list is now ready to be distributed to your team or development agents.