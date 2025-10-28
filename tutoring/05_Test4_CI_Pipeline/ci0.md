# 🔄 CI 0 — Basic Build Verification

## 🎯 Learning Goal

- Understand what Continuous Integration (CI) is and why it matters
- Set up your first GitHub Actions workflow
- Learn basic workflow structure and core concepts
- Verify your code builds automatically on every push

## ⚠️ Problem / Issue

- So far, everything runs locally and manually
- "It works on my machine" cannot be trusted without automation
- No way to validate code changes before they're merged
- Manual testing is error-prone and doesn't scale with team collaboration

## 🧠 What You'll Do

### 1. **Create your first workflow**

The most basic CI pipeline just checks if your code compiles:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: "1.22"
      - name: Build Backend
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build -o main .
```

### 2. **Add Flutter build verification**

Extend to verify both backend and frontend build:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]

jobs:
  build-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: "1.22"
      - name: Build Backend
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build -o main .

  build-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
      - name: Build Frontend
        run: |
          cd tests/test1-ui-backend/frontend1
          flutter build web
```

### 3. **Add pull request triggers**

Make the pipeline run on both pushes and pull requests:

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

## 📖 Concepts Introduced

### **Continuous Integration (CI)**

Automatically validate every code change before it reaches the main branch. Think of it as a robot that checks your work.

### **GitHub Actions**

GitHub's built-in CI/CD platform. You define workflows in YAML files, and GitHub runs them automatically.

### **Workflow Structure**

Every workflow has three main parts:

- **Triggers** (`on:`) — When to run
- **Jobs** (`jobs:`) — What to do
- **Steps** (`steps:`) — How to do it

### **Key Components**

| Component    | Purpose                | Example               |
| ------------ | ---------------------- | --------------------- |
| **Workflow** | The entire YAML file   | `ci.yml`              |
| **Job**      | A set of related steps | `build-backend`       |
| **Step**     | A single command       | `go build`            |
| **Runner**   | Virtual machine        | `ubuntu-latest`       |
| **Action**   | Reusable code          | `actions/checkout@v4` |

### **Workflow Triggers**

- `push` — Runs when code is pushed
- `pull_request` — Runs when PRs are opened/updated
- `schedule` — Runs on a schedule (like cron)

### **Job Execution**

- Jobs run in **parallel** by default
- Each job gets its own fresh virtual machine
- If any step fails, the entire job fails

### **Common Actions**

- `actions/checkout@v4` — Downloads your repository code
- `actions/setup-go@v4` — Installs Go runtime
- `subosito/flutter-action@v2` — Installs Flutter SDK

## 🔍 Reflection

- ✅ **Solved:** Code changes are automatically validated for compilation
- ✅ **Automation:** No more manual "it works on my machine" validation
- ✅ **Foundation:** Basic CI pipeline that catches build failures
- ❌ **Limitation:** No automated testing, no Docker builds, no security scanning
- 🔜 **Next:** Add automated testing in CI 1
