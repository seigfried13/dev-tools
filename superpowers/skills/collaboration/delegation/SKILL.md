---
name: delegation
description: Manages the delegation of tasks to various AI agents (Gemini, Jules, Claude) based on task complexity and available models.
---

# Delegation Skill

## Overview

This skill provides a unified interface for delegating tasks to different AI agents, taking into account the task's complexity and the available models for each agent. This allows for intelligent selection of the most appropriate and cost-effective agent/model combination for a given task.

## Core Concepts

### Agent Registry

The `delegation` skill maintains a registry of available AI agents, their capabilities, and the models they support. Each agent entry includes:

*   **Name:** Unique identifier for the agent (e.g., `gemini`, `jules`, `claude`).
*   **Models:** A list of supported models for the agent (e.g., `gemini-pro`, `gemini-flash`, `claude-sonnet`, `claude-haiku`).
*   **Complexity Mapping:** A mapping from task complexity levels (`low`, `medium`, `high`) to preferred models.

### Task Complexity

Tasks are categorized by their complexity:

*   **`low`:** Simple, straightforward tasks (e.g., minor code changes, documentation updates, simple bug fixes).
*   **`medium`:** Moderately complex tasks (e.g., implementing a new feature, refactoring a small module, debugging a known issue).
*   **`high`:** Highly complex or critical tasks (e.g., architectural changes, major refactoring, complex bug root-cause analysis, performance optimization).

## When to Use

Use this skill when you need to offload a task to another AI agent and want to ensure the most appropriate model is used based on the task's complexity. This is particularly useful in workflows where different agents or models offer varying capabilities or cost structures.

**Announce at start:** "I'm using the delegation skill to assign this task to an external agent."

## Commands

### `/delegate:task`

Delegates a task to an AI agent based on the specified complexity.

**Parameters:**

*   `agent` (required): The name of the agent to delegate to (e.g., `gemini`, `jules`, `claude`).
*   `task_description` (required): A detailed description of the task to be performed.
*   `complexity` (optional): The complexity of the task (`low`, `medium`, `high`). Defaults to `medium`.

## Examples

### Delegating a low-complexity task to Gemini

```
/delegate:task agent="gemini" complexity="low" task_description="Refactor the `formatDate` utility function in `src/utils/date.ts` to use `Intl.DateTimeFormat` for better internationalization."
```

### Delegating a high-complexity task to Claude

```
/delegate:task agent="claude" complexity="high" task_description="Perform a root cause analysis on the intermittent test failures in the `authentication` module and propose a robust solution."
```

### Delegating a medium-complexity task to Jules

```
/delegate:task agent="jules" complexity="medium" task_description="Implement a new feature: user profile editing, including frontend form, API endpoint, and database schema updates."
```

## Workflow

1.  **Agent Selection:** The `agent` parameter specifies the target AI agent.
2.  **Model Selection:** Based on the `complexity` parameter and the agent's `Complexity Mapping`, the most appropriate model is selected.
3.  **Task Delegation:** The `task_description` is passed to the selected agent, along with the chosen model.
4.  **Result Handling:** The `delegation` skill waits for the agent to complete the task and returns the results.

## Common Pitfalls

*   **Incorrect Complexity Estimation:** Assigning an incorrect complexity level can lead to using an underpowered model for a complex task (resulting in poor quality) or an overpowered model for a simple task (resulting in higher costs).
*   **Vague Task Descriptions:** A poorly defined `task_description` can lead to the delegated agent misunderstanding the task and producing irrelevant or incorrect results.
*   **Ignoring Agent Capabilities:** While this skill handles model selection, it's still important to consider if the chosen agent is fundamentally capable of the task (e.g., don't ask Jules to do real-time code generation if it's designed for long-running background tasks).

## Best Practices

*   **Be Specific:** Always provide a clear and detailed `task_description`.
*   **Estimate Complexity Carefully:** Take time to accurately assess the complexity of the task to optimize for both quality and cost.
*   **Monitor Progress:** For long-running delegated tasks (especially to Jules), actively monitor their progress and intervene if necessary.

## Integration

**Used by:**

*   `delegated-execution`: To delegate individual tasks from an implementation plan.

**Uses:**

*   `gemini-agent`: For delegating tasks to Gemini.
*   `jules-agent`: For delegating tasks to Jules.
*   `claude-agent`: For delegating tasks to Claude.
