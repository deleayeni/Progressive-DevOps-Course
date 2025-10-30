# 🧩 Test 4 — CI Pipeline (Build + Test + Push Artifact)

## 🚀 Ready to Start?

**[Go to Test 4 Implementation](../../tests/test4-ci-pipeline/README.md)**

## 🧠 Overview

By Test 3, your app runs consistently in Docker — but you still build and test everything manually.  
**Test 4 introduces Continuous Integration (CI):** automating builds, running tests, and validating code before merges.

This step transforms your project from a local prototype into a collaborative, production-grade codebase.

## 🎯 Learning Goals

- Understand what a CI pipeline is and why it matters.
- Automate image builds and test runs using **GitHub Actions** or **Azure Pipelines**.
- Run backend and frontend tests automatically on every pull request.
- Publish build artifacts (e.g., Docker images or static files) to a registry or storage location.
- Enforce quality gates so merges only happen when tests pass.

## ⚙️ Structure

| Module                                      | Description                                                                             | Outcome                                                 |
| ------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **CI0 — Basic Build Verification**          | Set up GitHub Actions workflow. Verify code compiles automatically on every push.       | Basic CI pipeline that catches build failures.          |
| **Testing0 — Basic Testing Fundamentals**   | Learn to write unit tests in Go and Flutter. Master testing concepts and patterns.      | Ability to write and run basic tests locally.           |
| **CI1 — Add Testing to CI Pipeline**        | Integrate automated testing into CI. Run unit tests automatically.                      | Tests run automatically, preventing bugs from merging.  |
| **CI2 — Docker Integration & Dependencies** | Build and validate Docker images. Implement job dependencies and conditional execution. | Docker images validated, full stack integration tested. |
| **Testing1 — Integration Testing**          | Learn to test API endpoints and frontend-backend communication.                         | Ability to write integration tests and test workflows.  |
| **CI3 — Production Pipeline & Security**    | Add security scanning, artifact publishing, and production features.                    | Production-ready pipeline with security validation.     |
| **collab0 — PR Template & Required Checks** | Define PR template, add required status checks in repo settings.                        | PRs cannot merge unless CI passes.                      |

## ⚠️ Problem / Issue

- The system still depends on manual testing.
- “It works locally” cannot be trusted without automation.
- Collaboration is risky without guardrails.

## 📖 Concepts Introduced

- Continuous Integration (CI).
- Pipeline engines (GitHub Actions, Azure Pipelines).
- Build/test stages and artifacts.
- Source control collaboration (PR templates, required checks).
- Container registries and artifact storage.

## 📚 Detailed Modules

- **[CI 0 Tutorial](./ci0.md)** — Basic build verification and workflow setup
- **[Testing 0 Tutorial](./testing0.md)** — Basic testing fundamentals and unit tests
- **[CI 1 Tutorial](./ci1.md)** — Add testing to CI pipeline
- **[CI 2 Tutorial](./ci2.md)** — Docker integration and job dependencies
- **[Testing 1 Tutorial](./testing1.md)** — Integration testing and API testing
- **[CI 3 Tutorial](./ci3.md)** — Production pipeline and security scanning
- **[Collab 0 Tutorial](./collab0.md)** — Collaboration and branch protection

## 🔍 Reflection

✅ Solved: Builds, tests, and pushes are automated through CI.  
✅ Safer collaboration through green checks on PRs.  
❌ Still no automated deployment.  
🔜 Next: **Test 5 — Kubernetes Deployments** will introduce automated deployment and container orchestration.
