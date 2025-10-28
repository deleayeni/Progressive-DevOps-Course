# 🔄 CI 2 — Docker Integration & Dependencies

## 🎯 Learning Goal

- Build and validate Docker images in CI
- Implement job dependencies and conditional execution
- Learn Docker Buildx and advanced build features
- Optimize pipeline with conditional builds and caching

## ⚠️ Problem / Issue

- Tests pass but Docker builds might fail in production
- No validation that container images work correctly
- All jobs run on every push, wasting resources
- No way to ensure Docker images are production-ready

## 🧠 What You'll Do

### 1. **Add Docker build validation**

Build Docker images after tests pass:

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
      - name: Run tests
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go test -v ./...
      - name: Build backend
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build -o main .

  test-frontend:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
      - name: Run Flutter tests
        run: |
          cd tests/test1-ui-backend/frontend1
          flutter test
      - name: Build Flutter web
        run: |
          cd tests/test1-ui-backend/frontend1
          flutter build web

  build-docker:
    needs: [test-backend, test-frontend]
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build backend Docker image
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          docker build -t counter-backend:${{ github.sha }} .

      - name: Build frontend Docker image
        run: |
          cd tests/test1-ui-backend/frontend1
          docker build -t counter-frontend:${{ github.sha }} .
```

### 2. **Add conditional execution**

Only build Docker images on main branch pushes:

```yaml
build-docker:
  needs: [test-backend, test-frontend]
  runs-on: ubuntu-latest
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    - name: Build Docker images
      run: |
        cd tests/test3-containerize-application/docker3/backend3
        docker build -t counter-backend:${{ github.sha }} .
        cd ../frontend1
        docker build -t counter-frontend:${{ github.sha }} .
```

### 3. **Add Docker Compose validation**

Test the full stack integration:

```yaml
test-integration:
  needs: [test-backend, test-frontend]
  runs-on: ubuntu-latest
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Test Docker Compose
      run: |
        cd tests/test3-containerize-application/docker3
        docker compose up --build -d
        sleep 30
        curl -f http://localhost:8080/counter || exit 1
        curl -f http://localhost/ || exit 1
        docker compose down
```

## 📖 Concepts Introduced

### **Job Dependencies**

```yaml
build-docker:
  needs: [test-backend, test-frontend]
```

- Jobs wait for dependencies to complete successfully
- If any dependency fails, dependent jobs are skipped
- Enables sequential workflows: test → build → deploy
- Prevents wasted resources on failed builds

### **Conditional Execution**

```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

- Jobs run only under specific conditions
- Common conditions: branch, event type, file changes
- Saves resources by skipping unnecessary jobs
- Enables different behavior for different triggers

### **Docker Buildx**

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3
```

- Advanced Docker build capabilities
- Multi-platform builds (ARM, AMD64)
- Build cache optimization
- Enhanced build features

### **Docker Integration Patterns**

**Basic Docker Build:**

```bash
docker build -t myapp:${{ github.sha }} .
```

**Multi-stage Build Validation:**

```bash
docker build --target test -t myapp-test .
docker build --target production -t myapp:${{ github.sha }} .
```

**Docker Compose Testing:**

```bash
docker compose up --build -d
# Wait for services to be ready
curl -f http://localhost:8080/health
docker compose down
```

### **Pipeline Flow Control**

**Sequential Dependencies:**

```
test-backend ──┐
               ├──→ build-docker ──→ deploy
test-frontend ─┘
```

**Conditional Execution:**

- **Push to main:** Full pipeline (test → build → deploy)
- **Pull request:** Test only (skip expensive builds)
- **Push to feature:** Test only (skip deployment)

### **Resource Optimization**

**Docker Layer Caching:**

```yaml
- name: Build Docker image
  uses: docker/build-push-action@v5
  with:
    context: .
    push: false
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

**Conditional Resource Usage:**

- Use expensive runners only when needed
- Skip Docker builds on PRs
- Cache Docker layers between builds

### **Integration Testing**

**Full Stack Validation:**

- Build all containers
- Start the complete system
- Test API endpoints
- Verify frontend-backend communication
- Clean up resources

## 🔍 Reflection

- ✅ **Solved:** Docker images are validated in CI
- ✅ **Automation:** Full stack integration testing
- ✅ **Efficiency:** Conditional execution saves resources
- ✅ **Quality Gates:** Failed Docker builds prevent deployment
- ✅ **Dependencies:** Proper job sequencing ensures reliability
- ❌ **Limitation:** No security scanning, no artifact publishing
- 🔜 **Next:** Add security scanning and production pipeline features in CI 3
