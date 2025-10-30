# 🧪 Testing 0 — Unit Testing Fundamentals

## 🎯 Learning Goals

- Understand what unit testing is and why it's essential
- Learn to write basic unit tests in Go
- Discover the importance of **testable code design**
- Master the AAA testing pattern (Arrange, Act, Assert)
- Learn how writing tests reveals code design problems

## ⚠️ Problem / Issue

- Code compiles but might have bugs we don't catch
- Manual testing doesn't scale with team collaboration
- No way to verify functionality automatically
- Changes can break existing features without us knowing
- "It works on my machine" problems persist

## 🧠 What is Unit Testing?

**Unit testing** is writing code that automatically checks if individual functions or components work correctly.

**Key Characteristics:**

- **Fast** - Tests run in milliseconds
- **Isolated** - Each test is independent
- **Repeatable** - Same results every time
- **Automated** - No manual intervention needed

**Why Unit Test?**

1. **Catch bugs early** - Find problems before users do
2. **Prevent regressions** - Ensure changes don't break existing functionality
3. **Document behavior** - Tests show how code should work
4. **Enable refactoring** - Change code confidently knowing tests will catch issues
5. **Improve design** - Writing tests reveals code structure problems

## 📖 Unit Testing in Go

### Basic Test Structure

Go tests are functions that:

- Are in files ending with `_test.go`
- Have names starting with `Test`
- Take `*testing.T` as a parameter

```go
func TestFunctionName(t *testing.T) {
    // Test code here
}
```

### The AAA Pattern

Every good test follows the **AAA pattern**:

1. **Arrange** - Set up test data and conditions
2. **Act** - Execute the code being tested
3. **Assert** - Verify the results match expectations

**Example:**

```go
func TestAdd(t *testing.T) {
    // Arrange
    a := 5
    b := 3
    expected := 8

    // Act
    result := Add(a, b)

    // Assert
    if result != expected {
        t.Errorf("Expected %d, got %d", expected, result)
    }
}
```

### Testing HTTP Handlers

For web applications, Go provides special tools to test HTTP handlers:

```go
import (
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestHandler(t *testing.T) {
    // Arrange: Create a request
    req, err := http.NewRequest("GET", "/endpoint", nil)
    if err != nil {
        t.Fatal(err)
    }

    // Create a response recorder to capture output
    rr := httptest.NewRecorder()

    // Act: Call your handler
    yourHandler(rr, req)

    // Assert: Check the response
    if rr.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", rr.Code)
    }
}
```

## 💡 The Critical Lesson: Testable Code Design

### The Story of Backend1

When we first tried to write tests for our counter API, we discovered something important: **not all code is testable**.

#### ❌ The Original Problem

Our original code looked like this:

```go
func main() {
    // Handler defined as anonymous function - NOT TESTABLE!
    http.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
        if r.Method != http.MethodGet {
            http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
            return
        }
        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(CounterResponse{Value: counter})
    })
}
```

**Why This Was a Problem:**

- **Anonymous functions can't be called directly** - They have no name
- **Tests can't access the handler** - We'd have to duplicate the code
- **Code duplication = maintenance nightmare** - Changes need to be made in multiple places

**What We Tried:**

```go
// ❌ This doesn't work - we had to duplicate the logic!
func TestGetCounterHandler(t *testing.T) {
    // We were forced to recreate the handler logic here:
    handler := func(w http.ResponseWriter, r *http.Request) {
        if r.Method != http.MethodGet {
            // ... duplicated code ...
        }
        // ... more duplication ...
    }
    handler(rr, req) // Testing duplicate code, not the real code!
}
```

**This is wrong!** We're not testing our actual code - we're testing a copy. If we change the real handler, the test won't catch it.

#### ✅ The Solution: Refactoring for Testability

We **refactored** the code to extract handlers into named, testable functions:

```go
// ✅ Extract handler as a named function - TESTABLE!
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(CounterResponse{Value: counter})
}

func main() {
    // Now we just register the function
    http.HandleFunc("/counter", getCounterHandler)
}
```

**Now tests can use the real code:**

```go
// ✅ Test the ACTUAL function!
func TestGetCounterHandler(t *testing.T) {
    req, _ := http.NewRequest("GET", "/counter", nil)
    rr := httptest.NewRecorder()

    getCounterHandler(rr, req) // Testing real code!

    if rr.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", rr.Code)
    }
}
```

### Key Insight: Tests Reveal Design Problems

**This is a crucial lesson:**

> **Writing tests often reveals code design problems. If code is hard to test, it's probably not well-designed.**

**Signs of Untestable Code:**

1. **Anonymous functions** - Can't be called by name
2. **Tight coupling** - Dependencies hard-coded, can't be mocked
3. **No separation of concerns** - Logic mixed with framework setup
4. **Global state** - Hard to isolate and test independently

**Signs of Testable Code:**

1. **Named, callable functions** - Can be tested directly
2. **Clear boundaries** - Logic separated from framework
3. **Dependency injection** - Dependencies passed in, not hard-coded
4. **Isolated units** - Each function has a single responsibility

### The Refactoring We Did

In `backend1`, we:

1. **Extracted anonymous handlers** → Named functions (`getCounterHandler`, `incrementCounterHandler`)
2. **Separated handler logic** → From HTTP framework setup
3. **Made functions testable** → Can now be called directly in tests

**Result:**

- ✅ Tests can call the actual handler functions
- ✅ No code duplication
- ✅ Changes to handlers are caught by tests
- ✅ Code is cleaner and more maintainable

## ⚠️ Unit Testing Limitations: Dependencies

### The Fundamental Problem

**Unit tests are limited by external dependencies.** This is one of the most important concepts to understand.

**What is a dependency?**
A dependency is anything your code needs to work:

- **Databases** - PostgreSQL, MySQL, MongoDB
- **APIs** - HTTP endpoints, REST services
- **File system** - Reading/writing files
- **Network** - Making HTTP requests
- **External services** - Third-party APIs (payment, email, etc.)
- **System resources** - Environment variables, time, random numbers

### Why Dependencies Make Unit Testing Hard

**Example: Code with Database Dependency**

```go
// ❌ Cannot be unit tested easily
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    // This requires a REAL database connection!
    db, _ := sql.Open("postgres", os.Getenv("DATABASE_URL"))
    var value int
    err := db.QueryRow("SELECT value FROM counters WHERE id=1").Scan(&value)
    if err != nil {
        http.Error(w, "Database error", http.StatusInternalServerError)
        return
    }
    json.NewEncoder(w).Encode(CounterResponse{Value: value})
}
```

**Problems:**

1. **Requires real database** - Tests need actual database running
2. **Slow** - Database operations take time (milliseconds vs. nanoseconds)
3. **Fragile** - Tests fail if database is down or misconfigured
4. **Not isolated** - Tests affect each other through shared database
5. **Complex setup** - Need to create tables, seed data, clean up

**What happens when you try:**

```go
func TestGetCounterHandler(t *testing.T) {
    req, _ := http.NewRequest("GET", "/counter", nil)
    rr := httptest.NewRecorder()

    getCounterHandler(rr, req) // 💥 FAILS! No database connection!

    // Error: "database connection failed"
    // Error: "table does not exist"
    // Error: "connection refused"
}
```

### Code with Many Dependencies

**The more dependencies, the harder to unit test:**

```go
// ❌ Too many dependencies - very difficult to unit test!
func processOrder(orderID string) error {
    // 1. Database dependency
    order, _ := db.GetOrder(orderID)

    // 2. Payment API dependency
    payment, _ := paymentService.Charge(order.Amount)

    // 3. Email service dependency
    emailService.SendReceipt(order.Email, payment.ID)

    // 4. Inventory system dependency
    inventoryService.ReserveItems(order.Items)

    // 5. File system dependency
    receiptFile := createReceiptPDF(order, payment)

    // 6. Notification service dependency
    notificationService.Notify(order.UserID, "Order processed")

    return nil
}
```

**To unit test this, you'd need:**

- ✅ Real database running
- ✅ Payment API accessible
- ✅ Email service working
- ✅ Inventory system connected
- ✅ File system permissions
- ✅ Notification service available

**This is NOT a unit test anymore - it's an integration test!**

### When Unit Tests Don't Work

**You CANNOT easily unit test code that:**

1. **Connects to databases**

   ```go
   db.QueryRow("SELECT ...")  // ❌ Needs real database
   ```

2. **Makes HTTP requests**

   ```go
   http.Get("https://api.example.com")  // ❌ Needs network
   ```

3. **Reads/writes files**

   ```go
   os.ReadFile("config.json")  // ❌ Needs file system
   ```

4. **Depends on environment**

   ```go
   os.Getenv("API_KEY")  // ❌ May not be set in test
   ```

5. **Uses time/random**
   ```go
   time.Now()  // ❌ Hard to verify exact time
   rand.Int()  // ❌ Non-deterministic
   ```

### Why Our Backend1 Example Works

**Our `backend1` code is testable because it has NO external dependencies:**

```go
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    // ✅ No database - uses in-memory variable
    // ✅ No API calls - just returns data
    // ✅ No file system - just JSON encoding
    // ✅ Pure function with minimal dependencies

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(CounterResponse{Value: counter})
}
```

**Why this works:**

- Uses only in-memory variable (`counter`)
- Standard library only (no external services)
- No network calls
- No database queries
- Fast and isolated

### Solutions for Testing Code with Dependencies

#### 1. **Integration Testing** (Testing 1)

Test with **real dependencies** running:

- Real database
- Real API services
- Real file system
- Slower but comprehensive

#### 2. **Mocking** (Advanced)

Replace dependencies with fake implementations:

```go
// Advanced technique - not covered in this course
type Database interface {
    GetCounter(id int) (int, error)
}

// In tests, use a fake database
fakeDB := &FakeDatabase{}
handler := NewHandler(fakeDB)
```

#### 3. **Dependency Injection** (Advanced)

Pass dependencies as parameters:

```go
// Better design - allows testing
func getCounterHandler(db Database, w http.ResponseWriter, r *http.Request) {
    value, _ := db.GetCounter(1)
    // ...
}

// In tests, pass a test database
testDB := NewTestDatabase()
getCounterHandler(testDB, w, r)
```

#### 4. **Isolate Dependencies**

Separate business logic from dependencies:

```go
// ✅ Pure business logic - easy to test
func calculateTotal(items []Item) float64 {
    total := 0.0
    for _, item := range items {
        total += item.Price * float64(item.Quantity)
    }
    return total
}

// ❌ Mixed with database - hard to test
func getOrderTotal(orderID string) float64 {
    items, _ := db.GetOrderItems(orderID)  // Dependency!
    return calculateTotal(items)  // Pure logic
}
```

### The Spectrum of Testing

```
┌─────────────────────────────────────────────────────┐
│ Unit Tests                     Integration Tests    │
│                                                      │
│ ✓ Fast                         ✓ Comprehensive      │
│ ✓ Isolated                     ✓ Real dependencies  │
│ ✓ No dependencies              ✓ End-to-end         │
│ ✗ Limited scope               ✗ Slow               │
│ ✗ Miss integration bugs       ✗ Complex setup      │
└─────────────────────────────────────────────────────┘
```

**Unit Tests:**

- Test individual functions in isolation
- No external dependencies
- Fast (< 1ms per test)
- Best for: Pure logic, calculations, transformations

**Integration Tests:**

- Test multiple components together
- Real dependencies (database, APIs)
- Slower (seconds per test)
- Best for: End-to-end workflows, API interactions

### Key Takeaway

> **Unit tests work best for code with minimal dependencies. Code with many external dependencies (databases, APIs, services) cannot be easily unit tested and requires integration testing instead.**

**In Testing 1**, you'll learn how to write integration tests for code with dependencies.

## 🎓 Go Testing Best Practices

### Test Naming Convention

```go
// Pattern: TestFunctionName_Scenario_ExpectedResult
func TestAdd_PositiveNumbers_ReturnsSum(t *testing.T) { }
func TestCounter_GET_ReturnsValue(t *testing.T) { }
```

### Test Organization

```go
func TestFunctionName(t *testing.T) {
    // Test happy path
    t.Run("success case", func(t *testing.T) {
        // ...
    })

    // Test error cases
    t.Run("error case", func(t *testing.T) {
        // ...
    })
}
```

### What to Test

**Do Test:**

- ✅ **Happy paths** - Normal operation
- ✅ **Edge cases** - Boundary conditions (empty input, max values, etc.)
- ✅ **Error conditions** - Invalid inputs, missing data
- ✅ **Business logic** - Core functionality and rules

**Don't Test:**

- ❌ Third-party libraries (they have their own tests)
- ❌ Framework code (Go's HTTP library is tested)
- ❌ Trivial code (simple getters/setters)
- ❌ External dependencies (databases, APIs - use integration tests instead)

### Table-Driven Tests

For testing multiple scenarios, use table-driven tests:

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a        int
        b        int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"zero", 0, 0, 0},
        {"negative", -1, 1, 0},
        {"large numbers", 1000, 2000, 3000},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
            t.Errorf("Add(%d, %d) = %d; expected %d",
                    tt.a, tt.b, result, tt.expected)
        }
        })
    }
}
```

**Benefits:**

- Easy to add new test cases
- Clear test scenarios
- Consistent test structure

## 📚 Hands-On: Testing the Counter API

### Your Exercise: `backend1`

Navigate to `tests/test4-ci-pipeline/testing0/backend1` and examine:

1. **`main.go`** - The refactored, testable code
2. **`counter_test.go`** - The unit tests

**Run the tests:**

```bash
cd tests/test4-ci-pipeline/testing0/backend1
go test -v
```

**Test Examples:**

1. **TestCounterResponse** - Tests JSON marshaling (data structure test)
2. **TestGetCounterHandler** - Tests GET endpoint (happy path)
3. **TestIncrementCounterHandler** - Tests POST endpoint (state change)
4. **TestGetCounterHandlerWrongMethod** - Tests error handling (edge case)

**Notice how each test:**

- Sets up test data (Arrange)
- Calls the actual handler function (Act)
- Verifies the response (Assert)

## 🔍 Understanding Test Failures

### Common Test Failure Scenarios

1. **Missing `go.mod`** - Go needs a module to run tests

   - Solution: Create `go.mod` with `go mod init module-name`

2. **Cannot find function** - Function is anonymous or not exported

   - Solution: Extract to named, callable function

3. **Test calls real dependencies** - Trying to test database/API calls

   - Solution: Use integration tests or mock dependencies (advanced)

4. **Tests interfere with each other** - Global state not reset
   - Solution: Reset state in each test's Arrange phase

## 🌟 Key Takeaways

### 1. Tests Drive Better Design

**Writing tests forces you to write better code:**

- Functions must be callable → forces extraction
- Logic must be isolated → forces separation of concerns
- Dependencies must be explicit → forces clear interfaces

### 2. The Red-Green-Refactor Cycle

1. **Red** - Write a failing test
2. **Green** - Write code to make it pass
3. **Refactor** - Improve code while keeping tests green

This cycle ensures you always have working tests.

### 3. Testability is a Feature

**Treat testability as a first-class concern:**

- Design code to be testable from the start
- If code is hard to test, refactor it
- Tests are documentation - they show how code works

### 4. The Cost of Not Testing

**Without tests:**

- Bugs reach production
- Refactoring is risky
- Changes require manual testing
- Code quality degrades over time

**With tests:**

- Bugs caught early
- Refactoring is safe
- Automated verification
- Code quality improves over time

## 🔄 The Journey from Untestable to Testable

### Before Refactoring

```go
// ❌ Anonymous function - untestable
http.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
    // logic here
})
```

**Problems:**

- Can't call it in tests
- Would need to duplicate code
- Changes might not be caught

### After Refactoring

```go
// ✅ Named function - testable
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    // logic here
}

func main() {
    http.HandleFunc("/counter", getCounterHandler)
}
```

**Benefits:**

- Can call it directly in tests
- No code duplication
- Changes automatically tested

## 📈 Progress Check

After completing this tutorial, you should:

- ✅ Understand what unit testing is and why it matters
- ✅ Know how to write basic Go tests using the AAA pattern
- ✅ Recognize when code is testable vs. untestable
- ✅ Understand that writing tests reveals design problems
- ✅ Know why we refactored the original code to be testable
- ✅ Be able to write tests for HTTP handlers

## 🎯 Reflection

- ✅ **Solved:** Understanding of unit testing and testable code design
- ✅ **Skills:** Ability to write Go unit tests
- ✅ **Insight:** Learned that testability is a design concern, not an afterthought
- ✅ **Discovery:** Writing tests revealed the need to refactor anonymous handlers
- ✅ **Practice:** Applied AAA pattern in real tests
- ✅ **Understanding:** Recognized that unit tests have limitations with dependencies
- ⚠️ **Limitation:** Unit tests cannot easily test code with databases, APIs, or other external dependencies
- 🔜 **Next:** Learn integration testing in Testing 1 for testing with external dependencies

## 🚀 Next Steps

You've learned:

- How to write unit tests
- Why code should be testable
- How tests reveal design problems

**In Testing 1**, you'll learn about:

- Integration testing
- Testing with real databases and APIs
- When to use unit vs. integration tests
