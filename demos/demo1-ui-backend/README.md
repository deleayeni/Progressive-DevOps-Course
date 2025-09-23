# Composed Demo 1 — UI + Backend

## 🎯 Learning Goal

- Introduce client–server separation.
- Learn how a frontend communicates with a backend API.
- Persist state across UI restarts by moving it into the backend.

---

## ⚠️ Problem / Issue

- In Demo 0, the counter lived only in the frontend. Restarting the app reset it to `0`.
- We need a backend that holds the counter so the state survives UI restarts.
- Limitation: if the backend restarts, the counter resets (no persistence yet).

---

## 🔧 Step-by-Step Instructions

### Backend1 (Go server)

1. Create a folder called `backend1`.
2. Add a Go program (`main.go`) that starts a simple HTTP server.
3. The server should expose two routes:
   - `GET /counter` → returns the current counter value.
   - `POST /counter` → increments the counter and returns the new value.
4. Run the server and test it by opening the endpoint in a browser or using curl/PowerShell.

### Frontend1 (Flutter client)

1. Create a folder called `frontend1` or reuse your existing Flutter app.
2. Add an HTTP client dependency (the standard `http` package).
3. Create a service file (`api_client.dart`) that calls the backend endpoints.
   - On app start, request the counter value with `GET /counter`.
   - On button press, call `POST /counter` to increment.
4. Update the UI to display the counter value from the backend instead of local state.

---

## 📖 Concepts Introduced

- **Client–server separation**: frontend (UI) and backend (logic + state) are independent.
- **HTTP endpoints**: a way to expose functionality from the backend.
- **GET vs POST**: different HTTP methods for retrieving data vs making changes.
- **JSON messages**: backend and frontend communicate with a common format.
- **Persistence scope**: state now survives **UI restarts**, but not backend restarts.

---

## 🪞 Reflection

- ✅ You now have two independent parts working together: Flutter UI + Go backend.
- ✅ The counter survives UI restarts.
- ❌ If the backend restarts, the counter still resets (not persistent yet).
- 🔜 Next: connect a database (Demo 2) so state survives backend restarts.

---

## ✅ Outcome

- The frontend successfully calls the backend API.
- Counter increments and persists across UI restarts.
- This is the first step into **real client–server architecture**.
