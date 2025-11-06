### `ccpm/ccpm/rules/path-standards.md`

```bash
# Path normalization function
normalize_paths() {
  local content="$1"
  # Remove user-specific paths (generic patterns)
  content=$(echo "$content" | sed "s|/Users/[^/]*/[^/]*/|../|g")
  content=$(echo "$content" | sed "s|/home/[^/]*/[^/]*/|../|g")  
  content=$(echo "$content" | sed "s|C:\\Users\[^\\]*\[^\\]*\|..\\|g")
  echo "$content"
}
# Check for absolute path violations
check_absolute_paths() {
  echo "Checking for absolute path violations..."
  rg -n "/Users/|/home/|C:\\" .claude/ || echo "✅ No absolute paths found"
}

# Check GitHub sync content
check_sync_content() {
  echo "Checking sync content path formats..."
  # Implement specific check logic
}
```

