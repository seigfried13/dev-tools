### `ccpm/ccpm/commands/context/create.md`

```bash
ls -la .claude/context/ 2>/dev/null
ls -1 .claude/context/*.md 2>/dev/null | wc -l
test -f package.json && echo "Node.js project detected"
test -f requirements.txt || test -f pyproject.toml && echo "Python project detected"
test -f Cargo.toml && echo "Rust project detected"
test -f go.mod && echo "Go project detected"
git status 2>/dev/null
mkdir -p .claude/context/
touch .claude/context/.test && rm .claude/context/.test
date -u +"%Y-%m-%dT%H:%M:%SZ"
find . -maxdepth 2 \( -name 'package.json' -o -name 'requirements.txt' -o -name 'pyproject.toml' -o -name 'pom.xml' -o -name 'build.gradle' -o -name 'build.gradle.kts' -o -name '*.sln' -o -name '*.csproj' -o -name 'Gemfile' -o -name 'Cargo.toml' -o -name 'go.mod' -o -name 'composer.json' -o -name 'pubspec.yaml' -o -name 'CMakeLists.txt' -o -name 'Dockerfile' -o -name 'docker-compose.yml' -o -name 'Package.swift' -o -type d -name '*.xcodeproj' -o -type d -name '*.xcworkspace' \) 2>/dev/null
git remote -v 2>/dev/null
git branch --show-current 2>/dev/null
find . -type f \( -name '*.js' -o -name '*.ts' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.py' -o -name '*.rs' -o -name '*.go' -o -name '*.php' -o -name '*.swift' -o -name '*.java' -o -name '*.kt' -o -name '*.kts' -o -name '*.cs' -o -name '*.rb' -o -name '*.dart' -o -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.sh' \) 2>/dev/null | head -20
ls -la
git status --short
git log --oneline -10
find . -type f -name '*.md' -path '*/docs/*' 2>/dev/null | head -10
find . \(  -path '*/.*' -prune\) -o \(  -type d \( -name 'test' -o -name 'tests' -o -name '__tests__' -o -name 'spec' \) -o -type f \( -name '*[._]test.*' -o -name '*[._]spec.*' -o -name 'test_*.*' -o -name '*_test.*' \)\) 2>/dev/null | head -10
```
