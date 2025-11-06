### 2\. Documentation Generation

**Goal:** Write documentation for a piece of code.

**Bash Command (Piping content):**

```bash
cat src/services/auth.py | gemini -p "Generate high-quality API documentation for this Python code. Include a summary, parameter descriptions, return values, and a code example for each public method."
```