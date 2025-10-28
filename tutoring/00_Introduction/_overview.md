# 🧭 Introduction to the Progressive DevOps Course

Welcome to the **From Fullstack to DevOps** learning repository.  
This project is both a _hands-on technical journey_ and a _teaching framework_ that grows step by step from a simple frontend app to a full DevOps ecosystem.

## 🧱 Project Overview

This repository is divided into two main parts, each serving a different purpose:

### 1. `/tests` — Practical, Runnable Projects

- Each folder inside `/tests` represents a **Test** (or milestone) in the course.
- A Test demonstrates a concrete DevOps concept through code.
- Inside each Test folder, you’ll find:
  - A `README.md` explaining the goal, problem, and setup steps.
  - Source code for the backend, frontend, or other modules.
  - Example solutions for reference.
- Think of `/tests` as your **lab environment** — where you build, run, and break things to learn.

### 2. `/tutoring` — In-Depth Explanations and Lessons

- The `/tutoring` folder contains detailed **learning materials** for each Test.
- It’s structured the same way as `/tests`, but focuses on **concepts**, **rationale**, and **teaching flow**.
- Each Test folder in `/tutoring` includes:
  - Individual Markdown files for each **module** (e.g., `frontend0`, `backend1`, `docker2`, etc.).
  - Clear learning goals, explanations, and reflection points.
  - Optional quizzes or review questions to test understanding.
- Think of `/tutoring` as your **textbook and instructor notes** — it explains not just _how_, but _why_.

## 🔍 How to Use This Repository

| Goal                                          | Where to Start                                      | What to Expect                                    |
| --------------------------------------------- | --------------------------------------------------- | ------------------------------------------------- |
| You want to **run the project**               | Go to `/tests` and open the Test README             | Short, practical steps with code                  |
| You want to **understand the concepts**       | Go to `/tutoring` and read the matching Test folder | Deep explanations and exercises                   |
| You want to **contribute or improve lessons** | Work directly inside `/tutoring`                    | The Markdown files are meant for AI-aided editing |

## 🧩 Learning Flow

The learning path is sequential:

1. **Test 0 – Frontend Only:** Build a standalone Flutter UI.
2. **Test 1 – UI + Backend:** Connect it to a Go HTTP server.
3. **Test 2 – Add Database:** Persist data with Postgres.
4. **Test 3 – Containerize:** Use Docker and Compose for reproducibility.
5. **Test 4 – CI Pipeline:** Automate builds and tests.  
   _(and more to come...)_

Each stage adds one DevOps layer — frontend → backend → database → containers → pipelines → infrastructure.

## 💡 Why Two Layers?

By separating runnable code (`/tests`) from educational notes (`/tutoring`):

- Developers can **focus on execution** without being overwhelmed by explanations.
- Teachers can **iterate and improve** the lessons independently.
- The repo stays clean, modular, and scalable as the course grows.

## ✅ Final Note

This repo is a **living curriculum** — part codebase, part textbook.  
You can use it to learn DevOps yourself, to teach others, or to extend the system with new lessons and tools.  
Start wherever you are, but remember: each Test builds directly on the one before it.

> 🪴 “Learn by building — understand by teaching.”
