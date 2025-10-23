# 🧩 Backend 1 — In-Memory Counter API

## 🚀 Navigation

- **[← Backend 0 Tutorial](./backend0.md)** — Previous: Minimal Go server
- **[→ Frontend 1 Tutorial](./frontend1.md)** — Next: Flutter HTTP integration
- **[← Test 1 Overview](./_overview.md)** — Back to Test 1 introduction

## 🎯 Learning Goal

- Build a Go backend that stores application state (counter) in memory.
- Provide an API with two endpoints:
  - `GET /counter` → returns the current value.
  - `POST /counter/increment` → increases the counter and returns the new value.
- Enable the frontend to persist state across UI restarts.

---

## ⚠️ Problem / Issue

- **Backend0** only returned `"ok"`; no data stored.
- **Frontend0** stored all data locally; it reset on restart.
- **Backend1** introduces shared state managed by the server — but still resets if the backend restarts.

---

## 🛠️ What to Build

- Extend your previous server to maintain an integer counter in memory.
- Serve data as JSON.
- Increment and return the counter via HTTP requests.

✅ **Done When:**

- `GET /counter` returns a JSON number.
- `POST /counter/increment` increases and returns it.
- The counter remains stable across multiple UI reloads.

---

## 📖 Concepts Introduced

- **In-Memory State** — Stored in RAM, erased when process stops.
- **JSON APIs** — Data serialization for communication with the frontend.
- **HTTP Methods** —
  - GET = Read-only
  - POST = Data-changing
- **Concurrency Safety** — Protect shared state using `sync.Mutex`.

---

## 🔍 Reflection

✅ UI restarts no longer lose data.  
❌ Backend restarts reset the counter (by design).  
🔜 Next: persist data using **Postgres** in Test 2.

---

## 🔗 Resources

- [Go net/http package](https://pkg.go.dev/net/http)
- [JSON encoding in Go](https://pkg.go.dev/encoding/json)
- [Go sync.Mutex guide](https://pkg.go.dev/sync)
