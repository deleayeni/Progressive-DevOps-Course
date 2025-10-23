# 🐳 Docker 1 — Build a Backend Image

## 🎯 Learning Goal

- Learn how to create a simple Dockerfile for the Go backend application
- Understand how to build an image from source code and run it as a container
- Visualize basic networking (how container ports map to the host)

## ⚠️ Problem / Issue

- So far, the backend runs only through `go run main.go`
- Anyone who wants to run it must install Go and dependencies manually
- This breaks portability — we want the same backend to run anywhere with one command

## 🛠 Guided Steps with Resources

1. **Create a Dockerfile in the backend folder:**

   ```dockerfile
   FROM golang:1.22
   WORKDIR /app
   COPY . .
   RUN go build -o main .
   CMD ["./main"]
   ```

   - `FROM golang:1.22` → start from the official Go image
   - `WORKDIR /app` → set working directory inside the container
   - `COPY . .` → copy your Go files into the container
   - `RUN go build -o main .` → compile the code
   - `CMD ["./main"]` → run the executable when the container starts

2. **Build the image:**

   ```bash
   docker build -t backend1 .
   ```

   - Creates a Docker image named `backend1`

3. **Run the container:**

   ```bash
   docker run -p 8080:8080 backend1
   ```

   - `-p 8080:8080` maps the container's port 8080 to your host machine
   - Visit `http://localhost:8080/healthz` → should return "ok"

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

- **Image vs Container** — Blueprint vs running instance
- **Dockerfile syntax** — `FROM`, `COPY`, `RUN`, `CMD`
- **Port mapping** — How host and container communicate
- **Container lifecycle** — build → run → stop → remove

## 🔍 Reflection

- ✅ **Solved:** The backend can now run on any machine using Docker, no Go installation needed
- ❌ **Limitation:** Only the backend is containerized — the frontend and DB still run manually
- 🔜 **Next (Docker2):** Package the frontend as a static site and serve it via Nginx
