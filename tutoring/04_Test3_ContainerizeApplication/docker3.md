# 🐳 Docker 3 — Docker Compose

## 🎯 Learning Goal

- Learn how to use Docker Compose to run the backend, frontend, and database with one command
- Understand how Compose manages networking, volumes, and environment configuration
- Move from manually running containers to defining a multi-container system

## ⚠️ Problem / Issue

- You can now run each service individually, but that's messy and error-prone
- You need a unified way to define how all containers run together
- Each component depends on the others (frontend → backend → database), so they must start and connect automatically

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
         - "5432:5432"

     backend:
       build: ./backend
       container_name: go-backend
       environment:
         - DATABASE_URL=postgres://postgres:secret@db:5432/appdb?sslmode=disable
         - PORT=8080
       depends_on:
         - db
       ports:
         - "8080:8080"

     frontend:
       build: ./frontend
       container_name: flutter-frontend
       depends_on:
         - backend
       ports:
         - "80:80"

   volumes:
     pgdata:
   ```

2. **Run all services:**

   ```bash
   docker compose up --build
   ```

   - Builds images and starts all containers
   - Access the app at `http://localhost`

3. **View logs and status:**

   ```bash
   docker compose ps
   docker compose logs -f backend
   ```

   - `docker compose ps` → list running services
   - `docker compose logs -f backend` → stream logs from one container

4. **Stop and clean up:**

   ```bash
   docker compose down
   docker compose down -v
   ```

   - `docker compose down` → stop all services
   - Add `-v` to also remove volumes if needed

5. **Optional: Add an `.env` file to manage secrets cleanly:**
   ```env
   POSTGRES_PASSWORD=secret
   POSTGRES_DB=appdb
   PORT=8080
   ```
   - Compose automatically loads `.env` values into the services

## 📖 Concepts Introduced

- **Docker Compose** — Tool to manage multiple containers declaratively
- **Service** — Each container (frontend, backend, db) defined as a service in YAML
- **Networking** — Compose gives every service a shared network; they can reach each other by name
- **Volume management** — Persistent data across container restarts
- **Declarative infrastructure** — The app's architecture is described in configuration, not manual commands

## 🔍 Reflection

- ✅ **Solved:** All services (frontend, backend, DB) start together with one command
- ✅ **Automatic networking:** Containers automatically communicate through a shared network
- ❌ **Limitation:** Still running locally — no automation or remote deployment yet
- 🔜 **Next (Test 4):** Set up a Continuous Integration pipeline to automate builds and testing before deployment
