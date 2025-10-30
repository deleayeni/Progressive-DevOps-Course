# 🧪 Testing 1 — Integration Testing

## 🎯 Learning Goal

- Understand integration testing and how it differs from unit testing
- Learn to test API endpoints and HTTP interactions
- Learn to test frontend-backend communication
- Master testing with external dependencies (databases, APIs)

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

### 2. **Test Backend API Endpoints**

**Create integration test:** `backend3/api_test.go`

```go
package main

import (
    "bytes"
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestCounterAPI(t *testing.T) {
    // Set up test database (in-memory or test database)
    setupTestDB(t)
    defer cleanupTestDB(t)

    // Create test server
    server := httptest.NewServer(http.HandlerFunc(getCounterHandler))
    defer server.Close()

    t.Run("GET /counter returns current value", func(t *testing.T) {
        // Act: Make HTTP request
        resp, err := http.Get(server.URL + "/counter")
        if err != nil {
            t.Fatalf("Failed to make request: %v", err)
        }
        defer resp.Body.Close()

        // Assert: Check response
        if resp.StatusCode != http.StatusOK {
            t.Errorf("Expected status 200, got %d", resp.StatusCode)
        }

        var result CounterResponse
        if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
            t.Fatalf("Failed to decode response: %v", err)
        }

        if result.Value < 0 {
            t.Errorf("Counter value should not be negative, got %d", result.Value)
        }
    })

    t.Run("POST /counter/increment increments value", func(t *testing.T) {
        // Get initial value
        resp, _ := http.Get(server.URL + "/counter")
        var initial CounterResponse
        json.NewDecoder(resp.Body).Decode(&initial)
        resp.Body.Close()

        // Increment counter
        resp, err := http.Post(server.URL+"/counter/increment", "application/json", nil)
        if err != nil {
            t.Fatalf("Failed to increment: %v", err)
        }
        defer resp.Body.Close()

        if resp.StatusCode != http.StatusOK {
            t.Errorf("Expected status 200, got %d", resp.StatusCode)
        }

        var result CounterResponse
        json.NewDecoder(resp.Body).Decode(&result)

        if result.Value != initial.Value+1 {
            t.Errorf("Expected %d, got %d", initial.Value+1, result.Value)
        }
    })
}

func TestCORSHeaders(t *testing.T) {
    server := httptest.NewServer(http.HandlerFunc(getCounterHandler))
    defer server.Close()

    // Test CORS headers
    resp, err := http.Get(server.URL + "/counter")
    if err != nil {
        t.Fatalf("Failed to make request: %v", err)
    }
    defer resp.Body.Close()

    corsOrigin := resp.Header.Get("Access-Control-Allow-Origin")
    if corsOrigin != "*" {
        t.Errorf("Expected CORS origin '*', got '%s'", corsOrigin)
    }
}
```

### 3. **Test Frontend-Backend Integration**

**Create integration test:** `frontend2/integration_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend2/main.dart';
import 'package:frontend2/services/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Frontend-Backend Integration Tests', () {
    testWidgets('App loads and displays counter from backend', (WidgetTester tester) async {
      // Arrange: Start the app
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));
      await tester.pumpAndSettle(); // Wait for async operations

      // Assert: App should show loading or counter value
      expect(find.textContaining('Counter:'), findsOneWidget);
    });

    testWidgets('Increment button calls backend API', (WidgetTester tester) async {
      // This test would require a running backend
      // In real integration tests, you'd start a test server

      await tester.pumpWidget(const MaterialApp(home: CounterPage()));
      await tester.pumpAndSettle();

      // Find the current counter value
      final counterText = find.textContaining('Counter:');
      expect(counterText, findsOneWidget);

      // Tap increment button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the counter updated (this would require backend)
      expect(find.textContaining('Counter:'), findsOneWidget);
    });
  });
}
```

### 4. **Test Database Integration**

**Create database integration test:** `backend3/database_test.go`

```go
func TestDatabaseIntegration(t *testing.T) {
    // Set up test database
    db := setupTestDatabase(t)
    defer db.Close()

    t.Run("Database connection works", func(t *testing.T) {
        var count int
        err := db.QueryRow("SELECT COUNT(*) FROM counters").Scan(&count)
        if err != nil {
            t.Fatalf("Database query failed: %v", err)
        }

        // Should have at least one row (initialized in main.go)
        if count < 1 {
            t.Error("Expected at least one counter row")
        }
    })

    t.Run("Counter increment persists to database", func(t *testing.T) {
        // Get initial value
        var initialValue int
        err := db.QueryRow("SELECT value FROM counters WHERE id=1").Scan(&initialValue)
        if err != nil {
            t.Fatalf("Failed to get initial value: %v", err)
        }

        // Increment in database
        var newValue int
        err = db.QueryRow("UPDATE counters SET value = value + 1 WHERE id=1 RETURNING value").Scan(&newValue)
        if err != nil {
            t.Fatalf("Failed to increment: %v", err)
        }

        // Verify increment
        if newValue != initialValue+1 {
            t.Errorf("Expected %d, got %d", initialValue+1, newValue)
        }
    })
}

func setupTestDatabase(t *testing.T) *sql.DB {
    // Set up test database connection
    // This would connect to a test database instance
    db, err := sql.Open("postgres", "test_database_url")
    if err != nil {
        t.Fatalf("Failed to connect to test database: %v", err)
    }
    return db
}
```

## 📖 Concepts Introduced

### **Integration Testing Patterns**

**API Testing:**

- Test HTTP endpoints with real requests
- Verify response status codes and headers
- Test request/response data formats
- Validate CORS and security headers

**Database Testing:**

- Test database connections and queries
- Verify data persistence
- Test transaction handling
- Validate data integrity

**Frontend-Backend Testing:**

- Test complete user workflows
- Verify API communication
- Test error handling and edge cases
- Validate data flow between components

### **Testing Tools and Techniques**

**HTTP Testing:**

```go
// httptest.NewServer - Create test HTTP server
// http.Get/Post - Make HTTP requests
// json.NewDecoder - Parse JSON responses
```

**Flutter Integration Testing:**

```dart
// IntegrationTestWidgetsFlutterBinding - Set up integration test
// tester.pumpAndSettle() - Wait for async operations
// Real API calls (with test backend)
```

**Test Database Setup:**

```go
// Separate test database
// Test data setup and cleanup
// Transaction rollback for isolation
```

### **Integration Test Best Practices**

**Test Environment:**

- Use separate test database
- Mock external services when possible
- Clean up test data after each test
- Use test-specific configuration

**Test Organization:**

- Group related tests together
- Use descriptive test names
- Test both success and failure scenarios
- Verify side effects and state changes

**Performance Considerations:**

- Integration tests are slower than unit tests
- Run them less frequently
- Use them for critical user workflows
- Consider parallel execution

## 🔍 Reflection

- ✅ **Solved:** Understanding of integration testing concepts
- ✅ **Skills:** Ability to test API endpoints and database interactions
- ✅ **Knowledge:** How to test frontend-backend communication in Docker environment
- ✅ **Foundation:** Ready to implement comprehensive testing in production CI
- ❌ **Limitation:** Tests still run manually, not automated
- 🔜 **Next:** Add integration tests to production CI pipeline in CI 3
