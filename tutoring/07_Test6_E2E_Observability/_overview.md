# 🧪 Test 6 — E2E + Basic Observability

## 🧠 Overview

Your app now runs in Kubernetes, but reliability isn’t just about uptime — it’s about knowing when things break.  
**Test 6 introduces observability and end-to-end (E2E) testing.**  
You’ll learn how to validate real user paths and capture system behavior during failures.

## 🎯 Learning Goals

- Implement a simple E2E test that simulates a user journey.
- Add minimal observability: structured logs and basic request metrics.
- Learn how to inspect failing pods and correlate logs to errors.
- Run E2E tests locally and inside the CI pipeline.

## ⚙️ Structure

| Module                   | Description                                                           | Outcome                                                  |
| ------------------------ | --------------------------------------------------------------------- | -------------------------------------------------------- |
| **test1 (E2E)**          | Write one happy-path E2E test using Playwright or an API script.      | `npm test` (or `make e2e`) passes locally and in CI.     |
| **ops0 (Observability)** | Add structured logs and a request counter metric (or basic log grep). | You can inspect logs and identify failing request paths. |

## ⚠️ Problem / Issue

- Current tests only validate backend logic.
- No visibility into failures or latency.
- Need a way to monitor and trace app health in real time.

## 📖 Concepts Introduced

- End-to-End testing principles.
- Test automation in CI pipelines.
- Observability pillars: logs, metrics, traces.
- Log inspection (`kubectl logs`), metric scraping basics.
- Git hooks for pre-commit or pre-push checks.

## 🔍 Reflection

✅ E2E tests verify user-facing workflows.  
✅ Observability provides insight into real failures.  
❌ Monitoring and alerting still basic.  
🔜 Next: **Test 7 — Cloud-Ready Stub** will explore preparing for real production environments.
