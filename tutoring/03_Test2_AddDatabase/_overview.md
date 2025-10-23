# 🧩 Test 2 — Add Database

## 🚀 Ready to Start?

**[Go to Test 2 Implementation](../../tests/test2-add-database/README.md)**

## 🧠 Overview

In **Test 1**, the backend stored the counter in memory.  
Restarting the backend cleared all progress — because RAM is temporary.

In **Test 2**, we introduce a **database layer (Postgres)** to persist data.  
This marks the transition from _volatile_ to _durable_ state and lays the foundation for real DevOps workflows involving storage, configuration, and persistence.

## 🎯 Learning Goals

- Understand why applications need databases for durability.
- Learn to deploy Postgres in Docker using persistent volumes.
- Connect a Go backend to Postgres via a connection string.
- Observe the full flow: Flutter → Go → Postgres → Go → Flutter.

## ⚙️ Structure

| Module        | Description                                                | Outcome                                |
| ------------- | ---------------------------------------------------------- | -------------------------------------- |
| **database0** | Postgres setup running in Docker, schema creation.         | Data persists across restarts.         |
| **backend2**  | Go backend connects to Postgres to store/retrieve counter. | Counter now survives backend restarts. |
| **frontend1** | Unchanged Flutter UI calling backend APIs.                 | Displays persistent counter data.      |

## 🔍 Concepts Introduced

- Persistent storage vs. in-memory state.
- Docker volumes and containerized databases.
- Database schema design and SQL basics.
- Backend–database connectivity and environment variables.
- The idea of “stateful services” in DevOps.

## 📚 Detailed Modules

- **[Database 0 Tutorial](./database0.md)** — Postgres setup and schema creation
- **[Backend 2 Tutorial](./backend2.md)** — Backend database integration

## 🔜 Next Step

In **Test 3**, you'll learn to **containerize** both backend and frontend for unified deployment.
