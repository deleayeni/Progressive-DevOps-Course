# 🔄 CI 1 — Add Automated Testing

## 🎯 Learning Goal

- Add automated testing to your CI pipeline
- Learn to run tests for both backend and frontend
- Understand parallel job execution and optimization
- Implement dependency caching for faster builds

## ⚠️ Problem / Issue

- Basic CI only checks if code compiles, but doesn't test functionality
- No automated testing means bugs can slip through to production
- Manual testing doesn't scale with team collaboration
- Slow builds waste time and resources

## 🧠 What You'll Do

### 1. **Add backend testing**

Extend your basic pipeline to run Go tests:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: "1.22"

      - name: Cache Go modules
        uses: actions/cache@v3
        with:
          path: ~/go/pkg/mod
          key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
          restore-keys: |
            ${{ runner.os }}-go-

      - name: Install dependencies
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go mod download

      - name: Run tests
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go test -v ./...

      - name: Build backend
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build -o main .
```

### 2. **Add frontend testing**

Include comprehensive Flutter testing:

```yaml
test-frontend:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: "3.16.0"
        channel: "stable"

    - name: Cache Flutter dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.pub-cache
          tests/test1-ui-backend/frontend1/.dart_tool
        key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
        restore-keys: |
          ${{ runner.os }}-flutter-

    - name: Install Flutter dependencies
      run: |
        cd tests/test1-ui-backend/frontend1
        flutter pub get

    - name: Run Flutter tests
      run: |
        cd tests/test1-ui-backend/frontend1
        flutter test

    - name: Build Flutter web
      run: |
        cd tests/test1-ui-backend/frontend1
        flutter build web
```

### 3. **Understanding parallel execution**

Both jobs run simultaneously:

```yaml
jobs:
  test-backend: # ← These run in parallel
    runs-on: ubuntu-latest
    steps: [...]

  test-frontend: # ← These run in parallel
    runs-on: ubuntu-latest
    steps: [...]
```

**Timeline:**

```
Time: 0s    5s    10s   15s   20s
Backend:  [=====test=====]
Frontend: [=====test=====]
Total:    20s (not 40s!)
```

## 📖 Concepts Introduced

### **Automated Testing**

- **Unit Tests** — Test individual functions and components
- **Integration Tests** — Test how components work together
- **Build Verification** — Ensure code compiles and builds successfully

### **Parallel Job Execution**

```yaml
jobs:
  test-backend:
    runs-on: ubuntu-latest
  test-frontend:
    runs-on: ubuntu-latest
```

- Jobs run **simultaneously** by default
- Each job gets its own virtual machine
- Dramatically reduces total pipeline time
- Independent jobs can't interfere with each other

### **Dependency Caching**

```yaml
- name: Cache Go modules
  uses: actions/cache@v3
  with:
    path: ~/go/pkg/mod
    key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
```

- Stores dependencies between runs
- Uses content hashing for cache invalidation
- Dramatically speeds up subsequent builds
- Cache keys determine when to rebuild

### **Test Execution Patterns**

**Go Testing:**

```bash
go test ./...          # Run all tests
go test -v ./...       # Verbose output
go test -race ./...    # Race condition detection
```

**Flutter Testing:**

```bash
flutter test           # Run unit tests
flutter test --coverage # Generate coverage reports
flutter test integration_test/ # Run integration tests
```

### **Pipeline Optimization**

- **Parallel execution** — Run independent jobs simultaneously
- **Dependency caching** — Speed up repeated operations
- **Efficient test commands** — Use appropriate test flags
- **Resource management** — Use appropriate runner types

### **Test Types and Coverage**

| Test Type             | Purpose                    | Example                       |
| --------------------- | -------------------------- | ----------------------------- |
| **Unit Tests**        | Test individual functions  | `func TestCounterIncrement()` |
| **Integration Tests** | Test component interaction | API endpoint tests            |
| **Widget Tests**      | Test UI components         | Flutter widget tests          |
| **Build Tests**       | Verify compilation         | `go build`, `flutter build`   |

## 🔍 Reflection

- ✅ **Solved:** Code functionality is automatically tested
- ✅ **Automation:** Tests run on every code change
- ✅ **Performance:** Parallel execution and caching optimize speed
- ✅ **Quality Gates:** Failed tests prevent bad code from merging
- ❌ **Limitation:** No Docker builds, no security scanning
- 🔜 **Next:** Add Docker integration and container validation in CI 2
