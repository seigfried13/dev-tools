### `ccpm/ccpm/commands/code-rabbit.md`

```
/code-rabbit
```

```yaml
Task:
  description: "CodeRabbit fixes for {filename}"
  subagent_type: "general-purpose"
  prompt: |
    Review and apply CodeRabbit suggestions for {filename}.
    
    Comments to evaluate:
    {relevant_comments_for_this_file}
    
    Instructions:
    1. Read the file to understand context
    2. For each suggestion:
       - Evaluate validity given codebase patterns
       - Accept if it improves quality/correctness
       - Ignore if not applicable
    3. Apply accepted changes using Edit/MultiEdit
    4. Return summary:
       - Accepted: {list with reasons}
       - Ignored: {list with reasons}
       - Changes made: {brief description}
    
    Use discretion - CodeRabbit lacks full context.
```
