# 🧩 Test 0 — Frontend Only (Counter App)

## 🎯 Objective

Build a simple **Flutter app** that displays a counter and a button.  
Each time the button is pressed, the counter should increase by 1.  
This test verifies that your Flutter environment is working and introduces the concept of local UI state.

## 🧠 What to Build

Create a Flutter application that:

1. Shows a number starting at **0** in the center of the screen.
2. Has a single **“+”** button (FloatingActionButton or similar).
3. Increments the counter each time the button is pressed.
4. Resets the counter to **0** when the app restarts (no persistence yet).

## ⚙️ Steps to Implement

1. **Create a new Flutter project**

   ```bash
   flutter create frontend0
   cd frontend0
   ```

2. **Open and edit the main file**

   - Navigate to `lib/main.dart`
   - Rename the app title to "Frontend 0 – Counter App"
   - Keep or modify the default counter logic using `setState()` inside a `StatefulWidget`

3. **Run the app**
   ```bash
   flutter run -d chrome
   ```
   or use an Android/iOS emulator

## ✅ What "Done" Looks Like

- The app launches successfully
- A counter starts at 0 and is visible on screen
- Pressing the + button increments the number
- Closing and reopening the app resets the counter to 0
- No backend or database is required

## 🧪 Verification

- The app compiles and runs without errors
- Button increments the counter correctly
- Counter resets on restart (expected)
- Hot reload works smoothly

## 🚀 Next Step

Once the counter app runs correctly, proceed to **Test 1 — UI + Backend** to connect this UI to a backend API for persistent state.
