# From Fullstack to DevOps — A Progressive Learning Path

## 📘 Introduction

This course is designed as a **progressive roadmap** to learn DevOps concepts by building a real project step by step.  
Instead of starting with abstract theory, we use small, focused demos where each one:

- Solves one concrete problem.
- Introduces one or two new concepts.
- Reveals the next limitation to be addressed.

By the end, you will have touched the full stack: frontend, backend, database, and DevOps practices.

---

## 🎯 Audience

- Developers who know some programming but want to understand **how frontend, backend, and databases fit together**.
- Learners curious about **DevOps concepts** (CI/CD, monitoring, scaling) but unsure where to start.
- No prior experience with Flutter, Go, or Postgres is required — each step is guided and incremental.

---

## 🛠 Teaching Philosophy

- **Demystify, not master**: We focus on clarity and simplicity over depth.
- **Small bricks**: Each demo is achievable in 1–2 days.
- **Progressive complexity**: Every demo builds on the last, gradually layering frontend → backend → DB → DevOps.
- **Reflections**: At the end of each demo, we summarize what was solved and what limitation points toward the next step.

---

## 📂 Course Structure

### Composed Demo 0 — Just UI & Simple Backend

- **Frontend0**: A Flutter counter app.
- **Backend0**: A minimal Go HTTP server with a health-check.
- **Lesson**: Frontend and backend exist separately, but don’t yet talk to each other.

### Composed Demo 1 — UI + Backend

- **Frontend1**: Flutter app calls the backend API.
- **Backend1**: Go server manages counter state in memory.
- **Lesson**: State survives UI restarts but resets if the backend restarts.

### Composed Demo 2 — Add Database

- **Database1**: Postgres stores the counter.
- **Backend2**: Go server connects to Postgres for persistence.
- **Frontend2**: Still calls the same API, but now data survives backend restarts.
- **Lesson**: Introduces persistence, environment variables, and database schema basics.

---

## 🔮 Future Roadmap

- **Demo 3 — CI/CD Pipelines**  
  Automate builds, tests, and deployments.

- **Demo 4 — Monitoring & Logging**  
  Add health checks, metrics, and alerts for real-world reliability.

---

## ✅ Outcomes

By completing this course, you will:

- Understand how a Flutter frontend communicates with a Go backend.
- Learn how to connect a backend to a Postgres database.
- Gain practical knowledge of APIs, HTTP requests, JSON, and persistence.
- Be prepared to extend the project into real **DevOps workflows** (CI/CD, monitoring).

---

## 📎 Resources

- Roadmap diagram: [roadmap.sh — Become a DevOps Engineer](https://roadmap.sh/r/become-a-devops-engineer-toqtq)
- Individual demo READMEs are inside their folders:
  - `demo0-frontend-backend/README.md`
  - `demo1-ui-backend/README.md`
  - `demo2-add-database/README.md`
