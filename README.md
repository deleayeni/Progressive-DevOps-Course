# From Fullstack to DevOps — A Progressive Learning Path

## 📘 Introduction

This course is a **progressive, test-driven roadmap** for learning DevOps by building and evolving a real application step by step.  
Instead of long theory sessions, each stage focuses on a **practical, working demo** that teaches one DevOps concept at a time.

Each step:

- Solves a real technical problem.
- Introduces one or two new DevOps principles or tools.
- Reveals the next limitation that motivates the following step.

Through this iterative process, you’ll move from a simple Flutter app to a fully containerized, automated, and deployable system.  
By the end, you’ll have built and understood the complete stack — **frontend, backend, database, pipelines, and Kubernetes** — while learning _why each layer matters_.

## 🎯 Audience

- Developers who know some programming but want to understand **how frontend, backend, and databases fit together**.
- Learners curious about **DevOps concepts** (CI/CD, monitoring, scaling) but unsure where to start.
- No prior experience with Flutter, Go, or Postgres is required — each step is guided and incremental.

## 🛠 Teaching Philosophy

- **Demystify, not master** — We focus on clarity and practical understanding over deep specialization.
- **Build in small bricks** — Each test or demo is achievable within 1–2 days and produces a working result.
- **Progressive complexity** — Every stage builds on the previous one, layering concepts from frontend → backend → database → DevOps pipelines.
- **Reflect and iterate** — Each step ends with a reflection on what was solved and what limitation leads to the next challenge.
- **Learn by doing** — The best way to understand DevOps is by building and breaking real systems.

## 📂 Course Structure

This course is organized into **progressive tests**, each one introducing a new DevOps layer while solving a concrete technical problem.  
Every test builds on the last — transforming a simple Flutter app into a full, containerized, and automated system.

### 🚀 Quick Navigation

- **[📚 Course Introduction](tutoring/00_Introduction/_overview.md)** — How to use this course
- **[🧩 All Tests Overview](#course-tests)** — Jump to any test below

### 🧩 Test 0 — Just UI

- **Frontend0**: A Flutter counter app that runs locally.
- **Goal**: Understand what a frontend-only application is and where its limits lie.
- **Problem**: The counter resets every time the app restarts — there's no persistence.
- **Concepts Introduced**:
  - Stateful vs Stateless widgets in Flutter.
  - Local app state and memory.
  - Why real-world apps need a backend to store data.
- **Lesson**: Frontend-only apps are simple but ephemeral; they cannot retain data or handle collaboration.

**📁 Resources:**

- **[Implementation](tests/test0-frontend-only/README.md)** — Build the Flutter app
- **[Tutoring Materials](tutoring/01_Test0_FrontendOnly/_overview.md)** — Deep dive into concepts

### 🧩 Test 1 — UI + Backend

- **Frontend1**: The Flutter app now calls a backend API.
- **Backend1**: A Go server provides a `/counter` API with in-memory state.
- **Goal**: Introduce the client-server model and basic API communication.
- **Problem**: State now persists across UI restarts, but resets if the backend restarts.
- **Concepts Introduced**:
  - HTTP requests and endpoints (GET, POST).
  - JSON serialization between frontend and backend.
  - Running a Go HTTP server locally.
  - API-driven architecture.
- **Lesson**: You've decoupled logic from the UI — the backend now owns the state, but it still isn't persistent across process restarts.

**📁 Resources:**

- **[Implementation](tests/test1-ui-backend/README.md)** — Build the client-server app
- **[Tutoring Materials](tutoring/02_Test1_UI_Backend/_overview.md)** — Deep dive into concepts

### 🧩 Test 2 — Add Database

- **Database0**: Run Postgres inside a Docker container.
- **Backend2**: The Go server now connects to Postgres to persist counter data.
- **Frontend2**: Still communicates via the same API — no frontend changes required.
- **Goal**: Introduce data persistence using a relational database.
- **Problem**: The backend used in-memory storage before; data disappeared when the process stopped. We now need persistent storage across restarts.
- **Concepts Introduced**:
  - Postgres setup using Docker (`docker run postgres`).
  - Basic SQL: CREATE TABLE, INSERT, SELECT.
  - Connection strings and environment variables.
  - Volumes for persistent data in Docker.
- **Lesson**: The backend now persists state in a real database. The app survives restarts — but the setup is still manual and not yet portable.

**📁 Resources:**

- **[Implementation](tests/test2-add-database/README.md)** — Add database persistence
- **[Tutoring Materials](tutoring/03_Test2_AddDatabase/_overview.md)** — Deep dive into concepts

### 🧩 Test 3 — Containerize the Application

- **Goal**: Make the entire stack reproducible and runnable on any machine using Docker.
- **Problem**: So far, each developer must install Flutter, Go, and Postgres manually — causing inconsistency between environments.
- **Modules**:
  - **Docker0 – Backend Image**: Create a simple Dockerfile for the Go backend and run it as a container.
  - **Frontend2 – Static Build**: Use `flutter build web` to produce static HTML/JS files for deployment.
  - **Docker2 – Nginx Frontend Image**: Serve the static frontend with Nginx using a custom image.
  - **Docker3 – Compose Setup**: Define all services (frontend, backend, database) in `docker-compose.yml` for one-command startup.
- **Concepts Introduced**:
  - Dockerfiles (FROM, COPY, RUN, CMD).
  - Container networking and port mapping.
  - Volumes for database persistence.
  - Declarative multi-container setups with Docker Compose.
- **Lesson**: You can now run the entire application — frontend, backend, and database — consistently on any machine using `docker compose up`.  
  This marks the transition from **local development** to **portable DevOps environments**.

**📁 Resources:**

- **[Implementation](tests/test3-containerize-application/README.md)** — Containerize the full stack
- **[Tutoring Materials](tutoring/04_Test3_ContainerizeApplication/_overview.md)** — Deep dive into concepts

## 🔮 Future Roadmap

After mastering the fundamentals through Tests 0–3, the course continues into advanced DevOps automation and operations.

### 🧩 Test 4 — CI Pipeline

Automate builds, tests, and artifact publishing using GitHub Actions or Azure Pipelines.  
Learn to define workflows that build Docker images, run integration tests, and validate code before merging.

**📁 Resources:**

- **[Implementation](tests/test4-ci-pipeline/README.md)** — Set up CI/CD pipeline
- **[Tutoring Materials](tutoring/05_Test4_CI_Pipeline/_overview.md)** — Deep dive into concepts

### 🧩 Test 5 — Kubernetes Deploy

Deploy the full stack (frontend, backend, database) on a local **kind** cluster.  
Use Deployments, Services, ConfigMaps, and Secrets to understand how real-world systems scale and recover.

**📁 Resources:**

- **[Implementation](tests/test5-kubernetes-deploy/README.md)** — Deploy to Kubernetes
- **[Tutoring Materials](tutoring/06_Test5_Kubernetes_MinimalDeploy/_overview.md)** — Deep dive into concepts

### 🧩 Test 6 — End-to-End Tests & Observability

Run a full user-path test (E2E) using Playwright or curl-based scripts.  
Add basic observability: structured logs and simple metrics to track requests and diagnose failures.

**📁 Resources:**

- **[Implementation](tests/test6-e2e-observability/README.md)** — Add testing and monitoring
- **[Tutoring Materials](tutoring/07_Test6_E2E_Observability/_overview.md)** — Deep dive into concepts

### 🧩 Test 7 — Cloud-Ready Configuration

Prepare the app for production with templated Helm charts or Kustomize overlays.  
Add external database configuration, secrets management, and environment-based deployments.

**📁 Resources:**

- **[Implementation](tests/test7-cloud-ready/README.md)** — Prepare for production
- **[Tutoring Materials](tutoring/08_Test7_CloudReadyStub/_overview.md)** — Deep dive into concepts

## ✅ Outcomes

By completing this course, you will:

- Understand how each layer of a modern application works — from **frontend UI** to **backend API**, **database**, **containers**, and **deployment**.
- Learn to **containerize** your systems with Docker and define multi-service environments using Docker Compose.
- Build confidence in **automation** through continuous integration pipelines that test and validate every change.
- Deploy and manage your application on **Kubernetes**, gaining insight into scaling, health checks, and self-healing systems.
- Introduce **observability** by collecting logs and metrics to monitor system behavior.
- Develop a solid mental model of how real software moves from **development** to **production** — reliably and repeatably.

## 📎 Resources

- Roadmap diagram: [roadmap.sh — Become a DevOps Engineer](https://roadmap.sh/r/become-a-devops-engineer-toqtq)
- Individual demo READMEs are inside their folders:
  - `demo0-frontend-backend/README.md`
  - `demo1-ui-backend/README.md`
  - `demo2-add-database/README.md`
