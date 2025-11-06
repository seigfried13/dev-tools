# Agent Coordination Rules

To ensure seamless collaboration and prevent conflicts when multiple agents are working on the same codebase, all agents must adhere to the following `git`-based coordination protocol.

## Core Principle

**`git` is the single source of truth.** Agents do not communicate directly. Instead, they coordinate their work through a shared git repository.

## Standard Operating Procedure

1.  **Pull Before Working**: Before starting any new task or making any changes, you **must** run `git pull` to ensure your local environment is up-to-date with the latest changes from other agents.

2.  **Commit Frequently**: Commit your changes frequently with clear, descriptive commit messages. Small, atomic commits are preferred over large, monolithic ones. This makes it easier for other agents to understand your work and integrate their own changes.

3.  **Push After Committing**: After each commit, push your changes to the remote repository immediately so that other agents can pull them.

By following these simple rules, we can ensure that all agents are working in sync and that the project progresses smoothly without conflicts or duplicated effort.

## Conflict Resolution

Merge conflicts are a natural part of parallel development. If you encounter a conflict when running `git pull`, you must follow this protocol:

1.  **Do Not Force Push**: Never use `git push --force`. This can erase the work of other agents and disrupt the workflow.

2.  **Attempt to Resolve Automatically**: First, attempt to resolve the conflict by accepting the incoming changes (`--strategy-option theirs`). If the conflict is simple, this may be sufficient.
    ```bash
    git pull -X theirs
    ```

3.  **If Automatic Resolution Fails**: If the conflict persists, you must:
    a.  Abort the merge: `git merge --abort`
    b.  Create a new temporary branch from your current work: `git checkout -b temp-conflict-branch`
    c.  Commit your local changes to this temporary branch.
    d.  Switch back to the main branch and pull the latest changes again.
    e.  Attempt a manual merge from your temporary branch.

4.  **Escalate if Necessary**: If you are unable to resolve the conflict after following the steps above, you must **stop work** on the current task, mark it as "blocked," and escalate the issue by notifying the user. Clearly state the nature of the conflict and the files involved. This allows for human intervention to resolve complex conflicts.
