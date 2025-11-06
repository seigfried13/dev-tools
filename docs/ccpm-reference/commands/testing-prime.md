### `ccpm/ccpm/commands/testing/prime.md`

```bash
grep -E '"test"|"spec"|"jest"|"mocha"' package.json 2>/dev/null
ls -la jest.config.* mocha.opts .mocharc.* 2>/dev/null
find . -type d \( -name "test" -o -name "tests" -o -name "__tests__" -o -name "spec" \) -maxdepth 3 2>/dev/null
find . -name "pytest.ini" -o -name "conftest.py" -o -name "setup.cfg" 2>/dev/null | head -5
find . -path "*/test*.py" -o -path "*/test_*.py" 2>/dev/null | head -5
grep -E "pytest|unittest|nose" requirements.txt 2>/dev/null
grep -E '\[dev-dependencies\]' Cargo.toml 2>/dev/null
find . -name "*.rs" -exec grep -l "#\[cfg(test)\]" {} \; 2>/dev/null | head -5
find . -name "*_test.go" 2>/dev/null | head -5
test -f go.mod && echo "Go module found"
find . -name "phpunit.xml" -o -name "phpunit.xml.dist" -o -name "composer.json" -exec grep -l "phpunit" {} \; 2>/dev/null
find . -name "composer.json" -exec grep -l "pestphp/pest" {} \; 2>/dev/null
find . -type d \( -name "tests" -o -name "test" \) -maxdepth 3 2>/dev/null
find . -name "*.csproj" -exec grep -l -E "Microsoft\.NET\.Test|NUnit|xunit" {} \; 2>/dev/null
find . -name "*.csproj" -exec grep -l "<IsTestProject>true</IsTestProject>" {} \; 2>/dev/null
find . -name "*.sln" 2>/dev/null
find . -name "pom.xml" -exec grep -l "junit" {} \; 2>/dev/null
find . -name "build.gradle" -o -name "build.gradle.kts" -exec grep -l -E "junit|testImplementation" {} \; 2>/dev/null
find . -path "*/src/test/java" -type d 2>/dev/null
find . -name "build.gradle.kts" -exec grep -l -E "kotlin.*test|spek" {} \; 2>/dev/null
find . -name "*Test.kt" -o -name "*Spec.kt" 2>/dev/null | head -5
find . -name "Package.swift" -exec grep -l "XCTest" {} \; 2>/dev/null
find . -name "*.xcodeproj" -o -name "*.xcworkspace" 2>/dev/null
find . -name "*Test.swift" -o -name "*Tests.swift" 2>/dev/null | head -5
test -f pubspec.yaml && grep -q "flutter_test" pubspec.yaml && echo "Flutter test found"
find . -name "*_test.dart" 2>/dev/null | head -5
test -d test && echo "Test directory found"
find . -name "CMakeLists.txt" -exec grep -l -E "gtest|GTest" {} \; 2>/dev/null
find . -name "CMakeLists.txt" -exec grep -l "Catch2" {} \; 2>/dev/null
find . -name "*test.cpp" -o -name "*test.c" -o -name "test_*.cpp" 2>/dev/null | head -5
find . -name ".rspec" -o -name "spec_helper.rb" 2>/dev/null
find . -name "Gemfile" -exec grep -l "minitest" {} \; 2>/dev/null
find . -name "*_spec.rb" -o -name "*_test.rb" 2>/dev/null | head -5
npm list --depth=0 2>/dev/null | grep -E "jest|mocha|chai|jasmine"
pip list 2>/dev/null | grep -E "pytest|unittest|nose"
composer show 2>/dev/null | grep -E "phpunit|pestphp"
mvn dependency:list 2>/dev/null | grep -E "junit|testng"
./gradlew dependencies --configuration testImplementation 2>/dev/null | grep -E "junit|testng"
dotnet list package 2>/dev/null | grep -E "Microsoft.NET.Test|NUnit|xunit"
bundle list 2>/dev/null | grep -E "rspec|minitest"
flutter pub deps 2>/dev/null | grep flutter_test
# Examples by language:

# JavaScript/TypeScript
find . -path "*/node_modules" -prune -o -name "*.test.js" -o -name "*.spec.js" -o -name "*.test.ts" -o -name "*.spec.ts" | wc -l

# Python
find . -name "test_*.py" -o -name "*_test.py" -o -path "*/tests/*.py" | wc -l

# PHP
find . -path "*/tests/*" -name "*.php" -o -name "*Test.php" | wc -l

# Java/Kotlin
find . -path "*/src/test/*" -name "*Test.java" -o -name "*Test.kt" | wc -l

# C#/.NET
find . -name "*Test.cs" -o -name "*Tests.cs" | wc -l

# Swift
find . -name "*Test.swift" -o -name "*Tests.swift" | wc -l

# Dart/Flutter
find . -name "*_test.dart" | wc -l

# C/C++
find . -name "*test.cpp" -o -name "*test.c" -o -name "test_*.cpp" | wc -l

# Ruby
find . -name "*_spec.rb" -o -name "*_test.rb" | wc -l

# Go
find . -name "*_test.go" | wc -l

# Rust
find . -name "*.rs" -exec grep -l "#\[cfg(test)\]" {} \; | wc -l
```
