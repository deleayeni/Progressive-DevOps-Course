# 🐳 Docker 2 — Customize Image (Nginx Frontend)

## 🎯 Learning Goal

- Learn how to customize an existing Docker image
- Use Nginx to serve your static Flutter website (from Frontend2)
- Understand how to extend a base image with your own content using `COPY`
- Prepare the frontend container so it can be deployed alongside the backend and database

## ⚠️ Problem / Issue

- You have a `build/web` directory from Frontend2, but it's just files on your machine
- We need a way to serve these static files as a live website from a container
- Instead of building a web server from scratch, we'll reuse an existing image — Nginx — and customize it with our static files

## 🔗 Continuation from Frontend2

In **Frontend2**, you created deployment artifacts:

- Ran `flutter build web`
- Generated production-ready static files in `build/web/`
- These files are portable and can run anywhere

Now in **Docker2**, you'll take those artifacts and:

- Package them into a container image
- Use Nginx as the web server
- Create a deployable container that serves your frontend

**Think of it as:** Frontend2 prepared the ingredients, Docker2 puts them in a serving dish.

## 💡 Key Concept: Base Images and Customization

### What is a Base Image?

A **base image** is a pre-built Docker image you can extend. Think of it like:

- Starting with a furnished apartment (base image)
- Adding your personal belongings (your files)
- Result: A customized space ready to use

### Why Nginx?

**Nginx** is a lightweight, high-performance web server:

- ✅ Battle-tested: Powers millions of websites
- ✅ Tiny: Alpine version is only ~5 MB
- ✅ Fast: Optimized for serving static files
- ✅ Simple: Just point it at a folder of files
- ✅ Production-ready: Used by Netflix, Airbnb, etc.

**Nginx Alpine** = Nginx + Alpine Linux (minimal distribution)

- Regular Ubuntu image: ~100+ MB
- Alpine Linux: ~5 MB
- Perfect for containers (small, fast, secure)

### The Two-Line Magic

Instead of:

- Installing a full OS
- Installing Nginx
- Configuring everything
- Copying your files

You just:

```dockerfile
FROM nginx:alpine                           # Start with Nginx
COPY build/web /usr/share/nginx/html        # Add your files
```

**That's it!** The base image handles everything else.

## 🧱 How Image Customization Works

### Concept: Docker Layers

Every Dockerfile instruction creates a **layer**:

```dockerfile
FROM nginx:alpine          ← Layer 1: Base image (Nginx + Alpine)
COPY build/web /...        ← Layer 2: Your static files
```

**Result**: A new image = base image + your customization

### What You're Inheriting

The `nginx:alpine` base image already has:

- ✅ Nginx installed and configured
- ✅ Default config in `/etc/nginx/nginx.conf`
- ✅ Document root at `/usr/share/nginx/html`
- ✅ Port 80 exposed (`EXPOSE 80`)
- ✅ Startup command (`CMD ["nginx", "-g", "daemon off;"]`)

You just **add your files** to the document root, and Nginx automatically serves them!

## 🛠 Guided Steps with Resources

1. **Ensure Frontend2 output exists:**

   ```bash
   flutter build web
   ```

   - Run the Flutter build again if needed
   - Confirm that you have a folder `build/web` containing `index.html`, `main.dart.js`, etc.

2. **Create a Dockerfile in your frontend folder:**

   ```dockerfile
   FROM nginx:alpine
   COPY build/web /usr/share/nginx/html
   ```

   - `FROM nginx:alpine` → start from a lightweight Nginx image
   - `COPY build/web /usr/share/nginx/html` → replace Nginx's default page with your Flutter build output

3. **Build the customized image:**

   ```bash
   docker build -t frontend-app .
   ```

   - `-t frontend-app` names your image "frontend-app"
   - `.` tells Docker to use the current directory as build context
   - Creates an image containing Nginx + your static files

4. **Run the container:**

   ```bash
   docker run -d -p 80:80 --name my-frontend frontend-app
   ```

   - `-d` runs in detached mode (background)
   - `-p 80:80` maps container port 80 to your local port 80
   - `--name my-frontend` gives the container a friendly name
   - `frontend-app` is the image to run

5. **Test it locally:**

   - Open your browser and go to `http://localhost`
   - You should see your Flutter web app being served from Nginx
   - **Magic moment**: Your app runs in a container, no Flutter SDK needed!

6. **Inspect the running container (optional):**

   ```bash
   docker ps
   docker exec -it my-frontend sh
   ```

   - `docker ps` → list running containers
   - `docker exec -it my-frontend sh` → open a shell inside and explore `/usr/share/nginx/html`
   - You'll see your `index.html`, `main.dart.js`, etc.

7. **Stop and clean up:**
   ```bash
   docker stop my-frontend
   docker rm my-frontend
   ```

## 📖 Concepts Introduced

- **Base images** — Pre-built Docker images that you can extend (like `nginx:alpine`)
- **Image customization** — Modifying an existing image by copying your own files or configuration
- **Static file serving** — Nginx automatically serves any files placed in its `/usr/share/nginx/html` directory
- **Layering** — Each Dockerfile instruction creates a new layer; you're adding a layer with your web files
- **Container efficiency** — Using Alpine Linux keeps images tiny (5 MB vs 100+ MB)
- **Image inheritance** — You inherit all configuration from the base image (EXPOSE, CMD, etc.)
- **Build context** — The directory containing your Dockerfile and files to copy

## 🔍 Why This Approach is Powerful

### Separation of Concerns

```
Frontend2: Build artifacts (requires Flutter SDK)
    ↓
Docker2: Package artifacts (no Flutter SDK needed!)
    ↓
Runtime: Serve files (only Nginx needed)
```

**Build-time dependencies ≠ Runtime dependencies**

This is a fundamental DevOps principle:

- Heavy tools (Flutter SDK) only needed during build
- Production containers stay lean and fast
- Same artifacts can be deployed many ways

### Reusability

The same `build/web/` folder could be:

- Served by Nginx (what you're doing)
- Uploaded to AWS S3
- Deployed to CDN (Cloudflare, Netlify)
- Served by Apache
- Hosted on GitHub Pages

**The artifact is decoupled from the deployment method!**

### Efficiency Comparison

**If you containerized development mode:**

```dockerfile
FROM ubuntu
RUN apt-get install flutter  # ~1+ GB!
COPY source code
CMD flutter run               # Not production-ready
```

Result: 1+ GB container, slow, insecure

**What you're actually doing:**

```dockerfile
FROM nginx:alpine             # ~5 MB
COPY build/web /...           # ~10 MB
```

Result: ~15 MB container, fast, secure

**200x smaller!** This is why build/runtime separation matters.

## 🔍 Reflection

- ✅ **Solved:** The frontend is now containerized and served via Nginx
- ✅ **Reused base image:** Instead of building a web server yourself
- ✅ **Efficiency:** Tiny container size (~15 MB total)
- ✅ **Production-ready:** Industry-standard web server
- ✅ **Portable:** Can run on any machine with Docker
- ❌ **Limitation:** Backend and database still run in separate containers manually — not yet unified
- 🔜 **Next (Docker3):** Use Docker Compose to run all services (frontend, backend, DB) together with one command
