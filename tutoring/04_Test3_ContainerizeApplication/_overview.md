# 🧩 Test 3 — Containerize Application

## 🧠 Overview

After Test 2, everything worked but required manual setup.  
Each developer had to install Go, Flutter, and Postgres separately — which quickly leads to “it works on my machine” problems.

In **Test 3**, we fix this by **containerizing every component** (backend, frontend, and database) using Docker so the entire system runs identically on any machine.

## 🎯 Learning Goals

- Package all services (frontend, backend, Postgres) into reproducible Docker containers.
- Understand Dockerfiles, images, containers, and volumes.
- Learn how containers communicate through Docker networks.
- Use Docker Compose to orchestrate the full stack with one command.

## ⚙️ Structure

| Module        | Description                                                  | Outcome                                          |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------ |
| **docker1**   | Build backend image.                                         | Backend runs in its own container.               |
| **frontend2** | Compile and prepare static frontend files.                   | Flutter app becomes static deployable web files. |
| **docker2**   | Serve the built frontend using Nginx.                        | UI runs from an Nginx container.                 |
| **docker3**   | Combine backend, frontend, and database with Docker Compose. | Full system starts with a single command.        |

## ⚠️ Problem / Issue

- Everything still runs locally and manually.
- Process setup varies between machines.
- We need reproducibility, isolation, and automation.

## 📖 Concepts Introduced

- Containerization for consistent environments.
- Dockerfile structure (`FROM`, `COPY`, `RUN`, `CMD`).
- Images vs containers.
- Volumes for persistent storage.
- Container networking.
- Declarative infrastructure with Docker Compose.

## 🔍 Reflection

✅ Solved — The whole application runs identically on any machine.  
✅ Data persists via Docker volumes.  
❌ Limitation — Still manual builds and no CI/CD yet.  
🔜 Next: **Test 4 — Continuous Integration** will automate build and test steps.
