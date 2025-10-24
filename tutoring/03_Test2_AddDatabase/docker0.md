# 🐳 Docker0 — Install Docker

## 🚀 Navigation

- **[← Test 2 Overview](./_overview.md)** — Back to Test 2 introduction
- **[→ Database0 Tutorial](./database0.md)** — Next: Postgres setup

## 🎯 Learning Goal

- Install Docker Desktop on your machine.
- Understand what Docker is and why it's useful.
- Verify Docker is running and ready to use.
- Learn basic Docker commands to check status.

## ⚠️ Problem / Issue

- Running Postgres locally requires installation, configuration, and management.
- Different operating systems have different installation processes.
- Managing database versions and dependencies can be complex.
- Docker solves this by packaging Postgres in a container that runs consistently everywhere.

## 📚 What is Docker?

**Docker** is a platform that lets you run applications inside **containers** — isolated environments that include everything needed to run the app (code, dependencies, runtime, etc.).

Think of containers like lightweight virtual machines, but:

- They start in seconds (not minutes).
- They use fewer resources.
- They're portable across different machines and operating systems.

### Why Docker for Databases?

- **No manual installation** — Just pull an image and run it.
- **Consistent environment** — Same Postgres version on everyone's machine.
- **Easy cleanup** — Delete the container when done, no leftover files.
- **Isolation** — Database runs separately from your host system.

## 🛠 Installation Steps

### Windows

1. **Download Docker Desktop:**

   - Visit [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Download the Windows installer

2. **Install Docker Desktop:**

   - Run the installer
   - Follow the installation wizard
   - Accept the default settings (WSL 2 backend recommended)

3. **Start Docker Desktop:**

   - Launch Docker Desktop from the Start menu
   - Wait for Docker to start (you'll see a green icon in the system tray)

4. **Enable WSL 2 (if prompted):**
   - Docker will guide you through enabling WSL 2 if needed
   - This may require a system restart

### macOS

1. **Download Docker Desktop:**

   - Visit [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Choose the correct version:
     - **Apple Silicon (M1/M2/M3)** — Download the ARM64 version
     - **Intel chip** — Download the AMD64 version

2. **Install Docker Desktop:**

   - Open the downloaded `.dmg` file
   - Drag Docker to your Applications folder
   - Launch Docker from Applications

3. **Grant permissions:**
   - Docker will ask for system permissions
   - Enter your password to allow installation

### Linux

1. **Install using the convenience script:**

   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

2. **Add your user to the docker group:**

   ```bash
   sudo usermod -aG docker $USER
   ```

3. **Log out and log back in** for the group change to take effect

4. **Start Docker service:**

   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

For detailed Linux instructions by distribution, see: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

## ✅ Verify Installation

After installation, verify Docker is working:

1. **Check Docker version:**

   ```bash
   docker --version
   ```

   Expected output:

   ```
   Docker version 24.0.7, build afdd53b
   ```

2. **Check Docker is running:**

   ```bash
   docker ps
   ```

   Expected output (empty list is fine):

   ```
   CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
   ```

3. **Run a test container:**

   ```bash
   docker run hello-world
   ```

   Expected output:

   ```
   Hello from Docker!
   This message shows that your installation appears to be working correctly.
   ```

## 📖 Basic Docker Commands

You don't need to master these now, but here are essential commands you'll use:

| Command                   | Purpose                                 |
| ------------------------- | --------------------------------------- |
| `docker ps`               | List running containers                 |
| `docker ps -a`            | List all containers (including stopped) |
| `docker images`           | List downloaded images                  |
| `docker pull <image>`     | Download an image                       |
| `docker run <image>`      | Create and start a container            |
| `docker stop <container>` | Stop a running container                |
| `docker rm <container>`   | Remove a stopped container              |

## 📚 Key Concepts

- **Image** — A template/blueprint for a container (like a class in OOP).
- **Container** — A running instance of an image (like an object).
- **Docker Hub** — A registry where images are stored (like npm or PyPI).
- **Docker Desktop** — The GUI application that manages Docker on Windows/Mac.
- **Docker Engine** — The underlying service that runs containers.

### Image vs Container Analogy

Think of it like baking:

- **Image** = Recipe (instructions to make a cake)
- **Container** = Actual cake (the running instance)

You can use one recipe (image) to bake many cakes (containers).

## 🔍 Troubleshooting

### Docker Desktop won't start (Windows)

- Enable Virtualization in BIOS
- Enable WSL 2: `wsl --install`
- Restart your computer

### "Permission denied" error (Linux)

- Make sure you added your user to the docker group
- Log out and log back in
- Try: `sudo docker ps` (if this works, the group issue remains)

### Docker is slow (Windows/Mac)

- Allocate more resources in Docker Desktop settings
- Go to Settings → Resources → Adjust CPU and Memory

## 📦 Understanding Docker Volumes (Important!)

Before moving to Database0, you need to understand one more critical Docker concept: **volumes**.

**The Problem:**

- Container filesystems are **temporary**
- When you delete a container, all its data disappears
- This is fine for applications, but **terrible** for databases!

**The Solution: Docker Volumes**

- **Volumes** are named storage that lives **outside** containers
- They persist even when containers are deleted
- You create them with the `-v` flag: `-v volume-name:/path/in/container`

**Example:**

```bash
docker run -v my-data:/app/data my-image
```

- `my-data` = volume name (Docker manages this on your host)
- `/app/data` = where the data appears inside the container

**Visual:**

```
Your Computer
├── Docker Volumes/
│   └── my-data/          ← Persistent storage (survives container deletion)
│
Container (temporary)
└── /app/data/            ← Mounted from my-data volume
```

**When container is deleted:**

- ❌ Container and its filesystem → GONE
- ✅ Volume data → REMAINS

**Why this matters:**
In **Database0**, you'll use volumes to store Postgres data so your database survives container restarts and deletions.

**Key commands:**

```bash
docker volume ls              # List all volumes
docker volume inspect pgdata  # See details about a volume
docker volume rm pgdata       # Delete a volume (careful!)
```

## 🔍 Reflection

✅ Docker is installed and running.  
✅ You understand what containers are and why they're useful.  
✅ You've verified Docker works with the hello-world test.  
✅ You understand volumes and why they're essential for databases.  
🔜 Next: **Database 0** — Run Postgres in a Docker container with persistent storage.

## 🔗 Resources

- [Docker Desktop Download](https://www.docker.com/products/docker-desktop)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Getting Started Tutorial](https://docs.docker.com/get-started/)
- [What is a Container?](https://www.docker.com/resources/what-container/)
- [Docker Hub](https://hub.docker.com/) — Browse available images
