---
name: gemini-agent
description: Implements the delegation interface for Gemini, handling model selection based on task complexity and interacting with the gemini-delegate skill.
---

# Gemini Agent Skill

## Overview

This skill acts as an intermediary between the `delegation` skill and the `gemini-delegate` skill. It receives task delegation requests, selects the appropriate Gemini model based on task complexity, and then uses the `gemini-delegate` skill to execute the task.

## Core Concepts

### Model Selection

Based on the `complexity` parameter received from the `delegation` skill, this skill selects the most appropriate Gemini model:

*   **`low` complexity:** `gemini-flash` (or equivalent cost-effective model, e.g., `gemini-1.5-flash`)
*   **`medium` complexity:** `gemini-pro` (balanced performance and cost, e.g., `gemini-1.5-pro`)
*   **`high` complexity:** `gemini-pro` (for tasks requiring advanced reasoning, e.g., `gemini-1.5-pro`)

### Interaction with `gemini-delegate`

This skill will format the task description and selected model into a prompt suitable for the `gemini-delegate` skill's `ask-gemini` tool. It ensures that the `gemini-delegate` skill receives all necessary information to execute the task effectively.

## When to Use

This skill is used internally by the `delegation` skill when a task is specifically assigned to Gemini. It should not be directly invoked by the user.

## Commands

This skill does not expose direct commands to the user. It is intended to be called internally by the `delegation` skill.

## Workflow

1.  **Receive Delegation Request:** The `delegation` skill calls this skill with a `task_description` and `complexity`.
2.  **Select Gemini Model:** The appropriate Gemini model is chosen based on the `complexity` and the predefined mapping.
3.  **Format Prompt:** The `task_description` is formatted into a prompt, potentially including context from the current environment, for the `gemini-delegate` skill.
4.  **Delegate to `gemini-delegate`:** The `gemini-delegate` skill's `ask-gemini` tool is invoked with the formatted prompt and selected model.
5.  **Return Results:** The results from `gemini-delegate` are processed and returned to the `delegation` skill.

## Common Pitfalls

*   **Incorrect Model Mapping:** If the complexity mapping to Gemini models is not accurate, it can lead to suboptimal performance or unnecessary costs.
*   **`gemini-delegate` Failures:** Issues within the `gemini-delegate` skill (e.g., API errors, invalid commands) will propagate through this skill.

## Best Practices

*   **Keep `gemini-delegate` Updated:** Ensure the `gemini-delegate` skill is always up-to-date to leverage the latest Gemini capabilities and bug fixes.
*   **Monitor Gemini API Usage:** Regularly review Gemini API usage to ensure cost-effectiveness and identify any anomalies.

## Integration

**Called by:**

*   `delegation`: To delegate tasks to Gemini.

**Uses:**

*   `gemini-delegate`: To interact with the Gemini CLI.
