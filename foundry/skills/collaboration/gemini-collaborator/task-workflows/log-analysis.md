### 3\. Log Analysis

**Goal:** Analyze log data to find errors or patterns.

**Bash Command (Piping content):**

```bash
cat app.log | tail -n 100 | gemini -p "Analyze these log entries. Identify any critical errors, summarize the top 3 warnings, and suggest a potential root cause for the most frequent error."
```