# 🗄️ Test 2 — Add Database

## 🎯 Objective

Add **Postgres database persistence** to the counter application so that data survives backend restarts.  
This test introduces database connectivity and moves from in-memory storage to durable disk-based storage.

## 📦 Modules

- `database0/` — Postgres setup running in Docker, schema creation
- `backend2/` — Go backend connects to Postgres to store/retrieve counter
- `frontend1/` — Unchanged Flutter UI calling backend APIs

## 🧠 What to Do

1. **Database**: Set up Postgres in Docker and create the `counters` table
2. **Backend**: Connect the Go server to Postgres instead of using in-memory storage
3. **Frontend**: No changes needed — still calls the same API endpoints

## ✅ What "Done" Looks Like

- ✅ Postgres database runs in Docker with persistent volume
- ✅ Backend connects to database and reads/writes counter values
- ✅ Counter survives both UI and backend restarts
- ✅ Frontend works unchanged (same API endpoints)

## 🧪 Verification

- Database container is running: `docker ps`
- Backend responds to health check: `curl http://localhost:8080/healthz`
- Counter API works: `curl http://localhost:8080/counter`
- **Persistence test**: Restart backend, counter value should remain

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 2 Overview](../../tutoring/03_Test2_AddDatabase/_overview.md)** — Course introduction and concepts
- **[Database 0 Tutorial](../../tutoring/03_Test2_AddDatabase/database0.md)** — Postgres setup
- **[Backend 2 Tutorial](../../tutoring/03_Test2_AddDatabase/backend2.md)** — Backend database integration

## 🚀 Next Step

Once the database-backed counter works correctly, proceed to **Test 3 — Containerize Application** to package everything into Docker containers for consistent deployment.
