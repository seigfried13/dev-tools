### `ccpm/ccpm/commands/testing/run.md`

```
/testing:run [test_target]
```

```bash
# Check if testing is configured
test -f .claude/testing-config.md || echo "❌ Testing not configured. Run /testing:prime first"
# For file targets
test -f "$ARGUMENTS" || echo "⚠️ Test file not found: $ARGUMENTS"
# Kill any hanging test processes
# Kill test processes for all supported frameworks
pkill -f "jest|mocha|pytest|phpunit|rspec|ctest" 2>/dev/null || true
pkill -f "mvn.*test|gradle.*test|gradlew.*test" 2>/dev/null || true
pkill -f "dotnet.*test|cargo.*test|go.*test|swift.*test|flutter.*test" 2>/dev/null || true
```
