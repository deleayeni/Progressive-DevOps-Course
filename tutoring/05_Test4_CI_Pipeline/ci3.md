# 🔄 CI 3 — Production Pipeline & Security

## 🎯 Learning Goal

- Implement comprehensive security scanning and vulnerability detection
- Add artifact publishing and registry integration
- Create production-ready pipeline with status badges
- Master advanced GitHub Actions features and optimization

## ⚠️ Problem / Issue

- Docker builds pass but may contain security vulnerabilities
- No automated security validation leaves vulnerabilities undetected
- No way to publish artifacts for deployment
- Pipeline lacks production-grade features and monitoring

## 🧠 What You'll Do

### 1. **Add comprehensive security scanning**

Implement vulnerability detection with Trivy:

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

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: "fs"
          scan-ref: "."
          format: "sarif"
          output: "trivy-results.sarif"

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: "trivy-results.sarif"
```

### 2. **Add artifact publishing**

Publish Docker images to container registry:

```yaml
publish-artifacts:
  needs: [test-backend, test-frontend, build-docker]
  runs-on: ubuntu-latest
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: tests/test3-containerize-application/docker3/backend3
        push: true
        tags: |
          ghcr.io/${{ github.repository }}/backend:${{ github.sha }}
          ghcr.io/${{ github.repository }}/backend:latest

    - name: Build and push frontend image
      uses: docker/build-push-action@v5
      with:
        context: tests/test1-ui-backend/frontend1
        push: true
        tags: |
          ghcr.io/${{ github.repository }}/frontend:${{ github.sha }}
          ghcr.io/${{ github.repository }}/frontend:latest
```

### 3. **Add status badges and monitoring**

Create production-grade pipeline with status reporting:

```yaml
integration-test:
  needs: [test-backend, test-frontend]
  runs-on: ubuntu-latest
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Test full stack integration
      run: |
        cd tests/test3-containerize-application/docker3
        docker compose up --build -d
        sleep 30

        # Test API endpoints
        curl -f http://localhost:8080/counter || exit 1
        curl -X POST http://localhost:8080/counter/increment || exit 1

        # Test frontend
        curl -f http://localhost/ || exit 1

        # Cleanup
        docker compose down
```

## 📖 Concepts Introduced

### **Security Scanning**

- **Trivy** — Comprehensive vulnerability scanner
- **SARIF format** — Standardized security results
- **GitHub Security** — Integration with GitHub's security features
- **Dependency scanning** — Check for known vulnerabilities

### **Artifact Publishing**

```yaml
- name: Login to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

- **Container Registries** — Store and distribute Docker images
- **GitHub Container Registry** — Free registry for public repos
- **Image Tagging** — Version images with commit SHA and latest
- **Secrets Management** — Secure handling of authentication

### **Advanced GitHub Actions Features**

**Matrix Builds:**

```yaml
strategy:
  matrix:
    go-version: [1.21, 1.22, 1.23]
    os: [ubuntu-latest, windows-latest]
```

**Environment Protection:**

```yaml
environment: production
```

**Status Checks:**

```yaml
- name: Update deployment status
  uses: actions/github-script@v7
  with:
    script: |
      github.rest.repos.createCommitStatus({
        owner: context.repo.owner,
        repo: context.repo.repo,
        sha: context.sha,
        state: 'success',
        description: 'Deployment successful'
      })
```

### **Production Pipeline Patterns**

**Multi-stage Validation:**

```
test → build → security → publish → deploy
```

**Conditional Deployment:**

- **Main branch:** Full pipeline with deployment
- **Feature branches:** Test and build only
- **Pull requests:** Test only

**Resource Optimization:**

- **Docker layer caching** — Speed up builds
- **Parallel security scans** — Run alongside other jobs
- **Conditional publishing** — Only on successful builds

### **Monitoring and Observability**

**Status Badges:**

```markdown
![CI](https://github.com/user/repo/workflows/CI%20Pipeline/badge.svg)
```

**Pipeline Notifications:**

- Slack integration
- Email alerts
- GitHub status checks

**Artifact Management:**

- Version tagging
- Cleanup policies
- Access controls

## 🔍 Reflection

- ✅ **Solved:** Comprehensive security validation with vulnerability scanning
- ✅ **Automation:** Full pipeline from code to production-ready artifacts
- ✅ **Quality Gates:** Security scans prevent vulnerable code from reaching production
- ✅ **Production Ready:** Artifact publishing and status monitoring
- ✅ **Security:** Automated vulnerability detection and reporting
- ✅ **Monitoring:** Status badges and pipeline visibility
- 🔜 **Next:** Add collaboration features, branch protection, and deployment automation
