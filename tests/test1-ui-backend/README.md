# 🧩 Test 1 — UI + Backend

## 🎯 Objective

Connect the **Flutter frontend** and the **Go backend** so that the counter value now survives UI restarts.  
This test introduces client-server communication — the UI will no longer store state locally, but request and update it through API calls.

## 📦 Modules

- `backend0/` — minimal Go HTTP server returning a simple health check (`/healthz` → "ok").
- `backend1/` — Go API that stores a counter in memory and exposes endpoints:
  - `GET /counter`
  - `POST /counter/increment`
- `frontend1/` — Flutter UI updated to communicate with the backend through HTTP.

## 🧠 What to Do

1. **Backend**: Build a Go HTTP server with health check and counter API endpoints
2. **Frontend**: Modify the Flutter app to communicate with the backend via HTTP
3. **Integration**: Test that the counter persists across frontend restarts

## ✅ What "Done" Looks Like

- ✅ The backend responds with `"ok"` at `/healthz`.
- ✅ The backend exposes `/counter` and `/counter/increment` endpoints that return valid JSON.
- ✅ The frontend displays the counter value retrieved from the backend.
- ✅ Pressing the button increments the backend counter.
- ✅ Restarting the frontend keeps the latest value (fetched from backend).
- ❌ Restarting the backend resets the counter (in-memory only — expected for now).

## 🧪 Verification

- You can access all endpoints locally (`http://localhost:8080`).
- The frontend correctly reflects updates from the backend.
- No local UI-only state is left in the app.

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 1 Overview](../../tutoring/02_Test1_UI_Backend/_overview.md)** — Course introduction and concepts
- **[Backend 0 Tutorial](../../tutoring/02_Test1_UI_Backend/backend0.md)** — Minimal Go server
- **[Backend 1 Tutorial](../../tutoring/02_Test1_UI_Backend/backend1.md)** — Counter API implementation
- **[Frontend 1 Tutorial](../../tutoring/02_Test1_UI_Backend/frontend1.md)** — Flutter HTTP integration

## 🚀 Next Step

Move on to **Test 2 — Add Database** to persist the counter so it survives backend restarts.
