### `ccpm/ccpm/rules/strip-frontmatter.md`

```bash
# Strip frontmatter (everything between first two --- lines)
sed '1,/^---$/d; 1,/^---$/d' input.md > output.md
# Bad - includes frontmatter
gh issue create --body-file task.md

# Good - strips frontmatter and specifies repo
remote_url=$(git remote get-url origin 2>/dev/null || echo "")
REPO=$(echo "$remote_url" | sed 's|.*github.com[:/]||' | sed 's|\.git$||')
[ -z "$REPO" ] && REPO="user/repo"
sed '1,/^---$/d; 1,/^---$/d' task.md > /tmp/clean.md
gh issue create --repo "$REPO" --body-file /tmp/clean.md
# Strip frontmatter before posting
sed '1,/^---$/d; 1,/^---$/d' progress.md > /tmp/comment.md
gh issue comment 123 --body-file /tmp/comment.md
for file in *.md; do
  # Strip frontmatter from each file
  sed '1,/^---$/d; 1,/^---$/d' "$file" > "/tmp/$(basename $file)"
  # Use the clean version
done
# Using awk
awk 'BEGIN{fm=0} /^---$/{fm++; next} fm==2{print}' input.md > output.md

# Using grep with line numbers
grep -n "^---$" input.md | head -2 | tail -1 | cut -d: -f1 | xargs -I {} tail -n +$(({}+1)) input.md
```
