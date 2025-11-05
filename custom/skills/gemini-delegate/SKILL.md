---
name: gemini-delegate
description: Delegate tasks to the Gemini CLI via the gemini-mcp-tool. This skill provides tools for executing tasks, performing web and codebase searches, brainstorming, complex code analysis, safe code execution, asynchronous processing with Jules, and general outsourcing of tasks to reduce Claude usage cost.
---

# Gemini CLI Delegation Skill

This skill allows you to delegate tasks to the Gemini CLI through the `gemini-mcp-tool`. This provides a powerful way to interact with your codebase, run code in a sandbox, and offload long-running tasks.

## Core Concepts

The `gemini-mcp-tool` acts as a bridge between the AI assistant and the Gemini CLI. It exposes a set of tools that allow you to leverage the power of the Gemini CLI for various tasks.

**Key Tools:**

*   `ask-gemini`: For general analysis, questions, and to invoke Gemini CLI slash commands.
*   `sandbox-test`: For safely executing code in an isolated environment.

For more details on using the Gemini CLI, see the [Gemini CLI Usage Guide](./docs/gemini-cli-usage.md).

## Available Tools

For a full reference of the available tools and their parameters, see the [Command Reference](./docs/command-reference.md).

## Gemini CLI Slash Commands

The Gemini CLI provides a rich set of slash commands for controlling the CLI, managing your session, and interacting with your codebase. For a full list of these commands, see the [Gemini CLI Slash Commands Reference](./docs/gemini-cli-slash-commands.md).

## Workflows

### Asynchronous Tasks with Jules

To delegate a long-running task to Jules, use the `ask-gemini` tool with a prompt that starts with `/jules`.

See the [Jules Workflow](./docs/jules-workflow.md) for a step-by-step guide.

### Code Analysis

Use the `ask-gemini` tool to analyze code. You can reference files using the `@` syntax.

**Example:**

```
ask-gemini prompt="What is the purpose of the `ecmoRun` function in @backend/src/routes/ecmoRuns.ts?"
```

### Safe Code Execution

Use the `sandbox-test` tool to execute code in a secure environment.

**Example:**

```
sandbox-test prompt="Run the tests in @frontend/components/patient-form.test.tsx"
```

## Troubleshooting

For common issues and solutions, see the [Troubleshooting Guide](./docs/troubleshooting.md).
