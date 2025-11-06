---
name: gemini-cli-collaboration
description: Facilitates headless command line communication with Gemini CLI for task delegation, workload balancing, and alternative perspective.
allowed-tools: Bash(gemini), 
---

# Gemini CLI Collaborator

When assisting the user and any of the following scenarios are identified:
1.  User-requested or contextually-appropriate comprehensive codebase analysis
2.  User-requested or contextually-appropriate up-to-date API documentation
3.  User-requested or contextually-appropriate large, context-intensive file parsing/analysis
4.  Moderate-to-complex multi-step workflow
5.  Isolated, self-contained task (bug fix, add documentation, build new feature) within an up-to-date GitHub repository

You will **NOT** not proceed until the active workplan is revised to integrate Gemini CLI use.


1.  Understand the user's request.
2.  Formulate a clear, specific prompt for the `gemini` CLI.
3.  Execute the `gemini` command using the `Bash` tool.
4.  Present the results from Gemini to the user.

## Workflow

1.  **Analyze Request:** Identify the user's goal (e.g., "review this file," "summarize this diff," "write docs for this code").
2.  **Pipe Context (If Necessary):** If the user provides context (like piping a file or git diff), ensure it's piped into the `gemini` command.
3.  **Formulate Command:** Construct a `Bash` command using the `gemini -p "..."` (or `gemini --prompt "..."`) structure. Use the templates below.
4.  **Execute & Present:** Run the command and show the output from Gemini. If you request JSON output, parse the `.response` field for the user.

---
## Prompt Templates for Gemini CLI

Use these templates as the value for the `--prompt` flag.

### 1\. Code Review

**Goal:** Review a file or `git diff` for bugs, style, and security.

### 2\. Documentation Generation

**Goal:** Write documentation for a piece of code.

### 3\. Log Analysis

**Goal:** Analyze log data to find errors or patterns.

### 4\. Release Notes / Commit Message

**Goal:** Summarize changes for a commit or release.

### 5\. General Analysis / Q\&A

**Goal:** Answer a question about a specific file or context.
