# Gemini CLI Usage Guide

This guide provides detailed information on how to use the Gemini CLI effectively through the `gemini-mcp-tool`.

## Prompting

When using the `ask-gemini` and `sandbox-test` tools, it's important to be clear and concise in your prompts. Provide as much context as possible to get the best results.

**Good Prompt:**

```
ask-gemini prompt="What is the main purpose of the `PatientForm` component in @frontend/components/patient-form.tsx? Please describe its props and state."
```

**Bad Prompt:**

```
ask-gemini prompt="patient form"
```

## File References with `@`

The `@` syntax allows you to easily reference files in your prompts. You can reference a single file, or multiple files.

**Single File:**

```
ask-gemini prompt="summarize @frontend/lib/api.ts"
```

**Multiple Files:**

```
ask-gemini prompt="How do the `@frontend/lib/api.ts` and `@backend/src/routes/patients.ts` files interact?"
```

## Tool Examples

### `ask-gemini`

The `ask-gemini` tool is used to ask questions about your code. It's a powerful tool for understanding complex codebases.

**Example:**

```
ask-gemini prompt="Find all the places where the `use-ecmo-filters` hook is used in the `@frontend` directory."
```

### `sandbox-test`

The `sandbox-test` tool allows you to execute code in a secure environment. This is useful for running tests, experiments, or any other code that you don't want to run on your local machine.

**Example:**

```
sandbox-test prompt="run the tests for the `@frontend/components/patient-form.tsx` component."
```