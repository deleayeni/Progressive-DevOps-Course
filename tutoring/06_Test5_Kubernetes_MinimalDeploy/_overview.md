# ☸️ Test 5 — Kubernetes (kind) Minimal Deploy

## 🧠 Overview

Up to now, everything runs locally with Docker Compose.  
**Test 5 introduces Kubernetes (K8s):** deploying the same application using Kubernetes primitives — Pods, Deployments, and Services.

You’ll deploy the backend and database onto a local cluster (kind or Minikube), learning how container orchestration replaces manual container management.

## 🎯 Learning Goals

- Understand core Kubernetes objects: Deployment, Service, ConfigMap, Secret.
- Deploy backend and database to a local cluster.
- Expose the application externally via port-forwarding.
- Observe how pods restart, self-heal, and stay stateless.

## ⚙️ Structure

| Module                            | Description                                                                                             | Outcome                                                          |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **k8s0 — Deployments & Services** | Write manifests for backend and DB; include ConfigMap/Secret for DB URL; add readiness/liveness probes. | `kubectl port-forward` exposes `/counter`; pods restart cleanly. |
| **helm0 (or kustomize0)**         | Package manifests as templates with `values.dev.yaml`.                                                  | `helm install app -f values.dev.yaml` brings app up on kind.     |

## ⚠️ Problem / Issue

- Docker Compose cannot scale or self-heal containers.
- Manual container startup doesn’t simulate real deployments.

## 📖 Concepts Introduced

- Kubernetes cluster basics (Nodes, Pods, Deployments, Services).
- Declarative configuration and self-healing.
- ConfigMaps and Secrets for environment configuration.
- Helm or Kustomize for templated manifests.

## 🔍 Reflection

✅ Application deployed on local K8s cluster.  
✅ Configurable manifests and self-healing behavior.  
❌ No observability or monitoring yet.  
🔜 Next: **Test 6 — E2E + Observability** will validate user flows and add visibility into the system.
