# 🧪 Testing 3 — Acceptance Testing

## 🎯 Learning Goal

- Understand what acceptance testing is and how it differs from technical tests
- Learn Behavior-Driven Development (BDD) patterns and Given-When-Then format
- Write acceptance tests that validate business requirements
- Communicate testing results in stakeholder-friendly language
- Integrate acceptance tests into CI/CD pipelines

## ⚠️ Problem / Issue

- Technical tests (unit, integration, E2E) verify code works, but not if it meets business requirements
- Stakeholders need to verify features work as expected from business perspective
- Requirement validation is often manual and inconsistent
- No shared language between developers and business stakeholders
- Features can be technically correct but not deliver business value

## 🧠 What You'll Do

### 🧠 Why Acceptance Testing Matters

In Continuous Delivery, **acceptance tests are executable specifications** — automated checks that prove the system meets business goals.  
They are written *before development* as a collaboration between developers, testers, and stakeholders, forming the **definition of done** for every story.

Unlike technical tests that prove the code works, acceptance tests prove the **feature delivers real value** when deployed in a realistic environment.

### 1. **Understand Acceptance Testing**

**Acceptance Testing vs Technical Testing:**

| Aspect        | Technical Tests (Unit/Integration/E2E)     | **Acceptance Tests**                             |
| ------------- | ------------------------------------------ | ------------------------------------------------ |
| **Focus**     | Code correctness                           | Business value                                   |
| **Questions** | Does the code work?                        | Does it meet requirements?                       |
| **Language**  | Technical (code, APIs)                     | Business (features, scenarios)                   |
| **Audience**  | Developers                                 | Stakeholders                                     |
| **Examples**  | "Handler returns 200", "DB write succeeds" | "User can increment counter", "Counter persists" |

**The 4 Levels of Testing:**

```text
Level 1: Unit Tests       → Does this function work?
Level 2: Integration      → Do these components work together?
Level 3: E2E Tests        → Does the complete app work for users?
Level 4: Acceptance Tests → Does this deliver business value? ✅
```

### 2. **Behavior-Driven Development (BDD)**

#### BDD Format: Given-When-Then

BDD uses plain English to describe behavior, making tests understandable to non-technical stakeholders.

```text
Given [initial state]
When [action is performed]
Then [expected outcome]
```

#### Example: Counter Acceptance Test

```gherkin
Feature: Counter persistence

  Scenario: User increments counter
    Given the counter application is running
    And the counter value is currently 0
    When the user clicks the increment button
    Then the counter value should be 1
    And the value should persist after page refresh

  Scenario: User increments counter multiple times
    Given the counter application is running
    When the user clicks the increment button 5 times
    Then the counter value should be 5
    And the database should store the value 5
```

### 3. **Common Tools and Frameworks for Acceptance Testing**

**For Web / API Projects:**

- **Cucumber (JavaScript, Java, Python, Ruby)** – Standard BDD framework using Gherkin syntax  
- **Behave (Python)** – Lightweight Gherkin-based framework for API or web testing  
- **SpecFlow (.NET)** – Cucumber-style testing for C# ecosystems  
- **JBehave (Java)** – Classic BDD tool integrated with JUnit  
- **Robot Framework** – Keyword-driven testing framework with human-readable syntax  
- **Playwright / Cypress + Cucumber** – Combine browser automation with BDD scenarios  

**For Mobile / Cross-Platform:**

- **Appium** – UI automation for Android/iOS, supports Gherkin integration  
- **Flutter Integration Test** – Flutter's built-in BDD-style testing package  

**For Reporting and Visualization:**

- **Allure Reports** or **Cucumber HTML Reports** – Generate stakeholder-friendly dashboards  
- **TestRail / Xray (Jira)** – Track acceptance criteria coverage and test results

### 4. **Writing Acceptance Tests**

#### Using Cucumber (BDD Framework)

##### Step 1: Write Feature File

```gherkin
# features/counter.feature
Feature: Counter Application

  As a user
  I want to increment a counter
  So that I can track my progress

  Scenario: Basic counter increment
    Given I open the counter application
    When I increment the counter
    Then the counter should show 1

  Scenario: Counter persists across sessions
    Given I have incremented the counter to 5
    When I close and reopen the application
    Then the counter should still show 5
```

##### Step 2: Implement Step Definitions

```javascript
// features/step_definitions/counter_steps.js
const { Given, When, Then } = require("@cucumber/cucumber");
const { expect } = require("expect");

let counterValue = 0;

Given("I open the counter application", async function () {
  await this.page.goto("http://localhost:3000");
  counterValue = 0;
});

When("I increment the counter", async function () {
  await this.page.click("button.increment");
  counterValue++;
});

Then("the counter should show {int}", async function (expectedValue) {
  const actualValue = await this.page.textContent(".counter-value");
  expect(parseInt(actualValue)).toBe(expectedValue);
});

Given("I have incremented the counter to {int}", async function (value) {
  for (let i = 0; i < value; i++) {
    await this.page.click("button.increment");
  }
});

When("I close and reopen the application", async function () {
  await this.page.reload();
});
```

### 5. **Acceptance Criteria Documentation**

#### User Story with Acceptance Criteria

```markdown
## User Story: Counter Persistence

**As a** user  
**I want** the counter to persist between sessions  
**So that** my progress is not lost when I close the browser

### Acceptance Criteria

1. **Given** the counter value is 7  
   **When** the user closes and reopens the application  
   **Then** the counter should still display 7

2. **Given** the user has incremented to a high value (e.g., 100)  
   **When** the user refreshes the page  
   **Then** the counter should remain at 100

3. **Given** the database is unavailable  
   **When** the user tries to increment the counter  
   **Then** an error message should be displayed  
   **And** the last known value should be shown

### Test Results

✅ AC1: Counter persists across sessions  
✅ AC2: Counter persists after refresh  
⚠️ AC3: Error handling not yet implemented
```

### 6. **CI Integration of Acceptance Tests**

#### GitHub Actions Workflow

```yaml
name: Acceptance Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  acceptance-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up application stack
        run: |
          docker compose up -d

      - name: Wait for services
        run: |
          timeout 60 bash -c 'until curl -f http://localhost:8080/counter; do sleep 2; done'

      - name: Run acceptance tests
        run: |
          npm install
          npm run test:acceptance

      - name: Generate acceptance report
        run: |
          npm run test:acceptance -- --format json:reports/acceptance.json

      - name: Publish acceptance report
        uses: actions/upload-artifact@v3
        with:
          name: acceptance-report
          path: reports/acceptance.json

      - name: Cleanup
        if: always()
        run: docker compose down
```

## 📖 Concepts Introduced

### **Acceptance Testing Patterns**

**BDD (Behavior-Driven Development):**

- Tests written in natural language
- Given-When-Then format
- Understandable to non-technical stakeholders
- Links code to business requirements

**Acceptance Criteria:**

- Specific, testable conditions
- Definition of "done" for features
- Stakeholder-verifiable
- Clear pass/fail criteria

**User Stories:**

- "As a [role], I want [goal], so that [benefit]"
- Describe features from user perspective
- Include acceptance criteria
- Prioritize based on business value

### **Acceptance Test Best Practices**

**Language:**

- ✅ Use business terminology
- ✅ Avoid technical jargon
- ✅ Write from user perspective
- ✅ Make tests readable by non-developers

**Scope:**

- Focus on business-critical features
- Test user-facing functionality
- Verify requirements are met
- Don't duplicate technical test coverage

**Stakeholder Involvement:**

- Review feature files with business team
- Get approval on acceptance criteria
- Include stakeholders in test planning
- Report results in business language

**CI Integration:**

- Run acceptance tests on main branch
- Block releases if acceptance tests fail
- Generate stakeholder-friendly reports
- Track test coverage of requirements

### 📘 Insights from *Continuous Delivery*

The book emphasizes:

- **Write acceptance tests before development begins** — they drive design and clarify expectations early.  
- **Collaborate with users, testers, and developers** to define scenarios together.  
- **Automate the happy path** for every user story first — this gives the fastest value and stability.  
- **Run acceptance tests in a production-like environment** so deployment issues appear early.  
- **Keep tests stable and meaningful** — avoid overly detailed UI interactions that change frequently.  
- **Treat acceptance tests as part of your regression suite**, running automatically in CI/CD pipelines.  
- **When tests fail, fix either the code or the test immediately** — never ignore broken acceptance tests.

### ⚠️ Avoid Over-Reliance on UI Testing

*Continuous Delivery* warns that testing business logic through the user interface is fragile and expensive.  
Small UI changes can break many tests, even when functionality is correct.

**Recommended approach:**

- **Focus acceptance tests on behavior and outcomes**, not UI details.  
- **Automate interactions through the API layer** or an abstraction layer instead of raw UI selectors.  
- **Keep only a few automated UI acceptance tests** for key navigation or visual validation.  
- **Use manual exploratory testing** for usability and aesthetics.  

> "Test business logic below the UI; test the UI only to confirm that it works."

## 🔍 Reflection

✅ **Solved:** Business requirement validation through stakeholder-friendly tests  
✅ **Skills:** Ability to write BDD-style acceptance tests  
✅ **Knowledge:** Understanding of 4-level testing pyramid (unit → integration → E2E → acceptance)  
✅ **Foundation:** Complete testing strategy covering technical and business validation  
❌ **Limitation:** Acceptance tests often run manually or infrequently  
🔜 **Next:** Complete CI pipeline with all testing levels integrated

## 📊 Complete Testing Pyramid

```text
               /\
              /  \     Acceptance Tests
             /----\    - Business requirements
            /      \   - Stakeholder validation
           /--------\
          /          \ E2E Tests
         /------------\  - Complete user workflows
        /              \ - Browser testing
       /----------------\
      /                  \ Integration Tests
     /--------------------\  - Component interactions
    /                      \ - API/Database testing
   /------------------------\
  /                          \ Unit Tests
 /============================\  - Function testing
                                  - Fast feedback
```

**Testing Strategy Summary:**

1. **Unit Tests** (Fastest, Most Coverage)

   - Test individual functions
   - Run on every commit
   - Fast feedback loop

2. **Integration Tests** (Fast, Good Coverage)

   - Test component interactions
   - Run on every commit
   - Verify service integration

3. **E2E Tests** (Slow, Critical Coverage)

   - Test complete workflows
   - Run nightly or on release
   - Verify user experience

4. **Acceptance Tests** (Business Validation)
   - Test business requirements
   - Run on releases
   - Validate stakeholder needs

## 🚀 Acceptance Tests in the Continuous Delivery Pipeline

In the deployment pipeline, automated acceptance tests act as the **release gate**:

- They confirm that new builds meet all defined business requirements.  
- They run automatically after integration and E2E stages.  
- A passing acceptance suite means the product is **potentially releasable** at any time.  

If acceptance tests fail, the pipeline stops until the issue is fixed — ensuring that only business-verified code moves forward.
