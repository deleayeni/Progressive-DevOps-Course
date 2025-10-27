# 🐳 Docker 3 — Docker Compose

## 🎯 Learning Goal

- Learn how to use Docker Compose to run the backend, frontend, and database with one command
- Understand how Compose manages networking, volumes, and environment configuration
- Move from manually running containers to defining a multi-container system
- **Master real-world issues:** Health checks, CORS, database initialization, and networking gotchas

## ⚠️ Problem / Issue

- You can now run each service individually, but that's messy and error-prone
- You need a unified way to define how all containers run together
- Each component depends on the others (frontend → backend → database), so they must start and connect automatically
- **Real-world challenge:** Services start at different speeds, causing race conditions and connection failures

## 🛠 Guided Steps with Resources

1. **Create a `docker-compose.yml` file in your project root:**

   ```yaml
   version: "3.9"

   services:
     db:
       image: postgres:16
       container_name: my-postgres
       environment:
         POSTGRES_PASSWORD: secret
         POSTGRES_DB: appdb
       volumes:
         - pgdata:/var/lib/postgresql/data
       ports:
         - "5433:5432" # Use 5433 to avoid conflicts with local Postgres
       healthcheck:
         test: ["CMD-SHELL", "pg_isready -U postgres"]
         interval: 10s
         timeout: 5s
         retries: 5

     backend:
       build: ./backend3
       container_name: go-backend
       environment:
         - DATABASE_URL=postgres://postgres:secret@db:5432/appdb?sslmode=disable
         - PORT=8080
       depends_on:
         db:
           condition: service_healthy # Wait for database to be ready
       ports:
         - "8080:8080"

     frontend:
       build: ./frontend2
       container_name: flutter-frontend
       depends_on:
         - backend
       ports:
         - "80:80"

   volumes:
     pgdata:
   ```

   **Key improvements:**

   - **Health check** on database prevents race conditions
   - **Conditional dependency** ensures backend waits for healthy database
   - **Port 5433** avoids conflicts with local Postgres installations

2. **Ensure your backend creates database tables:**

   **Critical:** Your Go backend must create tables before trying to use them:

   ```go
   // In your main.go, add this before any database operations:
   _, err = db.Exec(context.Background(),
       `CREATE TABLE IF NOT EXISTS counters (
           id INTEGER PRIMARY KEY,
           value INTEGER NOT NULL
       )`)
   if err != nil {
       log.Fatalf("Failed to create counters table: %v\n", err)
   }
   ```

3. **Add CORS headers to your backend:**

   **Essential for web frontends:** Add CORS headers to allow browser requests:

   ```go
   func getCounterHandler(w http.ResponseWriter, r *http.Request) {
       // Add CORS headers
       w.Header().Set("Access-Control-Allow-Origin", "*")
       w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
       w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

       if r.Method == http.MethodOptions {
           return // Handle preflight requests
       }

       // ... rest of your handler
   }
   ```

4. **Configure frontend API URL correctly:**

   **Important:** Use `localhost:8080` for browser-based requests:

   ```dart
   // In api_client.dart
   final String baseUrl = "http://localhost:8080";  // NOT backend:8080
   ```

   **Why:** Browsers can't resolve Docker service names like `backend:8080`

5. **Run all services:**

   ```bash
   docker compose up --build
   ```

   - Builds images and starts all containers
   - Access the app at `http://localhost`

6. **View logs and status:**

   ```bash
   docker compose ps
   docker compose logs -f backend
   docker compose logs -f frontend
   ```

   - `docker compose ps` → list running services
   - `docker compose logs -f backend` → stream logs from one container

7. **Push images to Docker Hub (for Kubernetes later):**

   **Important:** You'll need these images in Docker Hub for the Kubernetes exercise.

   ```bash
   # Tag your images for Docker Hub (replace 'yourusername' with your Docker Hub username)
   docker tag docker3-backend:latest yourusername/counter-backend:latest
   docker tag docker3-frontend:latest yourusername/counter-frontend:latest

   # Push to Docker Hub
   docker push yourusername/counter-backend:latest
   docker push yourusername/counter-frontend:latest
   ```

   **Why this matters:** Kubernetes will pull these images from Docker Hub, not your local machine.

8. **Stop and clean up:**

   ```bash
   docker compose down
   docker compose down -v
   ```

   - `docker compose down` → stop all services
   - Add `-v` to also remove volumes if needed

## 🚨 Common Issues & Solutions

### **Issue 1: Race Conditions**

**Problem:** Backend starts before database is ready
**Solution:** Use health checks and conditional dependencies

### **Issue 2: Missing Database Tables**

**Problem:** Backend tries to query non-existent tables
**Solution:** Always create tables with `CREATE TABLE IF NOT EXISTS`

### **Issue 3: CORS Errors**

**Problem:** Browser blocks requests to different origins
**Solution:** Add CORS headers to backend responses

### **Issue 4: Port Conflicts**

**Problem:** Local Postgres already using port 5432
**Solution:** Use different external port (5433:5432)

### **Issue 5: Frontend Not Making Requests**

**Problem:** Using `backend:8080` instead of `localhost:8080`
**Solution:** Browsers can't resolve Docker service names

### **Issue 6: Frontend Not Updating**

**Problem:** Frontend not rebuilt after code changes
**Solution:** Always run `flutter build web` after changes

## 📖 Concepts Introduced

- **Docker Compose** — Tool to manage multiple containers declaratively
- **Service** — Each container (frontend, backend, db) defined as a service in YAML
- **Networking** — Compose gives every service a shared network; they can reach each other by name
- **Volume management** — Persistent data across container restarts
- **Health checks** — Ensure services are ready before dependent services start
- **CORS** — Cross-Origin Resource Sharing for web applications
- **Declarative infrastructure** — The app's architecture is described in configuration, not manual commands

## 🔍 Reflection

- ✅ **Solved:** All services (frontend, backend, DB) start together with one command
- ✅ **Automatic networking:** Containers automatically communicate through a shared network
- ✅ **Production-ready:** Health checks, CORS, and proper dependencies
- ✅ **Real-world patterns:** Database initialization, error handling, debugging
- ❌ **Limitation:** Still running locally — no automation or remote deployment yet
- 🔜 **Next (Test 4):** Set up a Continuous Integration pipeline to automate builds and testing before deployment

## 🎯 Key Takeaways

**Docker Compose is more than just YAML syntax:**

- **Health checks** prevent race conditions
- **CORS** is essential for web applications
- **Database initialization** must be handled explicitly
- **Networking** differs between containers and browsers
- **Debugging** requires understanding logs and common failure patterns

**This foundation prepares you for production deployments where these issues are critical!**
