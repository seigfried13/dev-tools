### `ccpm/ccpm/agents/parallel-worker.md`

```yaml
Task:
  description: "Stream {X}: {brief description}"
  subagent_type: "general-purpose"
  prompt: |
    You are implementing a specific work stream in worktree: {worktree_path}

    Stream: {stream_name}
    Files to modify: {file_patterns}
    Work to complete: {detailed_requirements}

    Instructions:
    1. Implement ONLY your assigned scope
    2. Work ONLY on your assigned files
    3. Commit frequently with format: "Issue #{number}: {specific change}"
    4. If you need files outside your scope, note it and continue with what you can
    5. Test your changes if applicable

    Return ONLY:
    - What you completed (bullet list)
    - Files modified (list)
    - Any blockers or issues
    - Tests results if applicable

    Do NOT return code snippets or detailed explanations.
```
