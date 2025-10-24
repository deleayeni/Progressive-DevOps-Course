# 🐳 Docker 1 — Build Backend Image

## 🎯 Objective

Create a Docker image for the backend application and run it as a container.  
This demonstrates how to package a Go application so it can run anywhere without installing Go manually.

## ⛓️ Prerequisites

Before starting this module, ensure:

- ✅ **Docker is installed and running** (Docker0 from Test 2)
- ✅ **Postgres database is running** (Database0 from Test 2)
  - The backend connects to Postgres on startup and will fail without it
  - Verify: `docker ps` should show your Postgres container

## 🧠 What to Build

Create a Dockerfile that:

1. Uses a Go base image
2. Copies the backend code into the container
3. Builds the Go application
4. Exposes port 8080
5. Runs the compiled backend server

## ✅ What "Done" Looks Like

- ✅ Dockerfile exists in the backend directory
- ✅ Docker image builds successfully
- ✅ Backend container runs and connects to Postgres
- ✅ API endpoints are accessible from your host machine
- ✅ Counter operations work correctly

## 🧪 Verification

1. **Build the image:**

   - Image builds without errors
   - All dependencies are included

2. **Run the container:**

   - Container starts successfully
   - Connects to the database
   - Logs show "Server running..."

3. **Test the API:**
   - `curl http://localhost:8080/counter` returns JSON
   - Counter increments when posted to

## 💭 Important: Environment Variables vs `.env` Files

In previous tests, your backend loaded configuration from a `.env` file on your machine. **This no longer works in Docker** because:

- **Containers have isolated filesystems** - They can't see files on your host machine
- **The `.env` file isn't copied into the image** (and shouldn't be - security risk!)
- **You must pass configuration via the `-e` flag** when running containers

Your backend code handles this gracefully by falling back to `os.Getenv()` when the `.env` file isn't found. This is **best practice** - configuration should come from environment variables in containers, not baked-in files.

**Example:**

```bash
docker run -p 8080:8080 \
  -e DATABASE_URL="postgres://postgres:secret@host.docker.internal:5432/appdb?sslmode=disable" \
  backend-image
```

**Note:** Later modules will show you cleaner ways to manage environment variables for multiple containers.

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 3 Overview](../../../tutoring/04_Test3_ContainerizeApplication/_overview.md)** — Course introduction and concepts
- **[Docker 1 Tutorial](../../../tutoring/04_Test3_ContainerizeApplication/docker1.md)** — Backend containerization

## 🚀 Next Step

Once your backend runs in a container, proceed to **Frontend 2** to build the Flutter app as static files for web deployment.
