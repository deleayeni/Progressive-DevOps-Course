# 🧪 Test 4 — CI Pipeline: Testing 0 — Unit Testing

## 🎯 Objective

Learn the fundamentals of unit testing by writing tests for both Go backend and Flutter frontend code.  
This exercise demonstrates how to write testable code and create unit tests that verify individual functions work correctly.

## 📦 Modules

- `backend1/` — Go backend with counter endpoints that has been refactored for testability
- `frontend0/` — Flutter frontend with counter UI that can be tested

## 🧠 What to Do

1. **Refactor code** to make it testable (extract anonymous functions into named handlers)
2. **Write backend tests** for Go HTTP handlers using the `testing` package
3. **Write frontend tests** for Flutter widgets using `flutter_test`
4. **Run tests locally** to ensure they all pass
5. **Integrate into CI** so tests run automatically on every commit

## ✅ What "Done" Looks Like

- ✅ Backend code is refactored with named handler functions
- ✅ Backend unit tests pass for all handler endpoints
- ✅ Frontend unit tests pass for widget interactions
- ✅ CI pipeline runs all tests automatically
- ✅ All tests follow the AAA (Arrange, Act, Assert) pattern

## 🧪 Verification

- `go test -v` in backend1 directory passes all tests
- `flutter test` in frontend0 directory passes all tests
- CI pipeline shows green checkmarks for unit test jobs
- Tests are fast and run in isolation

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 4 Overview](../../../tutoring/05_Test4_CI_Pipeline/_overview.md)** — Course introduction and concepts
- **[Testing 0 Tutorial](../../../tutoring/05_Test4_CI_Pipeline/testing0.md)** — Unit testing fundamentals and code refactoring
- **[CI 0 Tutorial](../../../tutoring/05_Test4_CI_Pipeline/ci0.md)** — Basic CI setup

## 🚀 Next Step

Once unit tests are working, proceed to **Testing 1 — Integration Testing** to test how components work together with real services.
