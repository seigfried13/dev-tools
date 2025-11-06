### `ccpm/ccpm/commands/pm/test-reference-update.md`

```
/pm:test-reference-update
```

```bash
mkdir -p /tmp/test-refs
cd /tmp/test-refs

# Create task 001
cat > 001.md << 'EOF'
---
name: Task One
status: open
depends_on: []
parallel: true
conflicts_with: [002, 003]
---
# Task One
This is task 001.
EOF

# Create task 002
cat > 002.md << 'EOF'
---
name: Task Two
status: open
depends_on: [001]
parallel: false
conflicts_with: [003]
---
# Task Two
This is task 002, depends on 001.
EOF

# Create task 003
cat > 003.md << 'EOF'
---
name: Task Three
status: open
depends_on: [001, 002]
parallel: false
conflicts_with: []
---
# Task Three
This is task 003, depends on 001 and 002.
EOF
# Simulate task -> issue number mapping
cat > /tmp/task-mapping.txt << 'EOF'
001.md:42
002.md:43
003.md:44
EOF

# Create old -> new ID mapping
> /tmp/id-mapping.txt
while IFS=: read -r task_file task_number; do
  old_num=$(basename "$task_file" .md)
  echo "$old_num:$task_number" >> /tmp/id-mapping.txt
done < /tmp/task-mapping.txt

echo "ID Mapping:"
cat /tmp/id-mapping.txt
while IFS=: read -r task_file task_number; do
  echo "Processing: $task_file -> $task_number.md"
  
  # Read the file content
  content=$(cat "$task_file")
  
  # Update references
  while IFS=: read -r old_num new_num; do
    content=$(echo "$content" | sed "s/\b$old_num\b/$new_num/g")
  done < /tmp/id-mapping.txt
  
  # Write to new file
  new_name="${task_number}.md"
  echo "$content" > "$new_name"
  
  echo "Updated content preview:"
  grep -E "depends_on:|conflicts_with:" "$new_name"
  echo "---"
done < /tmp/task-mapping.txt
echo "=== Final Results ==="
for file in 42.md 43.md 44.md; do
  echo "File: $file"
  grep -E "name:|depends_on:|conflicts_with:" "$file"
  echo ""
done
cd -
rm -rf /tmp/test-refs
rm -f /tmp/task-mapping.txt /tmp/id-mapping.txt
echo "✅ Test complete and cleaned up"
```
