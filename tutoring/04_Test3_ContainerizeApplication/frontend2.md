# 🌐 Frontend 2 — Build Static Webpage

## 🎯 Learning Goal

- Generate a production-ready version of the Flutter frontend as a static website
- Understand how `flutter build web` compiles the app into plain HTML, CSS, and JavaScript files
- Prepare the frontend so Docker can later serve it through an Nginx container

## ⚠️ Problem / Issue

- So far, the Flutter UI runs only in development mode using `flutter run`
- That setup depends on the Flutter SDK and is not suitable for deployment
- Docker cannot serve Flutter source code — it can only serve static files
- We need to convert the Flutter app into a set of web files that any web server (like Nginx) can host

## 🛠 Guided Steps with Resources

1. **Open the frontend project:**

   ```bash
   cd frontend1
   ```

   - Navigate to your frontend folder

2. **Run the Flutter build command:**

   ```bash
   flutter build web
   ```

   - Flutter compiles your Dart code into JavaScript and HTML
   - Output is created under the `build/web/` directory

3. **Inspect the generated files:**

   - Inside `build/web/`, you'll find:
     - `index.html`
     - `main.dart.js`
     - `flutter.js`
     - `favicon.png`
     - `assets/`
   - These are standard web files — no Dart or Flutter engine required

4. **Preview your static site locally (optional):**

   ```bash
   cd build/web
   python3 -m http.server 8080
   ```

   - Then open `http://localhost:8080`
   - You'll see your Flutter app running — now as a pure static website

5. **Prepare for Docker:**
   - The `build/web/` folder will later be copied into an Nginx Docker image in Docker2:
     ```dockerfile
     FROM nginx:alpine
     COPY build/web /usr/share/nginx/html
     ```
   - This is how the frontend will eventually be containerized and served

## 📖 Concepts Introduced

- **Static website** — A site made of fixed files (HTML, CSS, JS) that don't require a running backend to render UI
- **Build process** — Flutter compiles your Dart code into JavaScript for the browser
- **Deployment artifact** — The `build/web` folder is what gets shipped to production
- **Separation of concerns** — The app logic (backend) and UI (frontend) are now clearly isolated

## 🔍 Reflection

- ✅ **Solved:** You now have a static version of your Flutter app that can be hosted anywhere
- ✅ **Independence:** The UI no longer depends on the Flutter SDK or development server
- ❌ **Limitation:** The static site is not yet served automatically — it still needs a web server container
- 🔜 **Next (Docker2):** Package this static site into a Docker image using Nginx
