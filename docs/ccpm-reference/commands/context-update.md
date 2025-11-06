### `ccpm/ccpm/commands/context/update.md`

```bash
ls -la .claude/context/ 2>/dev/null
ls -1 .claude/context/*.md 2>/dev/null | wc -l
git status --short
git log --oneline -10
git diff --stat HEAD~5..HEAD 2>/dev/null
find .claude/context -name "*.md" -type f -exec ls -lt {} + | head -5
git diff HEAD~5..HEAD package.json 2>/dev/null
git diff HEAD~5..HEAD requirements.txt pyproject.toml 2>/dev/null
git diff HEAD~5..HEAD pom.xml build.gradle build.gradle.kts 2>/dev/null
git diff HEAD~5..HEAD *.sln *.csproj 2>/dev/null
git diff HEAD~5..HEAD Gemfile Gemfile.lock 2>/dev/null
git diff HEAD~5..HEAD Cargo.toml Cargo.lock 2>/dev/null
git diff HEAD~5..HEAD go.mod go.sum 2>/dev/null
git diff HEAD~5..HEAD composer.json composer.lock 2>/dev/null
git diff HEAD~5..HEAD pubspec.yaml pubspec.lock 2>/dev/null
git diff HEAD~5..HEAD Package.swift Package.resolved 2>/dev/null
git diff HEAD~5..HEAD CMakeLists.txt 2>/dev/null
date -u +"%Y-%m-%dT%H:%M:%SZ"
git log --oneline -5
git diff --name-status HEAD~10..HEAD | grep -E '^A'
git diff --name-only HEAD~5..HEAD 2>/dev/null
git branch --show-current
git diff --stat
git ls-files --others --exclude-standard | head -10
```
