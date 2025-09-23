# Composed Demo 0 — Just UI & Simple Backend

## 🎯 Learning Goal

- Build confidence with the basics:
  - A **Flutter UI** (frontend0).
  - A **minimal Go HTTP server** (backend0).
- Understand the idea of separation between a frontend and backend.

---

## ⚠️ Problem / Issue

- The **frontend counter** works but resets to `0` whenever the app restarts.
- The **backend server** runs but does not provide any meaningful data yet.
- At this stage, **frontend and backend do not talk to each other**.

---

## 🔧 Step-by-Step Instructions

### Frontend0 (Flutter counter app)

1. Create a basic Flutter project.
2. Implement a counter app where a button increments a number on the screen.
3. Run the app to confirm the counter works.
   - Issue: counter resets to `0` whenever you restart the app.

### Backend0 (Go minimal server)

1. Create a new folder `backend0`.
2. Add a simple Go HTTP server with one endpoint (`/healthz`).
3. Run the server with `go run main.go`.
4. Open a browser at `http://localhost:8080/healthz`.
   - You should see `ok`.
   - This proves the backend server is running.

---

## 📖 Concepts Introduced

- **UI (Frontend)**: the part of the app users directly interact with.
- **Backend server**: a program running separately to handle requests.
- **HTTP server basics**: what it means to listen on a port (8080).
- **Endpoint**: a path like `/healthz` that the server responds to.

---

## 🪞 Reflection

- ✅ You now have **two independent parts**: a Flutter frontend and a Go backend.
- ❌ They don’t communicate with each other yet.
- 🔜 Next: connect them (Demo 1) so that Flutter calls the Go API to manage state.

---

## ✅ Outcome

- A working **counter app (frontend0)** that increments locally.
- A working **Go server (backend0)** that responds with a health check.
- Foundation is set for connecting frontend ↔ backend in Demo 1.
