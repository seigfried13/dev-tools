---
name: claude-agent
description: Implements the delegation interface for Claude, handling model selection based on task complexity and interacting with Claude's internal tools.
---

# Claude Agent Skill

## Overview

This skill acts as an intermediary between the `delegation` skill and Claude's internal tools. It receives task delegation requests, selects the appropriate Claude model based on task complexity, and then uses Claude's internal mechanisms to execute the task.

## Core Concepts

### Model Selection

Based on the `complexity` parameter received from the `delegation` skill, this skill selects the most appropriate Claude model:

*   **`low` complexity:** `claude-haiku` (or equivalent cost-effective model)
*   **`medium` complexity:** `claude-sonnet` (balanced performance and cost)
*   **`high` complexity:** `claude-sonnet` (for tasks requiring advanced reasoning)

### Interaction with Claude's Internal Tools

This skill will format the task description and selected model into a prompt suitable for Claude's internal execution. This might involve directly invoking Claude's capabilities or using existing Claude tools/skills.

## When to Use

This skill is used internally by the `delegation` skill when a task is specifically assigned to Claude. It should not be directly invoked by the user.

## Commands

This skill does not expose direct commands to the user. It is intended to be called internally by the `delegation` skill.

## Workflow

1.  **Receive Delegation Request:** The `delegation` skill calls this skill with a `task_description` and `complexity`.
2.  **Select Claude Model:** The appropriate Claude model is chosen based on the `complexity` and the predefined mapping.
3.  **Format Prompt:** The `task_description` is formatted into a prompt, potentially including context from the current environment, for Claude's internal execution.
4.  **Delegate to Claude:** Claude's internal mechanisms are invoked with the formatted prompt and selected model.
5.  **Return Results:** The results from Claude are processed and returned to the `delegation` skill.

## Common Pitfalls

*   **Incorrect Model Mapping:** If the complexity mapping to Claude models is not accurate, it can lead to suboptimal performance or unnecessary costs.
*   **Claude Internal Tool Failures:** Issues within Claude's internal tools (e.g., execution errors, invalid skill invocations) will propagate through this skill.

## Best Practices

*   **Keep Claude Skills Updated:** Ensure Claude's internal skills and tools are always up-to-date to leverage the latest capabilities and bug fixes.
*   **Monitor Claude API Usage:** Regularly review Claude API usage to ensure cost-effectiveness and identify any anomalies.

## Integration

**Called by:**

*   `delegation`: To delegate tasks to Claude.

**Uses:**

*   Claude's internal tools/skills for task execution.

