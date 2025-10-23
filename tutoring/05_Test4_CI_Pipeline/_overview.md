# 🧩 Test 4 — CI Pipeline (Build + Test + Push Artifact)

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

| Module                                      | Description                                                                                               | Outcome                                                  |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| **CI0 — Pipeline Setup**                    | Configure GitHub Actions or Azure Pipelines. Automate backend image build, run tests, and push artifacts. | Green pipeline on main and PRs; build artifacts visible. |
| **collab0 — PR Template & Required Checks** | Define PR template, add required status checks in repo settings.                                          | PRs cannot merge unless CI passes.                       |

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

## 🔍 Reflection

✅ Solved: Builds, tests, and pushes are automated through CI.  
✅ Safer collaboration through green checks on PRs.  
❌ Still no automated deployment.  
🔜 Next: **Test 5 — Kubernetes Deployments** will introduce automated deployment and container orchestration.
