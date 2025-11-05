# Command Reference

This document describes the tools provided by the `gemini-mcp-tool`.

## `ask-gemini`

Asks Google Gemini for its perspective. Can be used for general questions or complex analysis of files.

**Parameters:**

*   `prompt` (required): The analysis request. Use the `@` syntax to include file or directory references (e.g., `@src/main.js explain this code`) or ask general questions (e.g., `Please use a web search to find the latest news stories`).
*   `model` (optional): The Gemini model to use. Defaults to `gemini-2.5-pro`.
*   `sandbox` (optional): Set to `true` to run in sandbox mode for safe code execution.

## `sandbox-test`

Safely executes code or commands in Gemini's sandbox environment. Always runs in sandbox mode.

**Parameters:**

*   `prompt` (required): Code testing request (e.g., `Create and run a Python script that...` or `@script.py Run this safely`).
*   `model` (optional): The Gemini model to use.

## `Ping`

A simple test tool that echoes back a message.

## `Help`

Shows the Gemini CLI help text.