# 🔄 Test 4 — CI Pipeline

## 🎯 Objective

**Automate builds, tests, and validation** using Continuous Integration (CI) pipelines.  
This test transforms the project from manual testing to automated quality gates that run on every code change.

## 📦 Modules

- `ci0/` — GitHub Actions workflow setup
- `collab0/` — PR templates and branch protection

## 🧠 What to Do

1. **CI Pipeline**: Set up GitHub Actions to automatically test and build your application
2. **Collaboration**: Create PR templates and branch protection rules
3. **Quality Gates**: Ensure all code changes are validated before merging
4. **Artifacts**: Build and publish Docker images automatically

## ✅ What "Done" Looks Like

- ✅ GitHub Actions workflow runs on every push and PR
- ✅ Backend and frontend tests run automatically
- ✅ Docker images are built and tested
- ✅ PR template guides code reviews
- ✅ Main branch is protected from broken code
- ✅ Security scanning is integrated

## 🧪 Verification

1. **Check workflow runs:**

   - Go to GitHub Actions tab
   - Verify workflow runs on push/PR
   - All jobs should pass (green checkmarks)

2. **Test PR process:**

   - Create a test branch
   - Make a small change
   - Open a PR
   - Verify template appears and CI runs

3. **Test branch protection:**
   - Try to push directly to main
   - Should be blocked (if protection enabled)

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 4 Overview](../../tutoring/05_Test4_CI_Pipeline/_overview.md)** — Course introduction and concepts
- **[CI 0 Tutorial](../../tutoring/05_Test4_CI_Pipeline/ci0.md)** — Pipeline setup and configuration
- **[Collab 0 Tutorial](../../tutoring/05_Test4_CI_Pipeline/collab0.md)** — Collaboration and branch protection

## 🚀 Next Step

Once the CI pipeline runs successfully, proceed to **Test 5 — Kubernetes Deployment** to deploy your containerized application to a Kubernetes cluster.
