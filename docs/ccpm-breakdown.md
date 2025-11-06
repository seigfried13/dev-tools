# CCPM Framework Breakdown

This document provides a detailed breakdown of the Claude Code Project Management (CCPM) framework, including its agents, commands, hooks, scripts, and rules.

## Agents

Agents are specialized, prompt-driven entities designed to perform complex, context-heavy tasks while minimizing the information returned to the main conversational thread. They act as "context firewalls."

---

### 1. Code Analyzer

*   **Purpose:** To analyze code for bugs, trace logic flows, and investigate suspicious behavior without polluting the main context.
*   **LLM-based Logic:** The agent is prompted to act as an "elite bug hunting specialist." Its instructions are to meticulously review code modifications, trace execution paths, and hunt for common bug patterns (e.g., null references, race conditions, resource leaks). It is explicitly told to be concise and to structure its findings in a `BUG HUNT SUMMARY` format, prioritizing critical issues.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Glob`, `Grep`, `LS`, `Read`, `WebFetch`, `TodoWrite`, `WebSearch`, `Search`, `Task`, `Agent`.
    *   **Scripts:** None are directly specified in the prompt, but it would use standard shell tools for navigation and file system interaction.

---

### 2. File Analyzer

*   **Purpose:** To read and summarize verbose files, such as logs, configurations, or command outputs, to extract key insights and reduce context usage.
*   **LLM-based Logic:** The agent is prompted to be an "expert file analyzer." It is instructed to read specified files, identify and prioritize critical information (errors, warnings, key metrics), and create hierarchical summaries. The core goal is an 80-90% reduction in token count while preserving 100% of the critical information.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Glob`, `Grep`, `LS`, `Read`, `WebFetch`, `TodoWrite`, `WebSearch`, `Search`, `Task`, `Agent`.
    *   **Scripts:** None are directly specified.

---

### 3. Parallel Worker

*   **Purpose:** To coordinate and execute multiple parallel work streams for a single issue within a shared git worktree.
*   **LLM-based Logic:** The agent is prompted to be a "parallel execution coordinator." Its primary responsibilities are to read an issue analysis, spawn sub-agents for each independent work stream, monitor their progress, and consolidate the results into a final summary. It is explicitly designed to shield the main thread from the complexities of parallel implementation.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Glob`, `Grep`, `LS`, `Read`, `WebFetch`, `TodoWrite`, `WebSearch`, `BashOutput`, `KillBash`, `Search`, `Task`, `Agent`.
    *   **Scripts:** This agent heavily relies on `git` commands for coordination, as described in the `agent-coordination.md` rule, to see the work of other agents through commits.

---

### 4. Test Runner

*   **Purpose:** To execute tests, capture logs, and perform a deep analysis of the results to identify failures and provide actionable insights.
*   **LLM-based Logic:** The agent is prompted to be a "test execution and analysis specialist." It is instructed to run tests using a specific script, analyze the resulting logs for failures and patterns, categorize issues by severity, and report the results in a structured summary. It is also given fallback commands for various test frameworks if the primary script fails.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Glob`, `Grep`, `LS`, `Read`, `WebFetch`, `TodoWrite`, `WebSearch`, `Search`, `Task`, `Agent`.
    *   **Scripts:**
        *   **`ccpm/scripts/test-and-log.sh`**: This is the primary script the agent is instructed to use. Its purpose is to run a given test file and automatically redirect the output to a log file for later analysis, which is crucial for preserving context in the main thread.

## Commands

Commands are user-invoked actions, defined in markdown files, that orchestrate the core workflows of the `ccpm` system. They often perform pre-flight checks, execute business logic, and call shell scripts or other agents.

---

### Context Commands (`commands/context/`)

#### 1. `/context:create`

*   **Purpose:** To create the initial project context documentation in the `.claude/context/` directory.
*   **LLM-based Logic:** The prompt instructs the agent to perform a systematic analysis of the project by detecting the project type, analyzing the codebase, and reading existing documentation. It must then generate a series of context files (`progress.md`, `project-structure.md`, `tech-context.md`, etc.) with a specific frontmatter structure. It includes pre-flight checks to avoid overwriting existing context without permission.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses a variety of shell commands for project detection (`find`, `git remote`, `ls`), codebase analysis (`find`, `head`), and date/time retrieval (`date`).

#### 2. `/context:prime`

*   **Purpose:** To load essential project context into a new agent session.
*   **LLM-based Logic:** The prompt instructs the agent to load the context files from `.claude/context/` in a specific priority order (Essential -> Current State -> Deep Context). It includes checks for file integrity and provides a comprehensive summary of the loaded context and the current project state.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `LS`.
    *   **Scripts:** Uses `ls` to find context files and `git` to check the project's current state (`git status`, `git branch`).

#### 3. `/context:update`

*   **Purpose:** To update the existing project context to reflect the current state of the project.
*   **LLM-based Logic:** The prompt instructs the agent to perform change detection by analyzing `git` history and file modification times. It then performs a "smart update," surgically modifying only the sections of the context files that need to be changed, rather than regenerating the entire context. It prioritizes updating `progress.md` and `tech-context.md`.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Heavily uses `git` commands (`git status`, `git log`, `git diff`) to detect changes.

---

### Testing Commands (`commands/testing/`)

#### 1. `/testing:prime`

*   **Purpose:** To prepare the testing environment by detecting the test framework and configuring the `test-runner` agent.
*   **LLM-based Logic:** The prompt contains a comprehensive set of checks for numerous programming languages and test frameworks (Jest, Pytest, Cargo, Maven, etc.). The agent is instructed to run these checks to detect the framework, validate dependencies, and then generate a `.claude/testing-config.md` file with the discovered configuration.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses a wide array of shell commands (`grep`, `find`, `ls`, `npm list`, `pip list`, etc.) to perform the detection.

#### 2. `/testing:run`

*   **Purpose:** To execute tests using the configured `test-runner` agent.
*   **LLM-based Logic:** The prompt instructs the agent to determine the correct test command based on the `testing-config.md` file and the user's target (e.g., a specific file or pattern). It then invokes the `test-runner` agent to perform the actual execution and analysis.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`, `Task`.
    *   **Scripts:** Relies on the commands defined in `.claude/testing-config.md` and ultimately calls the `test-runner` agent. It also includes a `pkill` command to clean up any hanging test processes.

---

### Other Commands

#### 1. `/code-rabbit`

*   **Purpose:** To process CodeRabbit review comments with context-aware discretion.
*   **LLM-based Logic:** The prompt instructs the agent to act as a reviewer for CodeRabbit's suggestions. It is told to be skeptical, as CodeRabbit lacks full codebase context. For multi-file reviews, it is instructed to spawn parallel sub-agents to handle each file independently. It includes a decision framework for accepting or ignoring suggestions.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Task`, `Read`, `Edit`, `MultiEdit`, `Write`, `LS`, `Grep`.
    *   **Scripts:** None.

#### 2. `/prompt`

*   **Purpose:** To handle complex prompts with numerous `@` references that might fail in the standard input.
*   **LLM-based Logic:** This is an "ephemeral command." The file simply contains a note to the user to write their complex prompt in that file and then run the `/prompt` command, which will then execute the content of the file.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** None.

#### 3. `/re-init`

*   **Purpose:** To update or create the root `CLAUDE.md` file with the rules from `.claude/CLAUDE.md`.
*   **LLM-based Logic:** A very simple instruction to copy the contents of one file to another, ensuring the agent has the latest instructions.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** None.
---

### Project Management (PM) Commands (`commands/pm/`)

These commands form the core of the spec-driven workflow, managing the lifecycle of features from PRD to merged code.

#### PRD and Epic Lifecycle

##### 1. `/pm:prd-new`
*   **Purpose:** To launch a brainstorming session and create a new Product Requirements Document (PRD).
*   **LLM-based Logic:** The prompt casts the agent as a product manager. It must ask clarifying questions to understand the feature, then generate a comprehensive PRD file (`.claude/prds/<feature_name>.md`) with a standard structure (Executive Summary, User Stories, Requirements, etc.) and frontmatter.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `date` to generate a real timestamp for the `created` field in the frontmatter.

##### 2. `/pm:prd-parse`
*   **Purpose:** To convert a PRD into a technical implementation plan (an "epic").
*   **LLM-based Logic:** The prompt casts the agent as a technical lead. It must read the specified PRD, perform a technical analysis, and generate a detailed epic file (`.claude/epics/<feature_name>/epic.md`). The epic outlines the architecture, technical approach, and a high-level task breakdown.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `date` for timestamps.

##### 3. `/pm:epic-decompose`
*   **Purpose:** To break a technical epic into concrete, actionable, and parallelizable tasks.
*   **LLM-based Logic:** The agent is instructed to read the epic and break it down into the smallest possible independent tasks. For epics with many tasks, it's guided to use parallel `Task` agents to create the task files concurrently. Each task file must have a standard format with frontmatter detailing dependencies and parallelizability.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`, `Task`.
    *   **Scripts:** Uses `date` for timestamps.

##### 4. `/pm:epic-sync`
*   **Purpose:** To push a local epic and its tasks to GitHub, creating a corresponding epic issue and sub-issues.
*   **LLM-based Logic:** This is a complex, multi-step command. The agent is instructed to:
    1.  Check that the remote repository is not the `ccpm` template itself.
    2.  Create a main "epic" issue on GitHub.
    3.  Create each local task as a GitHub sub-issue (using parallel agents for large numbers of tasks).
    4.  Rename the local task files from `001.md` to their new GitHub issue number (e.g., `123.md`).
    5.  Update all `depends_on` and `conflicts_with` fields in the task files to use the new issue numbers.
    6.  Create a git worktree for the epic's development.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`, `Task`.
    *   **Scripts:** Heavily relies on the `gh` CLI for all GitHub operations (issue creation, etc.) and `git` for worktree creation. It uses `sed` and `awk` to manipulate file content and frontmatter.

##### 5. `/pm:epic-oneshot`
*   **Purpose:** A convenience command to run `epic-decompose` and `epic-sync` in a single step.
*   **LLM-based Logic:** The prompt instructs the agent to simply execute the `/pm:epic-decompose` and `/pm:epic-sync` commands in sequence. It's a wrapper that orchestrates the two commands.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Read`, `LS`.
    *   **Scripts:** None directly, as it calls other commands.

##### 6. `/pm:epic-start` & `/pm:epic-start-worktree`
*   **Purpose:** To launch parallel agents to begin work on the tasks of an epic within a shared branch or worktree.
*   **LLM-based Logic:** The agent is instructed to identify all "Ready" tasks (those with no unmet dependencies). For each ready task, it reads the work stream analysis and launches parallel sub-agents (using the `Task` tool) to perform the work. It creates an `execution-status.md` file to track the active agents.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`, `Task`.
    *   **Scripts:** Uses `git` to create or switch to the correct branch/worktree.

##### 7. `/pm:epic-merge`
*   **Purpose:** To merge a completed epic from its worktree/branch back into the main branch.
*   **LLM-based Logic:** This is a cleanup and integration command. The agent is instructed to:
    1.  Run pre-merge validation (check for uncommitted changes, run tests).
    2.  Attempt the `git merge`.
    3.  If successful, perform post-merge cleanup: push to remote, remove the worktree, delete the branch, and archive the local epic files.
    4.  Close all related issues on GitHub.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`.
    *   **Scripts:** Uses `git` for all merging and cleanup operations and `gh` to close the issues.

##### 8. `/pm:epic-close`
*   **Purpose:** To mark an epic as complete after all its tasks are done.
*   **LLM-based Logic:** The agent verifies that all tasks are closed, updates the status in the local `epic.md` file, and then closes the corresponding epic issue on GitHub.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue close` to close the epic on GitHub.
#### Status and Viewing

##### 1. `/pm:status`
*   **Purpose:** To show a high-level dashboard of the overall project status.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/status.sh`. This script counts the number of PRDs, epics, and tasks (categorized by open/closed) and displays a summary.

##### 2. `/pm:standup`
*   **Purpose:** To provide a daily standup report of recent activity.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/standup.sh`. This script finds files modified in the last day, shows in-progress work, and lists the next available tasks.

##### 3. `/pm:in-progress`
*   **Purpose:** To list all work currently in progress.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/in-progress.sh`. This script checks the `.claude/epics/*/updates/` directories for active work and also lists any epics marked as "in-progress".

##### 4. `/pm:blocked`
*   **Purpose:** To show all tasks that are currently blocked by dependencies.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/blocked.sh`. This script iterates through all tasks, checks their `depends_on` field, and if the dependencies are not yet "closed", it lists the task as blocked.

##### 5. `/pm:next`
*   **Purpose:** To show the next available tasks that are ready to be worked on.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/next.sh`. This script finds all "open" tasks and checks if their dependencies are met (i.e., all dependent tasks are "closed").

##### 6. `/pm:prd-list` & `/pm:epic-list`
*   **Purpose:** To list all PRDs or all epics.
*   **LLM-based Logic:** These commands are simple wrappers around shell scripts.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/prd-list.sh` and `ccpm/scripts/pm/epic-list.sh`. These scripts scan the `.claude/prds` and `.claude/epics` directories respectively and display a formatted list categorized by status.

##### 7. `/pm:prd-status` & `/pm:epic-status`
*   **Purpose:** To show the implementation status of a specific PRD or the progress of a specific epic.
*   **LLM-based Logic:** These commands are wrappers around shell scripts.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/prd-status.sh` and `ccpm/scripts/pm/epic-status.sh`. The scripts provide a detailed view of a single PRD or epic, including task breakdowns and progress bars.

##### 8. `/pm:issue-show` & `/pm:issue-status`
*   **Purpose:** To display detailed information and status for a specific GitHub issue.
*   **LLM-based Logic:** The prompts instruct the agent to fetch data from both GitHub (using the `gh` CLI) and the local file system to create a consolidated view. This includes the issue description, labels, status, local file mapping, dependencies, and recent activity.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `LS`.
    *   **Scripts:** Uses `gh issue view` to get the latest data from GitHub.
#### Editing and Maintenance

##### 1. `/pm:prd-edit`, `/pm:epic-edit`, `/pm:issue-edit`
*   **Purpose:** To edit the details of an existing PRD, epic, or issue.
*   **LLM-based Logic:** These prompts guide the agent to perform an "interactive" edit. It asks the user which part of the document they want to change, applies the edits, and then updates the `updated` timestamp. For epics and issues, it includes a step to sync the changes back to the corresponding GitHub issue.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue edit` to sync changes to GitHub.

##### 2. `/pm:epic-refresh`
*   **Purpose:** To update the progress of an epic based on the current status of its tasks.
*   **LLM-based Logic:** The agent is instructed to scan all task files within an epic, count the number of "closed" tasks, and calculate a new progress percentage. It then updates the epic's frontmatter and, if synced to GitHub, also updates the task list checkboxes in the body of the epic's GitHub issue.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue view` and `gh issue edit` to update the task checklist on GitHub.

##### 3. `/pm:issue-close` & `/pm:issue-reopen`
*   **Purpose:** To close or reopen an issue both locally and on GitHub.
*   **LLM-based Logic:** The agent updates the `status` field in the local task file's frontmatter and then uses the `gh` CLI to perform the corresponding action on GitHub, adding a comment to record the action.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue close` or `gh issue reopen` and `gh issue comment`.

##### 4. `/pm:sync`
*   **Purpose:** To perform a full, bidirectional synchronization between the local file system and GitHub issues.
*   **LLM-based Logic:** This is a comprehensive sync process. The agent is instructed to:
    1.  Fetch all issues from GitHub.
    2.  Update local files if the GitHub version is newer.
    3.  Push local changes to GitHub if the local version is newer.
    4.  Handle conflicts by asking the user for resolution (keep local, keep GitHub, or merge).
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue list` to fetch data and `gh issue edit` to push updates.

##### 5. `/pm:import`
*   **Purpose:** To import existing GitHub issues into the local `ccpm` file structure.
*   **LLM-based Logic:** The agent fetches issues from GitHub, identifies which ones are not yet tracked locally, and creates the corresponding local epic or task files, back-filling the frontmatter with data from the GitHub issue.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `gh issue list` to fetch issues.

##### 6. `/pm:clean`
*   **Purpose:** To clean up completed work and archive old epics.
*   **LLM-based Logic:** The agent identifies completed epics (status: completed, last update > 30 days) and other stale files (old progress files, empty directories). It presents a cleanup plan to the user and, upon approval, archives the epics and removes the stale files.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`, `LS`.
    *   **Scripts:** Uses `mv` to archive and `rm` to delete files.

##### 7. `/pm:validate`
*   **Purpose:** To check the integrity of the `ccpm` system.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/validate.sh`. This script checks for a valid directory structure, orphaned files, broken references between tasks, and valid frontmatter in all documents.

##### 8. `/pm:search`
*   **Purpose:** To search for a query across all PRDs, epics, and tasks.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/search.sh`. This script uses `grep` to find the query in all `.md` files within the `.claude` directory.

##### 9. `/pm:help`
*   **Purpose:** To display a help message with all available `pm` commands.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/help.sh`. This script simply prints a pre-formatted help message.

##### 10. `/pm:init`
*   **Purpose:** To initialize the `ccpm` system in a new project.
*   **LLM-based Logic:** This command is a simple wrapper around a shell script.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`.
    *   **Scripts:** `ccpm/scripts/pm/init.sh`. This script checks for dependencies (`gh`), authenticates with GitHub, installs a `gh` extension, creates the directory structure, and creates a default `CLAUDE.md` file.

##### 11. `/pm:test-reference-update`
*   **Purpose:** A developer command to test the task reference update logic used in `epic-sync`.
*   **LLM-based Logic:** The prompt contains a self-contained test. It instructs the agent to create temporary task files with dependencies, simulate the GitHub issue creation mapping, and then run the reference update logic to ensure that dependencies like `depends_on: [001]` are correctly updated to `depends_on: [42]`.
*   **Integrated Scripts/Tools:**
    *   **Tools:** `Bash`, `Read`, `Write`.
    *   **Scripts:** Uses `sed` to perform the reference updates in the test.
## Hooks

Hooks are scripts that are automatically triggered by certain events in the `ccpm` lifecycle.

---

### 1. `bash-worktree-fix.sh`

*   **Purpose:** To automatically resolve a known issue where `git` commands executed via `Bash` from within a worktree can sometimes fail to find the `.git` directory.
*   **Logic:** This script is designed to be sourced at the beginning of other scripts. It checks if the current directory is within a worktree. If so, it finds the main repository's `.git` file (which is actually a pointer to the real git directory) and sets the `GIT_DIR` environment variable accordingly. This ensures that subsequent `git` commands work correctly.
*   **Trigger:** This script is not triggered automatically by a git hook, but is intended to be sourced by other scripts that operate within a worktree.

## Scripts

These are shell scripts that contain the procedural logic for many of the `pm` commands, separating the "how" from the "what" defined in the command prompts. They are primarily located in `ccpm/ccpm/scripts/pm/`.

*   **`status.sh`, `standup.sh`, `in-progress.sh`, `blocked.sh`, `next.sh`, `prd-list.sh`, `epic-list.sh`, `prd-status.sh`, `epic-status.sh`, `search.sh`, `validate.sh`, `help.sh`**: These are all primarily reporting scripts. They use a combination of `find`, `grep`, `awk`, and `sed` to parse the frontmatter and content of the markdown files in the `.claude` directory to generate their respective reports.
*   **`init.sh`**: This is the setup script. It performs critical initial actions like creating the directory structure (`mkdir -p`), checking for dependencies (`command -v gh`), authenticating with GitHub (`gh auth login`), and installing the necessary `gh` extension (`gh extension install`).
*   **`test-and-log.sh`**: As described in the `test-runner` agent section, this script runs a test command and redirects its output to a log file, preventing context overflow.

## Rules

Rules are markdown files that define the guiding principles, constraints, and standard operating procedures for the agents. They are loaded into the agent's context to ensure consistent and correct behavior.

---

### 1. `agent-coordination.md`
*   **Purpose:** To define how multiple agents can work on the same codebase without conflict.
*   **LLM-based Logic:** This rule instructs agents to use `git` as the primary coordination mechanism. Agents should commit their changes frequently with clear messages. Before starting work, an agent must `git pull` to get the latest changes from other agents. This prevents work from diverging.

### 2. `branch-operations.md` & `worktree-operations.md`
*   **Purpose:** To provide strict instructions for using git branches and worktrees.
*   **LLM-based Logic:** These rules define the exact `git` commands to be used for creating, switching, and deleting branches/worktrees. They enforce a consistent naming convention (e.g., `epic/<feature_name>`) and provide troubleshooting steps for common errors.

### 3. `datetime.md`
*   **Purpose:** To ensure consistent timestamp formatting.
*   **LLM-based Logic:** This rule provides a simple, explicit instruction: all dates and times must be in ISO 8601 format (`YYYY-MM-DDTHH:MM:SSZ`). It provides the correct `date` command to generate this format.

### 4. `frontmatter-operations.md` & `strip-frontmatter.md`
*   **Purpose:** To define how to read, write, and manipulate the YAML frontmatter in the markdown files.
*   **LLM-based Logic:** These rules provide agents with `sed` and `awk` commands to reliably extract or update specific fields in the frontmatter without corrupting the file. `strip-frontmatter.md` provides a command to remove the frontmatter entirely when only the body content is needed.

### 5. `github-operations.md`
*   **Purpose:** To standardize all interactions with the GitHub API via the `gh` CLI.
*   **LLM-based Logic:** This rule provides a library of `gh` commands for creating, editing, viewing, and closing issues. It specifies the exact flags and formatting to use, ensuring that all GitHub interactions are consistent.

### 6. `path-standards.md`
*   **Purpose:** To enforce a strict and consistent directory structure.
*   **LLM-based Logic:** This rule defines the canonical paths for all file types (PRDs, epics, tasks, context files, etc.). It instructs agents to always use these standard paths when creating or looking for files, which is critical for the stability of the system.

### 7. `standard-patterns.md`
*   **Purpose:** To provide a set of common, reusable logical patterns for agents.
*   **LLM-based Logic:** This rule contains patterns for common tasks like "read a file and confirm you've read it," "check for command success and handle errors," and "perform pre-flight checks before taking a major action." This reduces redundant logic in individual command prompts.

### 8. `test-execution.md`
*   **Purpose:** To define the standard procedure for running tests.
*   **LLM-based Logic:** This rule instructs agents to always use the `test-runner` agent for executing tests. It explains that the `test-runner` is responsible for capturing logs and analyzing results, and that agents should not run tests directly.

### 9. `use-ast-grep.md`
*   **Purpose:** To mandate the use of `ast-grep` for any large-scale code refactoring.
*   **LLM-based Logic:** This rule explains that `ast-grep` is more reliable than `sed` for code manipulation because it understands the code's structure. It provides examples of how to use `ast-grep` for common refactoring tasks.
