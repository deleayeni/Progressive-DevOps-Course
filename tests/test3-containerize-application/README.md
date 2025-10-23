# 🐳 Test 3 — Containerize Application

## 🎯 Objective

**Containerize the entire application stack** (frontend, backend, and database) using Docker and Docker Compose.  
This test transforms the application from manual setup to a reproducible, one-command deployment that runs identically on any machine.

## 📦 Modules

- `docker1/` — Build backend image
- `frontend2/` — Build static webpage
- `docker2/` — Customize image (Nginx frontend)
- `docker3/` — Docker Compose setup

## 🧠 What to Do

1. **Backend**: Create a Dockerfile for the Go server and build an image
2. **Frontend**: Build Flutter web app as static files, then serve with Nginx
3. **Database**: Use existing Postgres container
4. **Orchestration**: Define all services in `docker-compose.yml`

## ✅ What "Done" Looks Like

- ✅ Backend runs in its own Docker container
- ✅ Frontend is built as static files and served by Nginx container
- ✅ Database runs in Postgres container with persistent storage
- ✅ All services start with one command: `docker compose up`
- ✅ Application runs identically on any machine with Docker

## 🧪 Verification

1. **Check running containers:**

   ```bash
   docker compose ps
   ```

2. **Test the full application:**

   - Visit `http://localhost` (frontend)
   - Click the counter button
   - Verify the counter increments and persists

3. **Test persistence:**
   ```bash
   docker compose down
   docker compose up
   # Counter value should persist
   ```

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 3 Overview](../../tutoring/04_Test3_ContainerizeApplication/_overview.md)** — Course introduction and concepts
- **[Docker 1 Tutorial](../../tutoring/04_Test3_ContainerizeApplication/docker1.md)** — Backend containerization
- **[Frontend 2 Tutorial](../../tutoring/04_Test3_ContainerizeApplication/frontend2.md)** — Static web build
- **[Docker 2 Tutorial](../../tutoring/04_Test3_ContainerizeApplication/docker2.md)** — Frontend containerization
- **[Docker 3 Tutorial](../../tutoring/04_Test3_ContainerizeApplication/docker3.md)** — Docker Compose orchestration

## 🚀 Next Step

Once the containerized application runs successfully, proceed to **Test 4 — CI Pipeline** to automate builds, tests, and deployment using continuous integration.
