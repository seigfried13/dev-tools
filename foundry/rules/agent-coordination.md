# Agent Coordination Rules

To ensure seamless collaboration and prevent conflicts when multiple agents are working on the same codebase, all agents must adhere to the following `git`-based coordination protocol.

## Core Principle

**`git` is the single source of truth.** Agents do not communicate directly. Instead, they coordinate their work through a shared git repository.

## Standard Operating Procedure

1.  **Pull Before Working**: Before starting any new task or making any changes, you **must** run `git pull` to ensure your local environment is up-to-date with the latest changes from other agents.

2.  **Commit Frequently**: Commit your changes frequently with clear, descriptive commit messages. Small, atomic commits are preferred over large, monolithic ones. This makes it easier for other agents to understand your work and integrate their own changes.

3.  **Push After Committing**: After each commit, push your changes to the remote repository immediately so that other agents can pull them.

By following these simple rules, we can ensure that all agents are working in sync and that the project progresses smoothly without conflicts or duplicated effort.
