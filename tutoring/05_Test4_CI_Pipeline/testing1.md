# 🧪 Testing 1 — Integration Testing

## 🎯 Learning Goal

- Understand integration testing and how it differs from unit testing
- Learn to test API endpoints and HTTP interactions
- Learn to test frontend-backend communication
- Master testing with external dependencies (databases, APIs)

## 🧩 What Is Integration Testing (Conceptually)?

In software delivery pipelines, **integration testing** verifies that separate systems or components **communicate correctly across boundaries** — for example, your backend talking to a real database, or your app consuming an external API.

It's different from **component testing**, which checks how modules within the same system interact.  
Component tests stay *inside* the application, while integration tests cross network or process boundaries.

| Test Type | What It Checks | Example |
|-----------|----------------|---------|
| **Component Test** | Interaction between modules *inside* one system | Service ↔ Repository layer |
| **Integration Test** | Communication *between* independent systems | Backend ↔ PostgreSQL ↔ Frontend |

### 🧱 The Testing Hierarchy

Understanding where integration tests fit in the overall testing strategy:

```text
Unit → Component → Integration → Acceptance
```

- **Unit tests**: Verify individual functions (fast, isolated)
- **Component tests**: Verify interactions inside one service
- **Integration tests**: Verify communication across services
- **Acceptance tests**: Verify end-to-end user behavior

## ⚠️ Problem / Issue

- Unit tests verify individual functions work, but not how they work together
- Docker containers are built and validated, but not tested as integrated system
- No way to test if frontend and backend communicate correctly through Docker
- No validation that API endpoints work as expected in containerized environment
- Database interactions aren't tested in the full Docker stack

## 🧠 What You'll Do

### 1. **Understand Integration Testing**

**Unit Testing vs Integration Testing:**

| Unit Testing                       | Integration Testing                |
| ---------------------------------- | ---------------------------------- |
| Tests individual functions         | Tests how components work together |
| Isolated, no external dependencies | Tests with real dependencies       |
| Fast execution                     | Slower execution                   |
| Easy to debug                      | More complex to debug              |

**Real-world analogy:**

- **Unit test:** "Does the engine start?" (test engine alone)
- **Integration test:** "Does the car drive?" (test engine + transmission + wheels together)

### 2. **Safe Integration Environments**

There are **two safe ways** to perform integration tests:

1. **Real Dependencies:**
   Run tests against real systems such as a local PostgreSQL or a test API instance (like we do in Docker).

2. **Simulated Dependencies (Test Harness):**
   When the real service is unavailable, use a *test harness* — a small fake server that mimics expected responses.

⚠️ **Important:**
Never run integration tests against production systems.  
Isolate test environments using firewall rules, dummy URLs, or sandbox credentials to prevent accidental data changes.

### 3. **Test Backend to Database Integration**

**Create integration test:** `backend3/integration_test.go`

This test verifies that the backend handlers correctly interact with the PostgreSQL database:

```go
package main

import (
    "context"
    "net/http"
    "net/http/httptest"
    "testing"

    "github.com/jackc/pgx/v5"
)

func TestBackendToDatabaseIntegration(t *testing.T) {
    // 1. Connect to database (already running from docker-compose)
    dsn := "postgres://postgres:secret@localhost:5433/appdb?sslmode=disable"
    testDB, err := pgx.Connect(context.Background(), dsn)
    if err != nil {
        t.Skip("Database not running, skipping integration test")
    }

    // 2. Set global db variable (handlers use this!)
    db = testDB
    defer db.Close(context.Background())

    // 3. Reset counter to 0 in database
    testDB.Exec(context.Background(),
        "INSERT INTO counters (id, value) VALUES (1, 0) ON CONFLICT (id) DO UPDATE SET value = 0")

    // 4. Call increment handler
    req, _ := http.NewRequest("POST", "/counter/increment", nil)
    rr := httptest.NewRecorder()
    incrementCounterHandler(rr, req)  // This writes to database!

    // 5. Read directly from database to verify
    var dbValue int
    testDB.QueryRow(context.Background(),
        "SELECT value FROM counters WHERE id=1").Scan(&dbValue)

    // 6. Assert: Database should show 1
    if dbValue != 1 {
        t.Errorf("Expected database value 1, got %d", dbValue)
    }
}
```

**What this test does:**

- Connects to the real PostgreSQL database running in Docker
- Sets the global `db` variable so handlers use the test database
- Resets the counter to 0 for a clean test state
- Calls the actual `incrementCounterHandler` function
- Reads directly from the database to verify the value was incremented
- This tests the **complete flow**: Handler → Database write → Database read

### 3. **Test Frontend-Backend Integration**

**Create integration test:** `frontend2/test/api_integration_test.dart`

This test verifies that the Flutter frontend correctly communicates with the Go backend API:

```dart
import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_client.dart';

void main() {
  group('Frontend to Backend Integration Tests', () {
    late ApiClient api;

    setUp(() {
      // Create API client
      api = ApiClient();
    });

    test('GET /counter returns current value from backend', () async {
      // Act: Call the API
      final value = await api.getCounter();

      // Assert: Should return a valid integer
      expect(value, isA<int>());
      expect(value, greaterThanOrEqualTo(0));
    });

    test('POST /counter/increment increments and returns new value', () async {
      // Arrange: Get initial value
      final initialValue = await api.getCounter();

      // Act: Increment
      final newValue = await api.incrementCounter();

      // Assert: Should be incremented
      expect(newValue, equals(initialValue + 1));
    });

    test('Multiple increments work correctly', () async {
      // Arrange: Get initial value
      final initialValue = await api.getCounter();

      // Act: Increment multiple times
      final value1 = await api.incrementCounter();
      final value2 = await api.incrementCounter();
      final value3 = await api.incrementCounter();

      // Assert: Each should increment
      expect(value1, equals(initialValue + 1));
      expect(value2, equals(initialValue + 2));
      expect(value3, equals(initialValue + 3));
    });
  });
}
```

**What this test does:**

- Tests the `ApiClient` class which makes real HTTP requests to the backend
- Verifies that `getCounter()` returns valid data from the backend
- Confirms that `incrementCounter()` increments the counter via the API
- Tests multiple sequential increments to ensure state persistence
- This tests the **complete flow**: Frontend → HTTP Request → Backend → Database → Response → Frontend

### 4. **Testing Failure Modes**

Real systems fail in unpredictable ways — network timeouts, slow responses, or invalid data.  
Your integration tests should simulate some of these conditions:

- **Drop or delay connections** to check retry logic  
- **Send malformed data** to ensure validation works  
- **Temporarily shut down a dependency** (e.g., stop the `db` container) to confirm error handling  

Testing how your app behaves under failure is as important as testing when everything works.

#### Example: Testing Database Unavailability

```go
func TestBackendHandlesDatabaseFailure(t *testing.T) {
    // Arrange: Stop database container
    // docker compose stop db
    
    // Act: Try to call handler
    req, _ := http.NewRequest("GET", "/counter", nil)
    rr := httptest.NewRecorder()
    getCounterHandler(rr, req)
    
    // Assert: Should handle gracefully
    if rr.Code != http.StatusInternalServerError {
        t.Errorf("Expected 500, got %d", rr.Code)
    }
    
    // Restore: docker compose start db
}
```

### 5. **Building Resilient Integrations**

To handle failure scenarios gracefully, production systems often use **resilience patterns** such as:

- **Circuit Breaker:** Temporarily stop calls to a failing dependency to prevent cascading failures.  
- **Bulkhead:** Isolate resources so one failure doesn't cascade to other parts of the system.  

Integration tests can verify these mechanisms by forcing dependency failures and observing system recovery.

**Why This Matters:**

- Production systems will face network issues, slow responses, and service outages
- Integration tests that only test "happy paths" give false confidence
- Testing failure modes helps catch bugs before they reach production
- Resilience patterns prevent small failures from becoming system-wide outages

### 6. **Add Integration Tests to CI Pipeline**

**Update CI workflow:** `.github/workflows/ci1.yml`

Add an `integration-tests` job to run tests against a real Docker stack:

```yaml
integration-tests:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: "1.25"

    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: "3.35.7"

    # Build Flutter web before docker-compose
    - name: Build Flutter web
      run: |
        cd tests/test4-ci-pipeline/testing1/docker3/frontend2
        flutter pub get
        flutter build web

    # Start database and backend (NOT frontend, since it needs build/)
    - name: Start services with docker-compose
      run: |
        cd tests/test4-ci-pipeline/testing1/docker3
        docker compose up -d db backend

    # Wait for backend to be ready
    - name: Wait for backend to be ready
      run: |
        timeout 60 bash -c 'until curl -f http://localhost:8080/counter; do sleep 2; done'

    # Run backend integration tests
    - name: Run Backend Integration Tests
      env:
        DATABASE_URL: postgres://postgres:secret@localhost:5433/appdb?sslmode=disable
      run: |
        cd tests/test4-ci-pipeline/testing1/docker3/backend3
        go test -v

    # Run frontend integration tests
    - name: Run Frontend Integration Tests
      run: |
        cd tests/test4-ci-pipeline/testing1/docker3/frontend2
        flutter pub get
        flutter test test/api_integration_test.dart

    # Always cleanup, even if tests fail
    - name: Cleanup
      if: always()
      run: |
        cd tests/test4-ci-pipeline/testing1/docker3
        docker compose down
```

**Key steps explained:**

1. **Build Flutter web:** Creates `build/web/` directory needed by Docker frontend container
2. **Start services:** Runs `db` and `backend` containers (frontend is optional for these tests)
3. **Wait for backend:** Ensures backend is ready before running tests
4. **Run tests:** Executes both backend and frontend integration tests
5. **Cleanup:** Always runs to stop containers, even if tests fail

**Safety Note:**
These tests run against isolated Docker containers, not production systems. The test database uses separate credentials and runs in a containerized environment that's completely isolated from production data.

## 📖 Concepts Introduced

### **Integration Testing Patterns**

**Backend-to-Database Testing:**

- Test database connections with real PostgreSQL database
- Verify data persistence by reading directly from database
- Use `pgx.Connect()` to connect to running database
- Test complete flow: Handler → Database write → Database read
- Set global variables to allow handlers to use test database

**Frontend-to-Backend Testing:**

- Test HTTP API communication with real backend
- Use `ApiClient` to make actual HTTP requests
- Test sequential operations to verify state persistence
- Validate data flow: Frontend → HTTP → Backend → Database → Response → Frontend

**Docker-based Integration Testing:**

- Use `docker compose up -d` to start services
- Build Flutter web assets before starting containers
- Wait for services to be ready before running tests
- Always cleanup containers with `docker compose down`

### **Testing Tools and Techniques**

**Go Integration Testing:**

```go
// pgx.Connect() - Connect to PostgreSQL database
// httptest.NewRecorder - Capture HTTP responses
// Global variable injection - Set db for handlers
// t.Skip() - Skip test if dependencies unavailable
```

**Flutter API Testing:**

```dart
// ApiClient - Real HTTP client for testing
// getCounter() - Get current value from backend
// incrementCounter() - Increment counter via API
// expect() with isA<int>() - Type assertions
```

**CI Integration:**

```yaml
# docker compose up -d db backend - Start specific services
# timeout bash -c 'until curl...' - Wait for service readiness
# if: always() - Always run cleanup step
# Build Flutter web before docker compose
```

### **Integration Test Best Practices**

**Test Environment:**

- Use real services running in Docker for realistic testing
- Connect to actual databases (not mocks) for data persistence tests
- Build Flutter assets before starting Docker containers
- Always cleanup Docker containers even if tests fail (`if: always()`)

**Test Organization:**

- Separate unit tests (testing0) from integration tests (testing1)
- Group related tests together with `group()` in Flutter and subtests in Go
- Use descriptive test names that explain what's being tested
- Test both success and failure scenarios

**CI Considerations:**

- Integration tests are slower than unit tests - run them in separate jobs
- Wait for services to be ready before running tests
- Use `t.Skip()` to gracefully skip tests if dependencies are unavailable
- Consider running integration tests only on main branch or nightly builds

**Testing Failure Scenarios:**

- Test what happens when dependencies are unavailable
- Verify error handling and graceful degradation
- Confirm that retry logic works correctly
- Ensure that partial failures don't cascade into system-wide outages

**Challenges We Solved:**

- **Problem:** Flutter `build/web/` directory not in git (build artifacts shouldn't be committed)
- **Solution:** Build Flutter web assets before running `docker compose up`
- **Problem:** Frontend Docker build fails in CI due to missing build assets
- **Solution:** Only start `db` and `backend` services for integration tests
- **Problem:** Tests need time for database to initialize
- **Solution:** Wait for backend to respond before running tests

## 🧭 Integration Testing in the Delivery Pipeline

In Continuous Delivery, integration tests aren't just for development —  
they're also used as **smoke tests after deployment** and **diagnostics for live systems**.  
They give confidence that all parts of your delivery pipeline are wired correctly.

Integration introduces **real project risks** — unstable dependencies, environment mismatches, and version drift — so planning integration testing early is critical.

Ask these questions before running integrations:

- **Do I have a reliable test service or harness?**
  - Can I run tests in isolation without affecting production?
  - Are my test environments properly isolated and secured?

- **Can I simulate failure conditions safely?**
  - Can I test what happens when dependencies fail?
  - Do my tests cover both success and failure scenarios?

- **Is the system behavior consistent across environments?**
  - Do tests pass in development, CI, and staging?
  - Are there differences between environments that could cause issues?

## 🔍 Reflection

- ✅ **Solved:** Understanding of integration testing concepts and how they differ from unit testing
- ✅ **Skills:** Ability to test database interactions with real PostgreSQL and HTTP API communication
- ✅ **Knowledge:** How to test frontend-backend communication using Docker Compose and CI
- ✅ **Foundation:** Complete integration test suite for backend-database and frontend-backend flows
- ✅ **Implemented:** Integration tests are now automated in CI pipeline via `ci1.yml`
- ✅ **Strategic Understanding:** Integration tests as smoke tests and diagnostics in continuous delivery
- ✅ **Resilience Awareness:** Understanding the importance of testing failure modes and resilience patterns
- 🔜 **Next:** Continue improving CI pipeline with deployment and additional testing stages
