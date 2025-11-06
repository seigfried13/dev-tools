### `ccpm/ccpm/rules/datetime.md`

```bash
# Get current datetime in ISO 8601 format (works on Linux/Mac)
date -u +"%Y-%m-%dT%H:%M:%SZ"

# Alternative for systems that support it
date --iso-8601=seconds

# For Windows (if using PowerShell)
Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
# First, get current datetime
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Output: 2024-01-15T14:30:45Z

# Then use in frontmatter:
---
name: user-authentication
description: User authentication and authorization system
status: backlog
created: 2024-01-15T14:30:45Z  # Use the actual $CURRENT_DATE value
---
# Get current datetime for update
UPDATE_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update only the 'updated' field:
---
name: implement-login-api
status: in-progress
created: 2024-01-10T09:15:30Z  # Keep original
updated: 2024-01-15T14:30:45Z  # Use new $UPDATE_DATE value
---
# Try primary method first
date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || \
# Fallback for systems without -u flag
date +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || \
# Last resort: use Python if available
python3 -c "from datetime import datetime; print(datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'))" 2>/dev/null || \
python -c "from datetime import datetime; print(datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'))" 2>/dev/null
```

```