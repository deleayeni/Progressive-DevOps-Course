# 🗄️ Database 0 — Postgres Setup

## ⛓️ Prerequisites

Before starting, ensure **Docker** is installed and running (`docker0`).

## 🎯 Learning Goal

- Run Postgres in a Docker container with a persistent volume.
- Create a database (`appdb`) and a `counters` table.
- Verify data persists after container or backend restarts.

## ⚠️ Problem / Issue

In **Backend 1**, the counter existed only in memory — it vanished on restart.  
Real systems require **durable storage** so state survives process restarts.

## 🧠 What You'll Do

1. **Run Postgres 16 inside Docker:**

   ```bash
   docker run --name my-postgres \
   -e POSTGRES_PASSWORD=secret \
   -e POSTGRES_DB=appdb \
   -p 5432:5432 \
   -v pgdata:/var/lib/postgresql/data \
   -d postgres:16
   ```

   This starts Postgres with persistent storage (pgdata volume) and exposes it on port 5432.

2. **Open a Postgres shell inside the container:**

   ```bash
   docker exec -it my-postgres psql -U postgres -d appdb
   ```

3. **Create a counters table and seed it:**

   ```sql
   CREATE TABLE IF NOT EXISTS counters (
     id INT PRIMARY KEY CHECK (id = 1),
     value INT NOT NULL
   );

   INSERT INTO counters (id, value)
   VALUES (1, 0)
   ON CONFLICT (id) DO NOTHING;
   ```

4. **Verify persistence** by running `SELECT * FROM counters;` — stop/start the container and re-check.

## 📖 Concepts Introduced

- **Databases vs. Memory** — databases persist data to disk
- **Schema Design** — defines tables, columns, types, and keys
- **Docker Volumes** — preserve data even when containers stop
- **Container Exec** — execute commands inside running containers
- **Connection String** — tells the backend where and how to connect:
  ```
  postgres://postgres:secret@localhost:5432/appdb?sslmode=disable
  ```

## 🔍 Reflection

- ✅ Postgres runs inside Docker
- ✅ Database and table persist across restarts
- ❌ Backend is not yet connected — data exists but isn't used
- 🔜 **Next:** Backend 2 will connect and use this database for persistence
