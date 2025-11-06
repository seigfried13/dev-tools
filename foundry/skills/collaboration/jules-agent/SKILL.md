---
name: jules-agent
description: Implements the delegation interface for Jules, handling task delegation and monitoring.
---

# Jules Agent Skill

## Overview

This skill acts as an intermediary between the `delegation` skill and the Jules CLI. It receives task delegation requests, initiates a Jules task, and monitors its progress. Jules is particularly suited for long-running, complex tasks that benefit from its asynchronous nature and worktree management.

## Core Concepts

### Jules Workflow Integration

This skill integrates with the existing Jules workflow, which involves:

1.  **Worktree Preparation:** Ensuring the current worktree is ready for Jules (e.g., committed changes, pushed to GitHub).
2.  **Task Initiation:** Using the `start_new_jules_task` tool to initiate a Jules task.
3.  **Status Monitoring:** Providing mechanisms to check the status of a running Jules task.
4.  **Result Integration:** Facilitating the integration of results from Jules back into the main development branch.

## When to Use

This skill is used internally by the `delegation` skill when a task is specifically assigned to Jules. It is ideal for long-running, complex tasks that can be executed asynchronously and benefit from Jules's worktree management capabilities. It should not be directly invoked by the user.

## Commands

This skill does not expose direct commands to the user. It is intended to be called internally by the `delegation` skill.

## Workflow

1.  **Receive Delegation Request:** The `delegation` skill calls this skill with a `task_description` and `complexity` (though Jules doesn't use complexity for model selection, it can be used for prioritization).
2.  **Prepare Worktree:** Ensures the current worktree is in a state suitable for Jules (e.g., prompts the user to commit and push if necessary).
3.  **Initiate Jules Task:** Calls the `start_new_jules_task` tool with the `task_description`.
4.  **Monitor Status:** Provides a way to check the status of the Jules task (e.g., by providing the console link).
5.  **Return Results:** Returns the console link and instructions for monitoring the Jules task to the `delegation` skill.

## Common Pitfalls

*   **Uncommitted Changes:** Attempting to delegate to Jules with uncommitted or unpushed changes can lead to data loss or conflicts.
*   **Network Issues:** Jules relies on GitHub for worktree management, so network connectivity issues can disrupt the workflow.
*   **Ignoring Jules Status:** Failing to monitor the Jules task status can lead to delays or unaddressed issues.

## Best Practices

*   **Commit and Push Regularly:** Always ensure your changes are committed and pushed to GitHub before delegating to Jules.
*   **Provide Clear Task Descriptions:** A detailed `task_description` helps Jules understand and execute the task effectively.
*   **Utilize the Console Link:** Use the provided console link to actively monitor the progress and status of Jules tasks.

## Integration

**Called by:**

*   `delegation`: To delegate tasks to Jules.

**Uses:**

*   `start_new_jules_task`: To initiate a new Jules task.
