# ☸️ Kubernetes 0 — Local Kubernetes with Kind

## 🎯 Learning Goal

- Learn how to run the same containerized application using Kubernetes instead of Docker Compose
- Understand how to translate Docker Compose services to Kubernetes resources
- Use Kind (Kubernetes in Docker) for local Kubernetes development
- **Master Kubernetes fundamentals:** Pods, Services, Deployments, and ConfigMaps

## ⚠️ Problem / Issue

- Docker Compose works great for local development, but production uses Kubernetes
- You need to understand how containerized applications run in Kubernetes
- **Real-world challenge:** Translating Docker Compose concepts to Kubernetes resources
- **Learning gap:** Understanding Kubernetes abstractions (Pods, Services, Deployments)

## 🛠 Guided Steps with Resources

### **Step 1: Install Kind (Kubernetes in Docker)**

```bash
# Install Kind
# Windows (using Chocolatey)
choco install kind

# Or download binary
curl -Lo ./kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64.exe
Move-Item ./kind-windows-amd64.exe c:\some-dir-in-your-PATH\kind.exe

# Verify installation
kind version
```

### **Step 2: Create a Kind Cluster**

```bash
# Create a new Kind cluster
kind create cluster --name counter-app

# Verify cluster is running
kubectl cluster-info --context kind-counter-app

# Check nodes
kubectl get nodes
```

### **Step 3: Essential Kubernetes Concepts**

**Before creating YAML files, understand these basics:**

#### **3.1 Core Kubernetes Resources**

- **Pod** — Smallest unit, runs one or more containers
- **Deployment** — Manages Pods, handles scaling and updates
- **Service** — Provides stable network access to Pods
- **PersistentVolumeClaim** — Requests persistent storage for Pods

#### **3.2 Service Types**

- **ClusterIP** — Internal access only (default)
- **NodePort** — Exposes service on node's IP
- **LoadBalancer** — External load balancer (cloud only)

#### **3.3 Labels and Selectors**

- **Labels** — Key-value pairs attached to resources
- **Selectors** — Used by Services to find Pods with matching labels

### **Step 4: Create Basic Kubernetes Manifests**

**Create YAML files with persistent storage for the database:**

#### **4.1 Database (PostgreSQL)**

**Create `k8s/database.yaml`:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          env:
            - name: POSTGRES_PASSWORD
              value: "secret"
            - name: POSTGRES_DB
              value: "appdb"
          volumeMounts:
            - name: postgres-storage
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
```

#### **4.2 Backend (Go API)**

**Create `k8s/backend.yaml`:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: yourusername/counter-backend:latest # Docker Hub image
          env:
            - name: DATABASE_URL
              value: "postgres://postgres:secret@postgres-service:5432/appdb?sslmode=disable"
            - name: PORT
              value: "8080"
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
    - port: 8080
      targetPort: 8080
```

#### **4.3 Frontend (Nginx)**

**Create `k8s/frontend.yaml`:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: yourusername/counter-frontend:latest # Docker Hub image
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80
  type: NodePort
```

### **Step 5: Deploy to Kubernetes**

**Note:** We're using Docker Hub images, so no need to load images into Kind.

```bash
# Apply all manifests
kubectl apply -f k8s/

# Check deployments
kubectl get deployments

# Check pods
kubectl get pods

# Check services
kubectl get services
```

### **Step 6: Access the Application**

**⚠️ Important:** Kind doesn't expose NodePorts to localhost. Use port-forwarding instead.

```bash
# Terminal 1: Port-forward backend API
kubectl port-forward service/backend-service 8080:8080

# Terminal 2: Port-forward frontend (different port)
kubectl port-forward service/frontend-service 8090:80

# Test backend API
curl http://localhost:8080/counter
# Should return: {"id":1,"value":0}

# Access frontend at http://localhost:8090
```

**Why two terminals?** The frontend (running in browser) needs to call the backend API. By port-forwarding backend to 8080 and frontend to 8090, the frontend can reach the backend at `localhost:8080`.

## 🔄 Docker Compose vs Kubernetes Translation

| Docker Compose | Kubernetes              | Purpose                      |
| -------------- | ----------------------- | ---------------------------- |
| `services:`    | `Deployment`            | Define how containers run    |
| `ports:`       | `Service`               | Expose containers to network |
| `environment:` | `env:` in Deployment    | Environment variables        |
| `volumes:`     | `PersistentVolumeClaim` | Persistent storage           |
| `depends_on:`  | Manual ordering         | Startup dependencies         |
| `image:`       | `image:` in Deployment  | Container image              |

**Key Differences:**

- **Docker Compose:** Single file, automatic networking
- **Kubernetes:** Multiple files, explicit service definitions
- **Networking:** Compose uses service names, K8s uses service names + ports

## 🚨 Common Issues & Solutions

### **Issue 1: Images Not Found**

**Problem:** Kubernetes can't find your Docker images
**Solution:** Use `kind load docker-image` to load images into cluster

### **Issue 2: Pods Not Starting**

**Problem:** Containers fail to start
**Solution:** Check logs with `kubectl logs <pod-name>`

### **Issue 3: Port Conflicts (CRITICAL)**

**Problem:** `bind: address already in use` when port-forwarding
**Symptoms:**

- Error: `unable to listen on port 8080: address already in use`
- Previous kubectl port-forward still running

**Solution:**

```bash
# Find what's using the port
lsof -i :8080
# or on Windows: netstat -ano | findstr :8080

# Kill the process (replace PID with actual number)
kill <PID>

# Or use a different port
kubectl port-forward service/frontend-service 8090:80
```

### **Issue 4: Frontend Can't Reach Backend (404 Errors)**

**Problem:** Frontend loads but counter shows 0, plus button doesn't work
**Symptoms:**

- Browser console shows: `Failed to load resource: 404 (Not Found)`
- API calls to `/counter` and `/counter/increment` fail

**Root Cause:** Frontend is calling `localhost:8080` but that's forwarding to the frontend service, not backend

**Solution:**

```bash
# Terminal 1: Port-forward backend to 8080
kubectl port-forward service/backend-service 8080:8080

# Terminal 2: Port-forward frontend to different port
kubectl port-forward service/frontend-service 8090:80

# Test backend API
curl http://localhost:8080/counter

# Access frontend at http://localhost:8090
```

### **Issue 5: NodePort Not Working with Kind**

**Problem:** `localhost:31850` shows "site can't be reached"
**Root Cause:** Kind doesn't expose NodePorts to localhost by default

**Solution:** Use port-forwarding instead of NodePort

```bash
kubectl port-forward service/frontend-service 8080:80
```

### **Issue 6: Database Connection Issues**

**Problem:** Backend can't connect to database
**Solution:** Use Kubernetes service names (e.g., `postgres-service:5432`)

### **Issue 7: Configuration Not Applied**

**Problem:** Environment variables not set
**Solution:** Verify ConfigMaps are created and referenced correctly

### **Issue 8: Frontend API URL Mismatch**

**Problem:** Frontend built with wrong API URL
**Solution:** Update frontend code and rebuild:

```dart
// In api_client.dart
final String baseUrl = "http://localhost:8080"; // Backend port-forward
```

Then rebuild and redeploy:

```bash
flutter build web
docker build -t yourusername/counter-frontend:latest .
docker push yourusername/counter-frontend:latest
kubectl rollout restart deployment/frontend
```

## 🔧 Debugging Your Kubernetes Application

### **Step-by-Step Debugging Process**

**1. Check Pod Status**

```bash
kubectl get pods
# All should show "Running" status
```

**2. Check Pod Logs**

```bash
# Check backend logs
kubectl logs -l app=backend

# Check frontend logs
kubectl logs -l app=frontend

# Check database logs
kubectl logs -l app=postgres
```

**3. Check Service Endpoints**

```bash
kubectl get endpoints
# Verify services have endpoints (not empty)
```

**4. Test Backend API Directly**

```bash
# Port-forward backend
kubectl port-forward service/backend-service 8080:8080

# Test in another terminal
curl http://localhost:8080/counter
curl http://localhost:8080/counter/increment
```

**5. Check Browser Console**

- Open Developer Tools (F12)
- Look for JavaScript errors
- Check Network tab for failed requests

**6. Verify Port Conflicts**

```bash
# Check what's using port 8080
lsof -i :8080
# or on Windows: netstat -ano | findstr :8080
```

### **Common Debugging Commands**

```bash
# Get detailed pod information
kubectl describe pod <pod-name>

# Get detailed service information
kubectl describe service <service-name>

# Check if images are loaded in Kind
docker exec -it counter-app-control-plane crictl images

# Restart a deployment
kubectl rollout restart deployment/<deployment-name>

# Check deployment status
kubectl rollout status deployment/<deployment-name>
```

## 📖 Concepts Introduced

- **Kind** — Kubernetes in Docker for local development
- **Pods** — Smallest deployable units in Kubernetes
- **Deployments** — Manage Pod replicas and updates
- **Services** — Stable network endpoints for Pods
- **PersistentVolumeClaim** — Request persistent storage resources
- **NodePort** — Expose services on cluster nodes
- **Port Forwarding** — Access services locally

## 🔍 Reflection

- ✅ **Solved:** Same application running in Kubernetes instead of Docker Compose
- ✅ **Translation mastery:** Understanding how Compose concepts map to K8s resources
- ✅ **Local development:** Kind provides realistic Kubernetes environment
- ✅ **Production preparation:** Learning industry-standard orchestration
- ❌ **Limitation:** Still running locally — no cloud deployment yet
- 🔜 **Next (Test 4):** Set up CI/CD pipeline to automate builds and deployments

## 🎯 Key Takeaways

**Kubernetes is the production standard:**

- **Pods** are the basic unit (not containers)
- **Services** provide stable networking
- **Deployments** manage application lifecycle
- **PersistentVolumeClaims** ensure data persistence
- **Kind** enables local Kubernetes development

**This foundation prepares you for cloud-native applications and production deployments!**

## 🚀 Quick Commands Reference

```bash
# Cluster management
kind create cluster --name counter-app
kind delete cluster --name counter-app

# Application management
kubectl apply -f k8s/
kubectl get pods
kubectl get services
kubectl logs <pod-name>

# Access application (TWO TERMINALS NEEDED)
# Terminal 1: Backend API
kubectl port-forward service/backend-service 8080:8080

# Terminal 2: Frontend
kubectl port-forward service/frontend-service 8090:80

# Debugging
kubectl describe pod <pod-name>
kubectl get endpoints
lsof -i :8080  # Check port conflicts
curl http://localhost:8080/counter  # Test backend API

# Restart deployments
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/backend
```
