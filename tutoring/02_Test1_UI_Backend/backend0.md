# 🧩 Backend 0 — Minimal Go HTTP Server

## 🚀 Navigation

- **[← Test 1 Overview](./_overview.md)** — Back to Test 1 introduction
- **[→ Backend 1 Tutorial](./backend1.md)** — Next: Counter API implementation

## 🎯 Learning Goal

- Understand how to create and run a basic Go web server.
- Learn what an HTTP endpoint is and how to expose one.
- Gain confidence that your backend environment (Go installation, editor setup) works properly.
- Get familiar with Go syntax and the `net/http` package.

## ⚠️ Problem / Issue

- You need to create your first backend server to understand how web servers work.
- This is a **minimal introduction** to Go and servers — just a "Hello, world!" example.
- No complex logic yet, just proving you can run a server locally.

## 🛠️ What to Build

Create a Go program (`main.go`) that:

- Listens on port **8080**.
- Responds to `GET /` with `"Hello, world!"`.
- Runs successfully via `go run main.go`.

✅ **Done When:** Opening [http://localhost:8080/](http://localhost:8080/) shows `"Hello, world!"`.

## 📚 Key Concepts

- **HTTP Server** — Listens for requests on a port (8080 by default).
- **Endpoints (routes)** — URLs that map to code functions (in this case, `/`).
- **Ports** — Unique channels for network communication.
- **Go Standard Library** — The built-in `net/http` package lets you run a server without dependencies.
- **Handler Functions** — Functions that process HTTP requests and write responses.

## 🔍 Reflection

✅ You can now start and test a local backend.  
✅ You understand how routes map to handler functions.  
✅ You've written your first Go web server!  
❌ The backend has no data or logic yet — just a simple greeting.  
🔜 Next: add logic in **Backend 1** to handle real application state (the counter).

## 🔗 Resources

- [Go installation guide](https://go.dev/doc/install)
- [Go basics tutorial](https://go.dev/doc/tutorial/getting-started)
- [Go `net/http` package](https://pkg.go.dev/net/http)
- [MDN: Understanding ports](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/What_is_a_URL#port_numbers)
- [12-Factor App: Port Binding](https://12factor.net/processes)
