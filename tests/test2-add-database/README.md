# Composed Demo 2 — Add Database

## 🎯 Learning Goal

- Persist state so backend restarts don’t lose data.
- Understand database connections, schemas, and migrations.
- Learn how to read and write from a Postgres database in the backend.

---

## ⚠️ Problem / Issue

- In Demo 1, the counter survived UI restarts but **reset if the backend restarted**.
- The backend stored the counter **in memory only**.
- We need to persist the state in a **Postgres database**, so it is durable across server restarts.

---

## 🔧 Step-by-Step Instructions

### Database1 (Postgres setup)

1. Install PostgreSQL locally or run it via Docker.
2. Create a database called `demo`.
3. Inside it, create a table `counters` with fields like `id` (primary key) and `value` (the counter).
4. Test the database connection with a simple query:
   - `SELECT * FROM counters;`

### Backend2 (Go server with Postgres)

1. Extend your backend to connect to Postgres using a database driver (e.g., pgx).
2. Move the counter logic into the database:
   - `GET /counter` → reads the current counter value from the `counters` table.
   - `POST /counter/increment` → updates the table and returns the new value.
3. Use an environment variable (`DATABASE_URL`) for your connection string instead of hardcoding credentials.
   - Example: store it in a `.env` file and load it at runtime.
4. Test that the backend still responds correctly after server restarts — the counter should continue from the last saved value.

### Frontend2 (Flutter client)

1. No major changes in the frontend code.
2. It still calls the same endpoints (`/counter` and `/counter/increment`).
3. The difference is **what happens behind the scenes**: now the backend queries the database instead of in-memory data.

---

## 📖 Concepts Introduced

- **Database persistence**: state is stored on disk in a database, surviving server restarts.
- **Postgres basics**: database, schema, and tables.
- **Environment variables**: safe way to handle credentials and database URLs.
- **Migrations**: SQL commands to create or update database schema.
- **Durability**: backend restarts no longer reset the counter.

---

## 🪞 Reflection

- ✅ Counter survives both UI and backend restarts.
- ✅ Learned to connect backend to an external database.
- ❌ Currently, only one counter exists; scaling to multiple users would require schema changes.
- 🔜 Next: expand into DevOps practices like CI/CD pipelines and monitoring.

---

## ✅ Outcome

- Database runs locally and stores the counter state.
- Backend reads/writes to Postgres instead of memory.
- Frontend interacts with the backend in the same way, but data is now **persistent**.
