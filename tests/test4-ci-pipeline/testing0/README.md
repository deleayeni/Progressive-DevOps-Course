# Testing 0 - Unit Testing Exercise

## 🎯 Exercise Overview

This exercise introduces you to **unit testing** by exploring the `backend1` application. You'll learn how to write tests for your Go code and discover why writing testable code matters.

## 📂 Structure

```
testing0/
├── backend1/          # Go backend with counter API
│   ├── main.go        # Main application code
│   ├── counter_test.go # Unit tests for the counter API
│   └── go.mod         # Go module definition
└── frontend0/         # Flutter frontend (additional exercise)
```

## 🧪 Learning Objectives

1. **Understand what unit testing is** - Learn why tests matter for code quality
2. **Write your first Go tests** - Create tests for HTTP handlers
3. **Learn testable code design** - Discover why code structure matters for testing
4. **Practice the AAA pattern** - Arrange, Act, Assert testing methodology

## 🚀 Getting Started

### Step 1: Examine the Backend Code

Navigate to `backend1` and look at `main.go`:

```bash
cd backend1
cat main.go
```

The code implements a simple counter API with two endpoints:

- `GET /counter` - Returns the current counter value
- `POST /counter/increment` - Increments and returns the counter

### Step 2: Run the Tests

Run the existing tests to see them in action:

```bash
go test -v
```

You should see all tests pass! 🎉

### Step 3: Understand the Test Structure

Open `counter_test.go` and examine how the tests work:

- **TestCounterResponse** - Tests JSON marshaling
- **TestGetCounterHandler** - Tests the GET endpoint
- **TestIncrementCounterHandler** - Tests the POST endpoint
- **TestGetCounterHandlerWrongMethod** - Tests error handling

Notice how tests follow the **AAA pattern**:

- **Arrange** - Set up test data
- **Act** - Call the function being tested
- **Assert** - Verify the results

### Step 4: Key Learning Points

#### Why the Code Had to Be Refactored

The original code used **anonymous functions** inside `http.HandleFunc()`:

```go
// ❌ Old way - Not testable
http.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
    // handler logic...
})
```

**Problem:** You can't directly test anonymous functions! They have no name to call.

**Solution:** Extract handlers into named functions:

```go
// ✅ New way - Testable
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    // handler logic...
}

func main() {
    http.HandleFunc("/counter", getCounterHandler)
}
```

Now tests can call `getCounterHandler()` directly!

#### Key Takeaway: Testable Code Design

**Writing tests often reveals design problems:**

- If you have to duplicate code in tests → your code isn't testable
- If functions are anonymous → they can't be tested directly
- If code is tightly coupled → it's hard to test in isolation

**Good testable code:**

- Has named, exportable functions
- Separates logic from framework setup
- Follows clear structure that's easy to test

#### ⚠️ Important Limitation: Dependencies

**Unit tests work best for code with minimal dependencies.**

**What makes our `backend1` code testable:**

- ✅ No database - uses in-memory variables
- ✅ No external API calls
- ✅ No file system operations
- ✅ Pure logic only

**Code with dependencies CANNOT be easily unit tested:**

- ❌ Database connections require a real database
- ❌ HTTP requests need network access
- ❌ File operations need file system access
- ❌ External services need API availability

**Why this matters:**

The more dependencies your code has, the harder it becomes to unit test. Code with databases, APIs, or external services requires **integration testing** instead, which you'll learn about in Testing 1.

> **Key Takeaway:** Unit tests work great for pure logic, but code with many external dependencies (databases, APIs, services) cannot be easily unit tested and needs integration testing.

## 📝 Exercise Tasks

1. **Run the tests** - Verify everything works
2. **Read the test code** - Understand how each test works
3. **Add a new test** - Try adding a test for edge cases
4. **Experiment** - Try modifying the code and see if tests catch issues

## 🔍 What You'll Learn

- The importance of writing testable code
- How tests reveal code design problems
- The AAA testing pattern
- How to structure Go code for testability
- **Unit testing limitations** - Code with many dependencies (databases, APIs) cannot be easily unit tested

## 🎓 Next Steps

After completing this exercise:

- You understand unit testing basics
- You know why code should be testable
- You've seen how tests can drive better code design
- Ready to learn about integration testing in Testing 1
