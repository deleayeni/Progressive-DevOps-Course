# 🧩 Test 0 — Frontend-Only Introduction

## 🎯 Purpose of This Stage

Test 0 is the foundation of the entire “From Fullstack to DevOps” journey.  
Before we deal with servers, databases, or automation, we start with the simplest thing possible — a **local UI** that runs by itself.  
This lets us focus on how interfaces handle _state_ and why persistence matters before adding backend layers.

By the end of this stage, you’ll have:

- A fully functional Flutter app that runs locally.
- A clear understanding of how UI state works.
- A concrete reason to introduce a backend next.

## 🧠 Conceptual Motivation

Every software system begins as a user interface that reacts to input.  
However, real applications must **remember** what happened across restarts, users, or devices — and that’s impossible when all data lives in memory.

This stage demonstrates that limitation directly.  
You’ll build a **counter app** that increments numbers but loses its value whenever you restart it.  
That “pain point” becomes your first lesson in why **DevOps and backend systems exist** — to make behavior consistent, persistent, and shareable.

## 🧱 Architecture at This Point

User → Flutter UI → Local Memory (volatile)

No servers. No network. Just a self-contained app running on your machine.

## 🔮 What Comes Next

- **Test 1** adds a backend service written in Go to hold the counter value.
- The UI will communicate with that backend through HTTP APIs.
- You’ll see the first practical example of client-server communication and state persistence.

## ✅ Key Takeaways

- The frontend can exist alone, but its data disappears when the process stops.
- Volatile vs. persistent state is the root distinction between **frontend** and **backend** roles.
- This simple app will evolve into a full, containerized, monitored system as you progress through the Tests.
