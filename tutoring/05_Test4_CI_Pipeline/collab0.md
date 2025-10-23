# 🤝 Collab 0 — PR Template & Required Checks

## 🎯 Learning Goal

- Create pull request templates to guide code reviews
- Set up required status checks to enforce CI pipeline success
- Understand how to protect main branch from broken code
- Learn collaboration best practices for team development

## ⚠️ Problem / Issue

- Developers can merge code without running tests
- No standardized process for code reviews
- Main branch can be broken by incomplete or untested changes
- No guidance for contributors on what to include in PRs

## 🧠 What You'll Do

1. **Create PR template:**

   ```markdown
   ## Description

   Brief description of changes made.

   ## Type of Change

   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing

   - [ ] Tests pass locally
   - [ ] CI pipeline passes
   - [ ] Manual testing completed

   ## Checklist

   - [ ] Code follows project style guidelines
   - [ ] Self-review completed
   - [ ] Documentation updated if needed
   ```

2. **Set up branch protection rules:**

   - Go to repository Settings → Branches
   - Add rule for `main` branch
   - Require status checks: "CI Pipeline"
   - Require pull request reviews: 1 reviewer
   - Dismiss stale reviews when new commits are pushed

3. **Create issue templates:**

   ```markdown
   ## Bug Report

   **Describe the bug**
   A clear description of what the bug is.

   **Steps to Reproduce**

   1. Go to '...'
   2. Click on '....'
   3. See error

   **Expected behavior**
   What you expected to happen.

   **Environment**

   - OS: [e.g. Windows, macOS, Linux]
   - Browser: [e.g. Chrome, Firefox]
   - Version: [e.g. 1.0.0]
   ```

## 📖 Concepts Introduced

- **Pull Request Templates** — Standardized format for code review requests
- **Branch Protection** — Rules that prevent direct pushes to main branch
- **Required Status Checks** — CI pipeline must pass before merge
- **Code Review Process** — Structured approach to reviewing changes
- **Issue Templates** — Standardized bug reports and feature requests
- **Collaboration Workflow** — How teams work together on code

## 🔍 Reflection

- ✅ **Solved:** All code changes go through CI validation before merging
- ✅ **Process:** Standardized PR and issue templates improve collaboration
- ❌ **Limitation:** Still running locally — no automated deployment yet
- 🔜 **Next:** Deploy to Kubernetes cluster for automated deployment
