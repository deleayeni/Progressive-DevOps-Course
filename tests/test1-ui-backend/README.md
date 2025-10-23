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

1. **Backend:**

   - Start with a minimal Go server (backend0) that responds with `"ok"` on `/healthz`.
   - Expand it into an API (backend1) that holds a counter in memory.
   - Expose two endpoints:
     - `GET /counter` → returns the current counter value.
     - `POST /counter/increment` → increases the counter and returns the new value.

2. **Frontend:**
   - Modify the Flutter app so it fetches and updates the counter value from the backend.
   - The app should display the counter retrieved from the server and update it via HTTP requests.

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

## 🚀 Next Step

Move on to **Test 2 — Add Database** to persist the counter so it survives backend restarts.
