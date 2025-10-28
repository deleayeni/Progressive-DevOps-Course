# 🔄 CI 0 — Basic Build Verification

## 🎯 Learning Goal

- Understand what Continuous Integration (CI) is and why it matters
- Set up your first GitHub Actions workflow
- Learn basic workflow structure and core concepts
- Verify your code builds automatically on every push
- Master the fundamental CI concepts that apply to any project

## ⚠️ Problem / Issue

- So far, everything runs locally and manually
- "It works on my machine" cannot be trusted without automation
- No way to validate code changes before they're merged
- Manual testing is error-prone and doesn't scale with team collaboration
- Broken code can reach production without anyone noticing

## 🧠 What You'll Do

### 1. **Create your first workflow**

The most basic CI pipeline just checks if your code compiles. This is your "hello world" of CI:

```yaml
name: CI0

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Go
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build .
```

**What this does:**

- Downloads your code (`checkout`)
- Installs Go automatically
- Tries to build your backend
- ✅ Green = code compiles
- ❌ Red = code is broken

### 2. **Add Flutter build verification**

Once the basic workflow works, extend it to verify both backend and frontend:

```yaml
name: CI0

on:
  push:
    branches: [main]

jobs:
  build-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: "1.22"
      - name: Build Backend
        run: |
          cd tests/test3-containerize-application/docker3/backend3
          go build -o main .

  build-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
      - name: Build Frontend
        run: |
          cd tests/test1-ui-backend/frontend1
          flutter build web
```

**Key improvement:** Now you have **two jobs running in parallel** - much faster!

### 3. **Add pull request triggers**

Make the pipeline run on both pushes and pull requests:

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

**Why this matters:** Now every PR gets validated before it can be merged.

## 📖 Concepts Introduced

### **What is Continuous Integration (CI)?**

**Simple definition:** CI is a robot that automatically checks your code every time you push changes.

**Why it matters:**

- **Catches bugs early** - Before they reach users
- **Prevents broken code** - From being merged to main
- **Saves time** - No more manual "does this work?" checking
- **Enables collaboration** - Teams can work together safely

**Real-world analogy:** Think of CI like a quality control inspector in a factory. Every product (code change) gets automatically inspected before it leaves the factory (gets merged).

### **GitHub Actions - Your CI Platform**

**What it is:** GitHub's built-in tool for running automated workflows.

**How it works:**

1. You write a YAML file (like a recipe)
2. GitHub reads the recipe
3. GitHub runs the steps automatically
4. You get a report (green ✅ or red ❌)

**Why GitHub Actions:**

- ✅ **Free** for public repositories
- ✅ **Built-in** - No external tools needed
- ✅ **Easy** - Just YAML files
- ✅ **Powerful** - Can do almost anything

### **Workflow Structure - The Foundation**

Every CI workflow has **three essential parts**:

```yaml
name: CI0 # 1. NAME - What to call it

on: # 2. TRIGGERS - When to run
  push:
    branches: [main]

jobs: # 3. JOBS - What to do
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

**Think of it like a recipe:**

- **Name** = Recipe title
- **Triggers** = When to cook (dinner time, special occasions)
- **Jobs** = What dishes to make (appetizer, main course, dessert)

### **Key Components Explained**

| Component    | Purpose                | Example               | Real-World Analogy   |
| ------------ | ---------------------- | --------------------- | -------------------- |
| **Workflow** | The entire YAML file   | `ci0.yml`             | Complete recipe book |
| **Job**      | A set of related steps | `build-backend`       | Making one dish      |
| **Step**     | A single command       | `go build`            | One cooking step     |
| **Runner**   | Virtual machine        | `ubuntu-latest`       | Kitchen with tools   |
| **Action**   | Reusable code          | `actions/checkout@v4` | Pre-made ingredient  |

### **Workflow Triggers - When CI Runs**

**Push triggers:**

```yaml
on:
  push:
    branches: [main] # Run when code is pushed to main
```

**Pull request triggers:**

```yaml
on:
  pull_request:
    branches: [main] # Run when PR is opened/updated
```

**Combined triggers:**

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main] # Run on both pushes AND PRs
```

**Why triggers matter:**

- **Push to main** = "Deploy this code"
- **Pull request** = "Check if this code is safe to merge"
- **Different triggers** = Different workflows for different purposes

### **Job Execution - How CI Works**

**Parallel execution:**

```yaml
jobs:
  build-backend: # ← These run at the same time
    runs-on: ubuntu-latest
  build-frontend: # ← These run at the same time
    runs-on: ubuntu-latest
```

**Timeline visualization:**

```
Time: 0s    5s    10s   15s   20s
Backend:  [=====build=====]
Frontend: [=====build=====]
Total:    20s (not 40s!)
```

**Key principles:**

- Jobs run **simultaneously** by default
- Each job gets its own **fresh virtual machine**
- If any step fails, the **entire job fails**
- Independent jobs **can't interfere** with each other

### **Common Actions - Pre-built Tools**

**actions/checkout@v4:**

- **What it does:** Downloads your repository code
- **Why you need it:** CI starts with empty machines
- **Think of it as:** "Get the ingredients from the pantry"

**actions/setup-go@v4:**

- **What it does:** Installs Go runtime
- **Why you need it:** CI machines don't have Go by default
- **Think of it as:** "Set up the cooking tools"

**subosito/flutter-action@v2:**

- **What it does:** Installs Flutter SDK
- **Why you need it:** CI machines don't have Flutter by default
- **Think of it as:** "Set up the baking tools"

### **Understanding the Build Process**

**What happens when you push code:**

1. **Trigger** - GitHub detects your push
2. **Checkout** - Downloads your code to a fresh machine
3. **Setup** - Installs required tools (Go, Flutter, etc.)
4. **Build** - Compiles your code
5. **Report** - Shows green ✅ or red ❌

**Why this matters:**

- **Fresh environment** - No "it works on my machine" issues
- **Consistent results** - Same environment every time
- **Automatic** - No human intervention needed
- **Fast feedback** - Know immediately if something's broken

### **CI vs Manual Testing**

| Manual Testing                             | CI Pipeline                |
| ------------------------------------------ | -------------------------- |
| ❌ Run tests manually                      | ✅ Run tests automatically |
| ❌ Easy to forget                          | ✅ Never forgets           |
| ❌ Different results on different machines | ✅ Consistent results      |
| ❌ Time-consuming                          | ✅ Fast and efficient      |
| ❌ Error-prone                             | ✅ Reliable                |
| ❌ Doesn't scale with teams                | ✅ Scales perfectly        |

### **Common CI Patterns**

**Build verification pattern:**

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Install dependencies
    run: npm install # or go mod download, etc.
  - name: Build
    run: npm run build # or go build, etc.
```

**Multi-language pattern:**

```yaml
jobs:
  backend:
    steps:
      - uses: actions/setup-go@v4
      - run: go build .
  frontend:
    steps:
      - uses: subosito/flutter-action@v2
      - run: flutter build web
```

**Conditional execution pattern:**

```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main' # Only on main branch
    steps:
      - run: echo "Deploying..."
```

## 🔍 Reflection

- ✅ **Solved:** Code changes are automatically validated for compilation
- ✅ **Automation:** No more manual "it works on my machine" validation
- ✅ **Foundation:** Basic CI pipeline that catches build failures
- ✅ **Learning:** Understanding of core CI concepts and workflow structure
- ✅ **Scalability:** Pipeline works for both individual and team development
- ❌ **Limitation:** No automated testing, no Docker builds, no security scanning
- 🔜 **Next:** Add automated testing in CI 1

## 🚀 Quick Start Checklist

**To get CI0 working:**

1. ✅ **Create workflow file** - `.github/workflows/ci0.yml` in repository root
2. ✅ **Add basic workflow** - Start with simple Go build
3. ✅ **Test it works** - Push to main, check Actions tab
4. ✅ **Extend gradually** - Add Flutter build, then PR triggers
5. ✅ **Understand concepts** - Workflow structure, jobs, steps, actions

**Success indicators:**

- Green checkmarks in GitHub Actions
- Workflow runs on every push
- Build failures show red X
- No manual testing needed

## 💡 Pro Tips

**Start simple:**

- Begin with just one job (backend build)
- Add complexity gradually
- Test each change before moving on

**Common mistakes to avoid:**

- ❌ Putting workflow file in wrong location
- ❌ Forgetting to commit the workflow file
- ❌ Using wrong paths in `run:` commands
- ❌ Not checking the Actions tab for results

**Debugging workflow issues:**

- Check Actions tab for error messages
- Verify file paths are correct
- Ensure dependencies are installed
- Test commands locally first
