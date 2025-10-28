# ☸️ Kubernetes 0 — Run Application in Kubernetes

## 🎯 Objective

**Deploy the containerized application to Kubernetes** using Kind (Kubernetes in Docker).  
This test translates the Docker Compose setup into Kubernetes manifests (Deployments, Services, PersistentVolumeClaims) and runs the application in a local Kubernetes cluster.

## ⛓️ Prerequisites

Before starting Kubernetes 0, ensure you have completed:

- ✅ **Test 3 — Docker 3** — Docker Compose application running successfully
- ✅ **Docker Hub images** — Backend and frontend images pushed to Docker Hub
- ✅ **Kind installed** — Local Kubernetes cluster setup

## 📦 Components

- `k8s/database.yaml` — Postgres Deployment with PersistentVolumeClaim
- `k8s/backend.yaml` — Go API Deployment and Service
- `k8s/frontend.yaml` — Nginx frontend Deployment and NodePort Service

## 🧠 What to Do

1. **Install Kind** — Create local Kubernetes cluster
2. **Deploy database** — Postgres with persistent storage
3. **Deploy backend** — Go API connecting to database service
4. **Deploy frontend** — Nginx serving static Flutter app
5. **Access application** — Port-forward services and test

## ✅ What "Done" Looks Like

- ✅ Kubernetes cluster running via Kind
- ✅ Database deployment with PersistentVolumeClaim working
- ✅ Backend deployment connecting to database service
- ✅ Frontend deployment accessible via port-forwarding
- ✅ Application functions identically to Docker Compose version
- ✅ Counter persists across pod restarts (due to PVC)

## 🧪 Verification

1. **Check all pods are running:**

   ```bash
   kubectl get pods
   # All should show "Running" status
   ```

2. **Check PersistentVolumeClaim:**

   ```bash
   kubectl get pvc
   # Should show postgres-pvc Bound
   ```

3. **Test the application:**

   - Port-forward backend: `kubectl port-forward service/backend-service 8080:8080`
   - Port-forward frontend: `kubectl port-forward service/frontend-service 8090:80`
   - Visit `http://localhost:8090`
   - Increment counter and verify it works

4. **Test persistence:**
   ```bash
   kubectl delete pod -l app=postgres
   # Wait for pod to restart
   # Counter value should persist
   ```

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Kubernetes 0 Tutorial](../../tutoring/04_Test3_ContainerizeApplication/kubernetes0.md)** — Complete Kubernetes deployment guide

## 🚀 Next Step

Once the application runs successfully in Kubernetes, proceed to **Test 4 — CI Pipeline** to automate builds, tests, and deployment using continuous integration.
