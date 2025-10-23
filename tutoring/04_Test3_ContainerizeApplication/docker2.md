# 🐳 Docker 2 — Customize Image

## 🎯 Learning Goal

- Learn how to customize an existing Docker image
- Use Nginx to serve your static Flutter website (from Frontend2)
- Understand how to extend a base image with your own content using `COPY`
- Prepare the frontend container so it can be deployed alongside the backend and database

## ⚠️ Problem / Issue

- You have a `build/web` directory from Frontend2, but it's just files on your machine
- We need a way to serve these static files as a live website from a container
- Instead of building a web server from scratch, we'll reuse an existing image — Nginx — and customize it with our static files

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
   docker build -t frontend2 .
   ```

   - Creates an image called `frontend2` based on Nginx, now containing your app files

4. **Run the container:**

   ```bash
   docker run -d -p 80:80 frontend2
   ```

   - `-p 80:80` maps container port 80 to your local port 80
   - `-d` runs the container in the background

5. **Test it locally:**

   - Open your browser and go to `http://localhost`
   - You should see your Flutter web app being served from Nginx

6. **Inspect the running container (optional):**
   ```bash
   docker ps
   docker exec -it <container_id> sh
   ```
   - `docker ps` → list containers
   - `docker exec -it <container_id> sh` → open a shell inside and explore `/usr/share/nginx/html`

## 📖 Concepts Introduced

- **Base images** — Pre-built Docker images that you can extend (like `nginx:alpine`)
- **Image customization** — Modifying an existing image by copying your own files or configuration
- **Static file serving** — Nginx automatically serves any files placed in its `/usr/share/nginx/html` directory
- **Layering** — Each Dockerfile instruction creates a new layer — you're adding a layer with your web files

## 🔍 Reflection

- ✅ **Solved:** The frontend is now containerized and served via Nginx
- ✅ **Reused base image:** Instead of building a web server yourself
- ❌ **Limitation:** Backend and database still run in separate containers manually — not yet unified
- 🔜 **Next (Docker3):** Use Docker Compose to run all services (frontend, backend, DB) together
