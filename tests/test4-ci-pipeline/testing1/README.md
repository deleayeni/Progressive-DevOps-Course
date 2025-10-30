# 🧪 Test 4 — CI Pipeline: Testing 1 — Integration Testing

## 🎯 Objective

Learn integration testing by testing how multiple components work together.  
Unlike unit tests that test individual functions in isolation, integration tests verify that your backend, database, and frontend communicate correctly.

## 📦 Modules

- `docker3/` — Full Docker stack containing:
  - `backend3/` — Go backend with PostgreSQL integration
  - `frontend2/` — Flutter frontend with API client
  - `docker-compose.yml` — Complete service orchestration
- Both backend and frontend integration tests

## 🧠 What to Do

1. **Start Docker stack** with docker-compose (database, backend, frontend)
2. **Write backend integration tests** that test handler-to-database interactions
3. **Write frontend integration tests** that test API client-to-backend communication
4. **Run tests against running services** to verify real component interactions
5. **Integrate into CI** with proper service startup and cleanup

## ✅ What "Done" Looks Like

- ✅ Docker Compose stack starts all services successfully
- ✅ Backend integration tests verify database persistence
- ✅ Frontend integration tests verify API communication
- ✅ Tests run against real database and backend services
- ✅ CI pipeline automates service startup, testing, and cleanup
- ✅ All tests pass in CI environment

## 🧪 Verification

- `docker compose up -d` starts all services
- `curl http://localhost:8080/counter` returns JSON response
- Backend integration tests pass with `go test -v`
- Frontend integration tests pass with `flutter test`
- CI pipeline shows green checkmarks for integration test job

## 📚 Detailed Instructions

For step-by-step guidance, see the tutoring materials:

- **[Test 4 Overview](../../../tutoring/05_Test4_CI_Pipeline/_overview.md)** — Course introduction and concepts
- **[Testing 1 Tutorial](../../../tutoring/05_Test4_CI_Pipeline/testing1.md)** — Integration testing fundamentals
- **[CI 1 Tutorial](../../../tutoring/05_Test4_CI_Pipeline/ci1.md)** — Adding testing to CI pipeline

## 🚀 Next Step

Once integration tests are working, proceed to additional CI stages like deployment and advanced pipeline configurations.
