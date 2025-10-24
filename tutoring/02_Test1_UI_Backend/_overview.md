# 🧩 Test 1 — UI + Backend

## 🚀 Ready to Start?

**[Go to Test 1 Implementation](../../tests/test1-ui-backend/README.md)**

## 🧠 Overview

In **Test 0**, our Flutter app stored all state in memory.  
Each restart wiped out the counter value — an example of **ephemeral state**.

**Test 1** introduces the concept of a **client–server architecture**:

- The **frontend** focuses on UI and interaction.
- The **backend** becomes the system of record, managing data and logic.

This separation is the foundation of scalable, maintainable software — and an essential first step toward DevOps thinking.

## 🎯 Learning Goals

- Understand how a frontend and backend communicate through HTTP.
- Build a simple Go server that can respond to HTTP requests.
- Use Flutter to send and receive JSON data through HTTP calls.
- Observe the trade-off: UI restarts no longer lose data, but backend restarts still do.

## ⚙️ Structure

| Module        | Description                                                               | Outcome                                                |
| ------------- | ------------------------------------------------------------------------- | ------------------------------------------------------ |
| **backend0**  | Minimal Go HTTP server exposing `/` with "Hello, world!".                 | Confirms environment setup and port binding.           |
| **backend1**  | In-memory counter API using `GET /counter` and `POST /counter/increment`. | Introduces server-managed state and JSON APIs.         |
| **frontend1** | Flutter app calls the backend for counter data.                           | Connects client and server into one functional system. |

## 🔍 Concepts Introduced

- Client–Server separation
- HTTP endpoints & ports
- State scope and persistence
- JSON serialization
- Basic HTTP server concepts

## 📚 Detailed Modules

- **[Backend 0 Tutorial](./backend0.md)** — Minimal Go HTTP server
- **[Backend 1 Tutorial](./backend1.md)** — Counter API implementation
- **[Frontend 1 Tutorial](./frontend1.md)** — Flutter HTTP integration

## 🔜 Next Step

In **Test 2**, we'll introduce **Postgres** to persist state across backend restarts.
