# 🧩 Backend 0 — Minimal Go HTTP Server

## 🚀 Navigation

- **[← Test 1 Overview](./_overview.md)** — Back to Test 1 introduction
- **[→ Backend 1 Tutorial](./backend1.md)** — Next: Counter API implementation

## 🎯 Learning Goal

- Understand how to create and run a basic Go web server.
- Learn what an HTTP endpoint is and how to expose one.
- Gain confidence that your backend environment (Go installation, editor setup) works properly.

## ⚠️ Problem / Issue

- The server runs but doesn’t yet provide meaningful data.
- It only responds to one endpoint (`/healthz`) returning `"ok"`.
- This is an **infrastructure sanity check** — confirming you can run a service locally.

## 🛠️ What to Build

Create a Go program (`main.go`) that:

- Listens on port **8080**.
- Responds to `GET /healthz` with `"ok"`.
- Runs successfully via `go run main.go`.

✅ **Done When:** Opening [http://localhost:8080/healthz](http://localhost:8080/healthz) shows `"ok"`.

## 📚 Key Concepts

- **HTTP Server** — Listens for requests on a port (8080 by default).
- **Endpoints (routes)** — URLs that map to code functions.
- **Ports** — Unique channels for network communication.
- **Health Checks** — `/healthz` verifies service availability.
- **Go Standard Library** — The built-in `net/http` package lets you run a server without dependencies.

## 🔍 Reflection

✅ You can now start and test a local backend.  
✅ You understand how routes map to handler functions.  
❌ The backend has no data or logic yet — only a health signal.  
🔜 Next: add logic in **Backend 1** to handle real application state.

## 🔗 Resources

- [Go installation guide](https://go.dev/doc/install)
- [Go basics tutorial](https://go.dev/doc/tutorial/getting-started)
- [Go `net/http` package](https://pkg.go.dev/net/http)
- [MDN: Understanding ports](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/What_is_a_URL#port_numbers)
- [12-Factor App: Port Binding](https://12factor.net/processes)
