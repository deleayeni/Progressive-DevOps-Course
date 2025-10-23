# ⚙️ Backend 2 — Go Server with Postgres Persistence

## 🚀 Navigation

- **[← Database 0 Tutorial](./database0.md)** — Previous: Postgres setup
- **[← Test 2 Overview](./_overview.md)** — Back to Test 2 introduction
- **[→ Test 3 Overview](../04_Test3_ContainerizeApplication/_overview.md)** — Next: Containerize application

## 🎯 Learning Goal

- Connect a Go backend to Postgres using a database driver.
- Replace in-memory logic with SQL queries for reading/writing the counter.
- Ensure the counter value survives backend restarts.

## ⚠️ Problem / Issue

In **Backend 1**, state was stored in memory and reset when the server stopped.  
We now need durable persistence using Postgres.

## 🧠 What You'll Do

1. **Initialize the Go module:**

   ```bash
   go mod init backend2
   go get github.com/jackc/pgx/v5
   go get github.com/joho/godotenv
   ```

2. **Create a .env file:**

   ```env
   DATABASE_URL=postgres://postgres:secret@localhost:5432/appdb?sslmode=disable
   PORT=8080
   ```

3. **Update your Go server to:**
   - Connect to Postgres on startup
   - Query the counters table for the current value
   - Increment and return the counter via SQL `UPDATE ... RETURNING`

## ✅ Done When

- `/counter` and `/counter/increment` operate via database reads/writes
- Restarting the backend keeps the previous value

## 📖 Concepts Introduced

- **Database Drivers** — Go uses pgx to communicate with Postgres
- **Connection Strings** — identify the host, port, user, and DB name
- **Initialization Logic** — ensures a valid row exists before use
- **Persistence** — data survives process restarts
- **SQL RETURNING** — fetches updated rows without extra queries

## 🔍 Reflection

- ✅ Counter now survives backend restarts
- ✅ Backend and database communicate correctly
- ❌ Still running locally and manually — not yet containerized
- 🔜 **Next:** Test 3 will containerize the backend for easier deployment
