# 🔄 CI 0 — Pipeline Setup

## 🎯 Learning Goal

- Understand what Continuous Integration (CI) is and why it matters
- Set up GitHub Actions to automatically build and test your application
- Learn to define workflows that validate code before merging
- Publish build artifacts (Docker images) to a registry

## ⚠️ Problem / Issue

- So far, everything runs locally and manually
- "It works on my machine" cannot be trusted without automation
- No way to validate code changes before they're merged
- Manual testing is error-prone and doesn't scale with team collaboration

## 🧠 What You'll Do

1. **Create GitHub Actions workflow:**

   ```yaml
   name: CI Pipeline

   on:
     push:
       branches: [main]
     pull_request:
       branches: [main]

   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Set up Go
           uses: actions/setup-go@v4
           with:
             go-version: "1.22"
         - name: Test Backend
           run: |
             cd backend3
             go test ./...
         - name: Build Backend
           run: |
             cd backend3
             go build -o main .
   ```

2. **Add Docker build and push:**

   ```yaml
   build-and-push:
     needs: test
     runs-on: ubuntu-latest
     steps:
       - uses: actions/checkout@v4
       - name: Build Docker image
         run: |
           cd backend3
           docker build -t myapp-backend:${{ github.sha }} .
       - name: Push to registry
         run: |
           echo "Would push to Docker Hub or GitHub Container Registry"
   ```

3. **Add Flutter frontend testing:**
   ```yaml
   test-frontend:
     runs-on: ubuntu-latest
     steps:
       - uses: actions/checkout@v4
       - name: Set up Flutter
         uses: subosito/flutter-action@v2
         with:
           flutter-version: "3.16.0"
       - name: Test Flutter
         run: |
           cd frontend1
           flutter test
       - name: Build Flutter Web
         run: |
           cd frontend1
           flutter build web
   ```

## 📖 Concepts Introduced

- **Continuous Integration** — Automatically test and validate every code change
- **GitHub Actions** — Platform for defining CI/CD workflows
- **Workflow triggers** — When pipelines run (push, PR, schedule)
- **Build artifacts** — Outputs from the build process (Docker images, static files)
- **Parallel jobs** — Running tests and builds simultaneously for speed
- **Dependency management** — Jobs that depend on other jobs completing first

## 🔍 Reflection

- ✅ **Solved:** Code changes are automatically tested before merging
- ✅ **Automation:** No more manual "it works on my machine" validation
- ❌ **Limitation:** Still no automated deployment or environment management
- 🔜 **Next:** Add collaboration features like PR templates and required status checks
