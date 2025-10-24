# 🗄️ Database 0 — Postgres Setup

## 🚀 Navigation

- **[← Docker0 Tutorial](./docker0.md)** — Previous: Install Docker
- **[← Test 2 Overview](./_overview.md)** — Back to Test 2 introduction
- **[→ Backend2 Tutorial](./backend2.md)** — Next: Backend database integration

## ⛓️ Prerequisites

Before starting, ensure **Docker** is installed and running. If you haven't installed Docker yet, complete **[Docker 0](./docker0.md)** first.

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
- **Container Exec** — execute commands inside running containers (`docker exec`)
- **Connection String** — tells the backend where and how to connect:
  ```
  postgres://postgres:secret@localhost:5432/appdb?sslmode=disable
  ```

### **Docker Volumes - Why Your Data Persists**

Remember volumes from Docker0? Here's where they become critical:

```bash
-v pgdata:/var/lib/postgresql/data
```

**What happens:**

1. Docker creates a volume named `pgdata` on your host machine
2. Postgres writes all database files to `/var/lib/postgresql/data` inside the container
3. That path is **mounted** from the `pgdata` volume
4. When you stop/restart/delete the container → data remains in the volume
5. New containers can mount the same volume and see the old data

**Test it yourself:**

```bash
# Stop and remove the container
docker stop my-postgres
docker rm my-postgres

# Start a NEW container with the SAME volume
docker run --name my-postgres \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=appdb \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  -d postgres:16

# Your data is still there!
docker exec -it my-postgres psql -U postgres -d appdb -c "SELECT * FROM counters;"
```

### **⚠️ Important Caveat: This is Still LOCAL Storage**

**Limitation to understand:**

- The volume exists **only on your machine**
- If your computer crashes or the disk fails → data is lost
- This is **not truly persistent** for production use

**What "truly persistent" means:**

- Cloud storage (AWS RDS, Azure Database, Google Cloud SQL)
- Replicated databases across multiple servers
- Automated backups to separate locations
- Geographic redundancy

**For now:**
Docker volumes are perfect for **local development** and learning. Real production systems need more robust solutions (which you'll explore in later tests).

## 🔍 Reflection

- ✅ Postgres runs inside Docker
- ✅ Database and table persist across restarts thanks to volumes
- ✅ You understand why volumes are essential for database persistence
- ⚠️ Remember: This is local storage only, not production-grade persistence
- ❌ Backend is not yet connected — data exists but isn't used
- 🔜 **Next:** Backend 2 will connect and use this database for persistence
