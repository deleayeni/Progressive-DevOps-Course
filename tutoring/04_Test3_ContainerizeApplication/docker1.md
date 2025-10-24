# 🐳 Docker 1 — Build a Backend Image

## 🚀 Navigation

- **[← Test 3 Overview](./_overview.md)** — Back to Test 3 introduction
- **[→ Frontend 2 Tutorial](./frontend2.md)** — Next: Build static webpage

## ⛓️ Prerequisites

Before starting, ensure you have:

- **Docker installed and running** (completed Docker0 from Test 2)
- **Postgres database running** (completed Database0 from Test 2)
  - The backend needs to connect to the database on startup
  - Run: `docker ps` to verify your Postgres container is running

## 🎯 Learning Goal

- Learn how to create a simple Dockerfile for the Go backend application
- Understand how to build an image from source code and run it as a container
- Visualize basic networking (how container ports map to the host)

## ⚠️ Problem / Issue

- So far, the backend runs only through `go run main.go`
- Anyone who wants to run it must install Go and dependencies manually
- This breaks portability — we want the same backend to run anywhere with one command

## 📚 Dockerfile Basics

Before we start, let's understand what a Dockerfile is:

**A Dockerfile is a text file** (literally named `Dockerfile` with no extension) that contains **instructions** for building a Docker image. Think of it as:

- A recipe for creating a container
- A blueprint for your application environment
- A script that runs in order, top to bottom

**Anatomy of a Dockerfile:**

```
┌─────────────────────────────────────┐
│ FROM <base-image>                   │ ← Start with existing image
├─────────────────────────────────────┤
│ WORKDIR /app                        │ ← Set up working directory
├─────────────────────────────────────┤
│ COPY <files> <destination>          │ ← Copy your code
├─────────────────────────────────────┤
│ RUN <build-commands>                │ ← Install/compile during build
├─────────────────────────────────────┤
│ EXPOSE <port>                       │ ← Document port (optional)
├─────────────────────────────────────┤
│ CMD ["<command>"]                   │ ← What runs when container starts
└─────────────────────────────────────┘
```

**Key Principles:**

- 📝 Instructions are **case-insensitive** but UPPERCASE by convention
- 📦 Each instruction adds a new **layer** to your image
- 🔄 Order matters - Docker caches layers for faster rebuilds
- 💾 The final image contains everything from all layers combined

---

## 🛠 Guided Steps with Resources

1. **Create a Dockerfile in the backend folder:**

   A Dockerfile is a **recipe** that tells Docker how to build an image. Each instruction creates a new **layer** in your image.

   ```dockerfile
   # Start from a base image that already has Go installed
   # This is like inheriting from a parent - you get Go for free!
   FROM golang:1.22

   # Set the working directory inside the container
   # All subsequent commands will run from /app
   # Think of this like doing "cd /app" in a shell
   WORKDIR /app

   # Copy files from your host machine INTO the container
   # First dot (.) = source (your machine)
   # Second dot (.) = destination (/app in container)
   COPY . .

   # Run a command DURING image build (not when container starts)
   # This compiles your Go code into an executable called "main"
   # The executable will be saved in the image
   RUN go build -o main .

   # Define the DEFAULT command to run when container starts
   # This is what executes when you do "docker run"
   # Use JSON array format for better signal handling
   CMD ["./main"]
   ```

   **Key Dockerfile Concepts:**

   - **`FROM`** — Every Dockerfile starts with a base image (like `golang:1.22`, `python:3.11`, `node:18`)
   - **`WORKDIR`** — Sets the working directory; creates it if it doesn't exist
   - **`COPY`** — Copies files from host machine into the image
   - **`RUN`** — Executes commands during build (like installing packages, compiling code)
   - **`CMD`** — Specifies what runs when the container starts (only one CMD per Dockerfile)
   - **`EXPOSE`** — Documents which port your app listens on (optional but good practice)

   **Important:**

   - Each instruction creates a new **layer** (like layers in a cake)
   - Layers are cached - if nothing changes, Docker reuses previous layers
   - Order matters for caching! Put frequently-changing stuff (like COPY) toward the end

2. **Build the image:**

   ```bash
   docker build -t backend1 .
   ```

   - Creates a Docker image named `backend1`

3. **Run the container:**

   ```bash
   docker run -p 8080:8080 \
     -e DATABASE_URL="postgres://postgres:secret@host.docker.internal:5432/appdb?sslmode=disable" \
     backend1
   ```

   - `-p 8080:8080` maps the container's port 8080 to your host machine
   - `-e DATABASE_URL=...` passes the database connection string as an environment variable
   - **Note:** Use `host.docker.internal` instead of `localhost` so the container can reach your host's Postgres
   - Visit `http://localhost:8080/counter` → should return `{"value": 0}`

### 💡 Why Pass `-e` When We Have a `.env` File?

In previous tests, your backend code loaded configuration from a `.env` file:

```go
godotenv.Load("../../../.env")  // Loads .env from host machine
```

**This no longer works in Docker** because:

1. **Containers have isolated filesystems** - The `.env` file on your host machine is NOT inside the container
2. **The Dockerfile only copies backend code** - It doesn't copy the `.env` file (and shouldn't - security risk!)
3. **Your code gracefully falls back** - When the `.env` file isn't found, it reads from `os.Getenv()` instead

```go
if err := godotenv.Load("../../../.env"); err != nil {
    log.Println("No .env file found, falling back to system environment variables")
}
dsn := os.Getenv("DATABASE_URL")  // This reads the -e flag!
```

**This is actually best practice:**

- ✅ `.env` files are for **local development** convenience
- ✅ Environment variables (`-e` flag) are for **containers and production**
- ✅ Same code works in both environments
- ✅ Configuration stays outside the image (portable and secure)

---

### 🌐 Important: Docker Networks (Container-to-Container Communication)

**Problem you might encounter:**

If you try to connect your backend container to the database using `host.docker.internal`, you might get connection errors on some systems (especially Windows/WSL). This is because containers are isolated by default.

**The Solution: Docker Networks**

**What are Docker networks?**

- Docker creates **isolated networks** for containers to communicate
- Containers on the same network can talk to each other **by name**
- This is more reliable than using `host.docker.internal`

**How it works:**

```
Without Network:                    With Network (myapp-network):
┌──────────────┐                   ┌──────────────┐
│   Backend    │ ❌ Can't reach    │   Backend    │
│  Container   │ ← → Database      │  Container   │
└──────────────┘                   └──────┬───────┘
                                          │ ✅ Can talk
┌──────────────┐                          │ by name
│   Postgres   │                   ┌──────▼───────┐
│  Container   │                   │   Postgres   │
└──────────────┘                   │  (my-postgres)│
                                   └──────────────┘
```

**Create and use a Docker network:**

```bash
# 1. Create a network
docker network create myapp-network

# 2. Run Postgres on that network
docker run --name my-postgres \
  --network myapp-network \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=appdb \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  -d postgres:16

# 3. Run backend on the SAME network
docker run -p 8080:8080 \
  --network myapp-network \
  -e DATABASE_URL="postgres://postgres:secret@my-postgres:5432/appdb?sslmode=disable" \
  backend-simple
```

**Notice:** In the DATABASE_URL, we use `@my-postgres:5432` (the container name) instead of `@host.docker.internal:5432`!

**Why this works:**

- Both containers are on `myapp-network`
- Docker's built-in DNS resolves `my-postgres` to the Postgres container's IP
- No need for special host addressing
- More portable across different operating systems

**Key concepts:**

- **Bridge network** - Default Docker network type (isolated from host)
- **Container name as hostname** - Containers can reach each other by name on the same network
- **DNS resolution** - Docker automatically handles name-to-IP mapping
- **Network isolation** - Containers on different networks can't talk to each other (security)

**Useful commands:**

```bash
docker network ls                    # List all networks
docker network inspect myapp-network # See which containers are on a network
docker network rm myapp-network      # Delete a network (no containers using it)
```

**Important Note:** In **Docker3 (Docker Compose)**, networks are created automatically! This manual network setup is just for learning the basics.

---

4. **Inspect basic networking:**

   ```bash
   docker ps
   docker inspect backend1
   ```

   - `docker ps` → see running containers and exposed ports
   - `docker inspect backend1` → view container details and IP mapping

5. **Stop and remove the container:**
   ```bash
   docker stop <container_id>
   docker rm <container_id>
   ```
   - Confirms you can control container lifecycle commands

## 📖 Concepts Introduced

### **Image vs Container**

- **Image** = Blueprint/template (like a class in programming)
- **Container** = Running instance of an image (like an object)
- You can create many containers from one image

### **Dockerfile Instructions**

| Instruction  | When It Runs     | Purpose                                    | Example                 |
| ------------ | ---------------- | ------------------------------------------ | ----------------------- |
| `FROM`       | Build time       | Set base image                             | `FROM golang:1.22`      |
| `WORKDIR`    | Build time       | Set working directory                      | `WORKDIR /app`          |
| `COPY`       | Build time       | Copy files into image                      | `COPY . .`              |
| `ADD`        | Build time       | Like COPY but can extract archives         | `ADD app.tar.gz /app`   |
| `RUN`        | Build time       | Execute commands (install, compile)        | `RUN go build -o main`  |
| `EXPOSE`     | Documentation    | Declare which port app uses                | `EXPOSE 8080`           |
| `ENV`        | Build & run time | Set environment variables                  | `ENV PORT=8080`         |
| `CMD`        | Run time         | Default command when container starts      | `CMD ["./main"]`        |
| `ENTRYPOINT` | Run time         | Fixed command (can't be overridden easily) | `ENTRYPOINT ["./main"]` |

### **Important Dockerfile Concepts**

**Layers and Caching:**

- Each instruction (`FROM`, `RUN`, `COPY`, etc.) creates a new layer
- Docker caches layers to speed up builds
- If a layer hasn't changed, Docker reuses it
- **Best practice:** Put things that change less often at the top

**Example - Optimized for Caching:**

```dockerfile
FROM golang:1.22
WORKDIR /app
COPY go.mod go.sum ./    # Dependencies change rarely
RUN go mod download      # Cache this expensive step
COPY . .                 # Source code changes often
RUN go build -o main
CMD ["./main"]
```

**Port Mapping:**

- `EXPOSE 8080` in Dockerfile = documentation only
- `-p 8080:8080` in docker run = actually opens the port
- Format: `-p <host-port>:<container-port>`

**Container Lifecycle:**

1. **Build** → Create an image from Dockerfile
2. **Run** → Create and start a container from the image
3. **Stop** → Gracefully stop the container
4. **Remove** → Delete the stopped container

## 🔍 Reflection

✅ **Solved:** The backend can now run on any machine using Docker, no Go installation needed.  
✅ **You learned** how containers have isolated filesystems and why `.env` files don't automatically work.  
✅ **You understand** the difference between local dev (`.env` files) and containerized apps (environment variables).  
✅ **You learned** how Docker networks enable container-to-container communication by name.

❌ **Limitation:** Only the backend is containerized — the frontend and DB still run manually.  
❌ **Limitation:** Long `docker run` commands with many `-e` flags can get messy (we'll address this later).  
❌ **Limitation:** Manual network creation is tedious for multiple services (Docker Compose will solve this).

💡 **Key Takeaway:** Configuration should come from environment variables in containers, not baked-in files. This keeps your images portable and secure.

🔜 **Next (Docker2):** Package the frontend as a static site and serve it via Nginx.
