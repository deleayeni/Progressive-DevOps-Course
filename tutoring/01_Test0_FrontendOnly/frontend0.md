# 💻 Module — frontend0 (Just UI)

## 🎯 Learning Goal

Build a simple **Flutter counter app** that runs locally and increments a number when you press a button.

## ⚠️ Problem / Issue

Right now, the counter value is stored **only inside the app’s memory**.  
If the app closes or restarts, the counter resets back to 0.  
This demonstrates why applications eventually need a backend.

## 🛠 Guided Steps with Resources 📚

1. **Install Flutter SDK and set up your environment**

   - Follow the official guide → [Install & run Flutter](https://docs.flutter.dev/get-started/install)
   - Confirm everything works with `flutter doctor`.

2. **Scaffold your project**

   - Run `flutter create frontend0`
   - Open it in VS Code or Android Studio.

3. **Understand how Flutter UIs are built**

   - Read → [Widgets overview](https://docs.flutter.dev/development/ui/widgets)
   - Apps are trees of widgets (`MaterialApp`, `Scaffold`, `Text`, `FloatingActionButton`).

4. **Make your app interactive**

   - Learn about [`StatefulWidget`](https://docs.flutter.dev/development/ui/interactive)
   - The counter page must be stateful so it can update dynamically.

5. **Update state when the button is pressed**

   - See → [`setState`](https://docs.flutter.dev/development/ui/interactive#changing-state)
   - `setState()` triggers the widget tree to rebuild so the UI updates instantly.

6. **Use Material widgets for layout and buttons**

   - Reference → [Material widgets](https://docs.flutter.dev/development/ui/widgets/material)
   - Display the counter and a floating action button.

7. **Run and test your app**
   - Launch on an emulator or physical device.
   - Use _Hot Reload_ to see instant UI changes without losing current state.

**Expected Result**

- A visible counter starting at 0.
- Each button press increments the number.
- Restarting the app resets the value → shows volatility.

## 📖 What You Learned

- **Frontend-only applications:** great for isolated UIs, limited for persistence.
- **Ephemeral state:** data in RAM disappears on restart.
- **State management:** even small apps need a structure for state changes.
- **Why backends exist:** to maintain data beyond the UI lifecycle.
- **Progressive architecture thinking:** DevOps begins with recognizing such limitations.

## 🔍 Reflection

✅ You now have a working UI.  
❌ Counter resets to 0 if the app restarts.  
🔜 Next: Add a backend API (Test 1) so state survives app closures.

## ✅ Solution Reference

Implementation → [demo0-frontend-only on GitHub](https://github.com/deleayeni/Progressive-DevOps-Course/tree/main/tests/demo0-frontend-only)
