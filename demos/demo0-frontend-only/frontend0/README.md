# Demo 0 – Frontend Only (Flutter Counter App)

## Learning Goal

- Show that frontend setup is not scary.
- Learn how to run a Flutter project and use basic tooling (`flutter doctor`, hot reload).
- Gain confidence by building a simple UI.

## What You Build

- A basic Flutter counter app (in the `frontend/` folder).
- The app displays a counter and increments it when you press a button.

## Solve

- You have a working UI.
- You can press a button and see the counter increase.

## Issue (Unsolved on Purpose)

- The counter resets to 0 whenever the app restarts.
- There is no persistence.
- This problem motivates Demo 1, where we introduce a backend API.

## Project Structure

demo0-frontend-only/
frontend/ (Flutter app code with pubspec.yaml, lib/, android/, ios/, etc.)
README.md (this file)

## How to Run

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Check your setup:
   flutter doctor
3. Go into the project folder:
   cd demos/demo0-frontend-only/frontend
4. Run the app:
   flutter run
5. Press the “+” button and watch the counter go up.

## Concepts Introduced

- Frontend vs Backend → A frontend is what the user interacts with. There is no backend here yet.
- State in UI → The counter is stored in app memory only.
- Ephemeral vs Persistent Data → Temporary memory disappears when the app restarts; persistence requires backend/database.
- Flutter Tooling →
  - flutter doctor checks your environment.
  - Hot reload lets you see code changes instantly.

## Next Step

- In Demo 1, we connect the frontend to a backend API written in Go.
- This will allow the counter value to persist while the backend is running.
