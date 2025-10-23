# 🧩 Frontend 1 — Flutter UI Calls the Backend API

## 🎯 Learning Goal

- Replace local counter state with server state.
- Use the Flutter `http` package to call the Go API:
  - `GET /counter`
  - `POST /counter/increment`
- Understand client–server communication through HTTP.

---

## ⚠️ Problem / Issue

- **Frontend0:** Local-only state reset every restart.
- **Backend0:** Server existed but provided no useful data.
- **Goal:** Connect them — the frontend should read and update counter data through the backend.

---

## 🛠️ What to Build

- Add HTTP package to Flutter.
- Replace internal counter logic with API calls.
- Display the backend-provided counter.

✅ **Done When:**

- The counter shown in the UI matches backend state.
- Each button press sends a `POST` request.
- Restarting the app preserves backend data.

---

## 📖 Concepts Introduced

- **HTTP Requests in Flutter** – Sending/receiving JSON with the `http` package.
- **Asynchronous Programming** – `Future`, `async`, `await`.
- **Separation of Concerns** – UI handles presentation, backend handles logic.
- **Error Handling** – Handling failed requests gracefully.

---

## 🔍 Reflection

✅ UI now reflects backend data.  
✅ State persists across UI restarts.  
❌ Backend restarts still reset counter.  
🔜 Next: backend persistence with a database.

---

## 🔗 Resources

- [Flutter HTTP package](https://pub.dev/packages/http)
- [Flutter async programming guide](https://dart.dev/codelabs/async-await)
- [Flutter JSON & REST API tutorial](https://docs.flutter.dev/cookbook/networking/fetch-data)
