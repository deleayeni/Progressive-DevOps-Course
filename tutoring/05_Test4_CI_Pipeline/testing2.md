# 🧪 Testing 2 — End-to-End (E2E) Testing

## 🎯 Learning Goal

- Understand what end-to-end (E2E) testing is and when to use it
- Learn to write E2E tests that simulate real user interactions
- Master browser-based testing tools (Playwright, Cypress, or Flutter Driver)
- Test complete user workflows across all application layers
- Integrate E2E tests into CI/CD pipelines

## ⚠️ Problem / Issue

- Integration tests verify component interactions, but don't test the complete user experience
- UI changes can break user workflows without breaking individual components
- No way to test browser-specific issues, rendering problems, or JavaScript errors
- Manual testing is slow, inconsistent, and doesn't scale with frequent deployments
- Need to verify the entire application works as users expect

## 🧠 What You'll Do

### 1. **Understand E2E Testing**

**E2E Testing vs Other Testing Levels:**

| Aspect           | Unit Tests      | Integration Tests   | **E2E Tests**               |
| ---------------- | --------------- | ------------------- | --------------------------- |
| **Scope**        | Single function | Multiple components | Complete application        |
| **Environment**  | Isolated        | Services in Docker  | Real browser + full stack   |
| **Speed**        | Very fast       | Fast                | Slow                        |
| **Dependencies** | None (mocked)   | Real services       | Real browser + all services |
| **Tests**        | Logic           | API/Database        | User workflows              |

**When to use E2E tests:**

- ✅ Verify critical user journeys work end-to-end
- ✅ Test browser-specific functionality
- ✅ Validate complete user workflows
- ✅ Catch integration issues across all layers
- ❌ Don't use for testing isolated functions (use unit tests)
- ❌ Don't use for fast feedback (use unit/integration tests)

### 2. **E2E Testing Tools**

**Popular E2E Testing Frameworks:**

**For Web Applications:**

- **Playwright** - Modern, fast, cross-browser testing
- **Cypress** - Popular, developer-friendly, excellent documentation
- **Selenium** - Industry standard, works with many browsers

**For Flutter Applications:**

- **Flutter Driver** - Official Flutter E2E testing tool
- **Integration Test** package - For widget-level E2E testing

**Example: Playwright E2E Test**

```javascript
import { test, expect } from "@playwright/test";

test("counter increments through complete user workflow", async ({ page }) => {
  // 1. Navigate to application
  await page.goto("http://localhost:3000");

  // 2. Verify initial state
  await expect(page.locator("text=/Counter:\\s*0/")).toBeVisible();

  // 3. Perform user action
  await page.click('button:has-text("Increment")');

  // 4. Verify expected result
  await expect(page.locator("text=/Counter:\\s*1/")).toBeVisible();

  // 5. Perform multiple actions
  await page.click('button:has-text("Increment")');
  await expect(page.locator("text=/Counter:\\s*2/")).toBeVisible();

  // 6. Refresh page and verify persistence
  await page.reload();
  await expect(page.locator("text=/Counter:\\s*2/")).toBeVisible();
});
```

**What this test does:**

- Starts real browser
- Navigates to application URL
- Simulates actual user clicks
- Verifies UI updates
- Tests page reload (persistence)

### 3. **Flutter Driver E2E Test**

```dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App E2E Tests', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('increment button increases counter', () async {
      // Verify initial state
      expect(await driver.getText(find.text('0')), '0');

      // Find and tap increment button
      await driver.tap(find.byTooltip('Increment'));

      // Wait for UI update
      await driver.waitFor(find.text('1'));

      // Verify new state
      expect(await driver.getText(find.text('1')), '1');
    });

    test('page reload persists counter', () async {
      // Set counter to 5
      for (int i = 0; i < 5; i++) {
        await driver.tap(find.byTooltip('Increment'));
      }

      // Verify counter is 5
      expect(await driver.getText(find.text('5')), '5');

      // Restart app
      await driver.restart();

      // Verify counter persisted
      expect(await driver.getText(find.text('5')), '5');
    });
  });
}
```

### 4. **E2E Test Structure**

**Complete E2E Test Workflow:**

```javascript
// e2e/counter-workflow.spec.js
describe("Counter Application E2E", () => {
  beforeAll(async () => {
    // Start application stack (Docker Compose)
    // Or connect to running application
  });

  afterAll(async () => {
    // Cleanup and stop services
  });

  beforeEach(async () => {
    // Reset application state
    await page.goto("http://localhost:3000");
  });

  test("complete counter workflow", async () => {
    // 1. Verify initial load
    await expect(page.locator(".counter-value")).toContainText("0");

    // 2. Increment counter
    await page.click("button.increment");
    await expect(page.locator(".counter-value")).toContainText("1");

    // 3. Verify persistence
    await page.reload();
    await expect(page.locator(".counter-value")).toContainText("1");

    // 4. Increment multiple times
    for (let i = 0; i < 5; i++) {
      await page.click("button.increment");
    }
    await expect(page.locator(".counter-value")).toContainText("6");
  });

  test("error handling", async () => {
    // Stop backend
    await dockerCompose.pause("backend");

    // Try to increment
    await page.click("button.increment");

    // Verify error message displayed
    await expect(page.locator(".error-message")).toBeVisible();
    await expect(page.locator(".error-message")).toContainText("Server error");

    // Restart backend
    await dockerCompose.unpause("backend");

    // Try again - should work now
    await page.click("button.increment");
    await expect(page.locator(".counter-value")).toContainText("7");
  });
});
```

## 📖 Concepts Introduced

### **E2E Testing Patterns**

**User Journey Testing:**

- Test complete workflows from user perspective
- Verify business-critical paths work end-to-end
- Catch issues that unit/integration tests miss

**Browser Testing:**

- Test in real browsers (Chrome, Firefox, Safari, Edge)
- Verify cross-browser compatibility
- Catch browser-specific bugs

**Visual Regression:**

- Capture screenshots of UI
- Compare screenshots across builds
- Detect unintended visual changes

### **E2E Test Best Practices**

**Test Scope:**

- ✅ Focus on critical user workflows
- ✅ Test happy paths thoroughly
- ✅ Test common error scenarios
- ❌ Don't test edge cases covered by unit tests
- ❌ Don't duplicate integration test coverage

**Performance:**

- E2E tests are slow (seconds to minutes per test)
- Run them less frequently (nightly, on release branches)
- Keep test suite small (< 50 tests recommended)
- Use parallel execution when possible

**Test Data:**

- Use test databases with known state
- Reset data between test runs
- Use factories/fixtures for test data
- Avoid dependencies on production data

**CI Integration:**

- Run E2E tests after unit/integration tests pass
- Use separate job for E2E tests
- Provide clear reporting on failures
- Include screenshots/videos in failure reports

## 🔍 Reflection

✅ **Solved:** Complete user workflow validation through browser-based testing  
✅ **Skills:** Ability to write and maintain E2E tests  
✅ **Knowledge:** Understanding of when to use E2E vs other testing levels  
✅ **Foundation:** Comprehensive testing strategy (unit → integration → E2E)  
❌ **Limitation:** E2E tests are slow and require full application stack  
🔜 **Next:** Acceptance testing for business requirement validation
