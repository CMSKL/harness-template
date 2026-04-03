# Harness Template

<p align="center">
  <strong>Make AI Agent Your Reliable Development Partner</strong>
</p>

<p align="center">
  <a href="./README.md">中文</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#core-mechanisms">Core Mechanisms</a> •
  <a href="#full-guide">Full Guide</a> •
  <a href="#faq">FAQ</a>
</p>

---

## Why Do You Need Harness?

When developing with AI, have you encountered these problems?

| Problem | Typical Scenario |
|---------|------------------|
| 🤷 **Context Loss** | Features built yesterday are completely forgotten in today's new session |
| 🎯 **Unclear Completion Standards** | Agent says "it's done" but it doesn't actually run |
| 📝 **Verbal Rules Only** | Having to remind every time: "remember to write tests", "don't forget to run lint" |
| 🔄 **Doing Too Much at Once** | One session modifies 20 files, none of them usable |
| 📉 **Declining Quality** | Project gets messier over time, technical debt accumulates |

**Harness is an engineering framework to solve these problems.**

It standardizes, documents, and automates "how to make AI work properly". Instead of verbal instructions every time, write the rules in files so AI can see and follow them every time.

---

## What Is This?

Harness Template is a **technology-stack-agnostic engineering skeleton**. Whether you use Node.js, Python, Go, or other languages, you can use this framework.

### Design Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                     The Four "-ations"                      │
├─────────────────────────────────────────────────────────────┤
│  Rule Documentation   →  Don't say verbally, write in       │
│                          CLAUDE.md                          │
│  Task List-ification  →  Break into list in features.json   │
│  Progress Visualization → Check PROGRESS.md for status      │
│  Verification Automation → Run commands, not "feelings"     │
└─────────────────────────────────────────────────────────────┘
```

### How It Works

```
Your Requirements
       │
       ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Feature List│ →   │ AI Develops │ →   │ Verification│
│ (features)  │     │             │     │ (passing)   │
│             │     │ One at a    │     │             │
│ • User Reg  │     │ time, then  │     │ Truly done  │
│ • User Login│     │ verify      │     │             │
│ • Create    │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
       ↑                                      │
       └────────── New session continues ─────┘
```

---

## Core Mechanisms

### 1. Feature List Driven (features.json)

Each feature must have:

```json
{
  "id": "F01",
  "behavior": "User can register an account",
  "verification": "curl -X POST http://localhost:3000/api/register ...",
  "state": "not_started"
}
```

- **behavior**: Describe feature from user perspective
- **verification**: Executable verification command
- **state**: not_started → active → passing

**WIP=1**: Only one feature can be active at any time.

### 2. Three-Level Verification

Code must pass three checkpoints from "written" to "completed":

```
Level 1: Static Checks
         make lint && make typecheck
                  ↓
Level 2: Test Verification
         make test
                  ↓
Level 3: End-to-End Verification
         Feature-specific verification command
                  ↓
         Mark as passing (truly completed)
```

### 3. Session Workflow

**At the start of each session, AI must:**
1. Read `CLAUDE.md` → Understand what the project is
2. Read `PROGRESS.md` → Understand current progress
3. Read `features.json` → Understand remaining features
4. Run `make check` → Confirm environment is healthy
5. Start from "Next Steps" in PROGRESS.md

**At the end of each session, AI must:**
1. Update `PROGRESS.md` → Record completed work
2. Run `make check` → Confirm everything is fine
3. Run `check-clean-state.sh` → Check no leftovers
4. `git commit` → Commit all changes

---

## Quick Start

### Step 1: Copy the Template

```bash
# Method 1: Direct download
git clone https://github.com/CMSKL/harness-template.git my-project
cd my-project
rm -rf .git
git init

# Method 2: Use as template (GitHub)
# Click "Use this template" button on the repository page
```

### Step 2: Fill in Core Configuration (15 minutes)

**1. CLAUDE.md** - Project Manual

```markdown
## Project Overview
- **Project Name**: MyTodo
- **Project Type**: Web Backend API
- **One-line Description**: A REST API supporting user registration, login, and todo management
- **Tech Stack**: Node.js 20 + Express + SQLite

## Quick Start
make setup    # Install dependencies
make dev      # Start development server
make test     # Run tests
make check    # Full verification

## Hard Constraints (Cannot be violated)
1. All APIs must return JSON
2. No raw SQL, must use ORM
3. All routes must have tests
```

**2. Makefile** - Command Mapping

```makefile
setup:
	npm install

dev:
	npm run dev

test:
	npm test

lint:
	npx eslint src/

check: lint test
	@echo "All checks passed"
```

**3. features.json** - Feature List

```json
{
  "schema_version": "1.0",
  "project": "MyTodo",
  "rules": { "wip_limit": 1 },
  "features": [
    {
      "id": "F01",
      "behavior": "User can register an account",
      "verification": "curl -X POST http://localhost:3000/api/register -d '{"email":"test@test.com","password":"123456"}'",
      "state": "not_started",
      "priority": 1
    }
  ]
}
```

### Step 3: Start Using

Tell your AI Agent:

```
Please help me initialize this project and implement feature F01.

Steps:
1. Read CLAUDE.md to understand the project
2. Run make setup to install dependencies
3. Change F01 state to active in features.json
4. Implement the registration feature (including tests)
5. Run verification command to confirm it passes
6. Change F01 state to passing
7. Update PROGRESS.md
8. git commit
```

---

## Full Guide

For detailed instructions, workflow diagrams, and troubleshooting, see [GUIDE.md](./GUIDE.md).

Includes:
- Detailed concept diagrams
- Complete workflow
- Real project examples
- FAQ
- Advanced usage

---

## File Structure

```
harness-template/
│
├── 📋 CLAUDE.md              # AI's "onboarding manual"
├── 📊 PROGRESS.md            # Work progress record
├── 📝 DECISIONS.md           # Design decision log
├── ⭐ features.json          # Feature list (core)
├── 🎯 QUALITY.md             # Module quality scoring
├── 🔧 Makefile               # Unified command entry
├── 📖 GUIDE.md               # Detailed usage guide
├── LICENSE                   # MIT License
│
├── docs/                     # Topic documents
│   ├── architecture.md       # Architecture design
│   ├── api-patterns.md       # API specifications
│   ├── database-rules.md     # Database rules
│   ├── testing-standards.md  # Testing standards (with arch boundary examples)
│   ├── constraints.md        # Hard constraints list
│   ├── sprint-contract-template.md
│   └── handoff-template.md
│
└── scripts/                  # Automation scripts
    ├── session-start.sh      # Session start workflow
    ├── session-end.sh        # Session end workflow
    └── check-clean-state.sh  # Clean state check (5 dimensions)
```

---

## Use Cases

### 👤 Individual Developers
- Let AI assist in development
- New sessions can seamlessly continue
- Maintain code quality over time

### 👥 Team Collaboration
- Unified AI development standards
- Clear work handoff
- Consistent quality standards

### 📦 Complex Projects
- Break large features into small tasks
- Dependency management
- Complete across multiple sessions

---

## FAQ

### Q: What tech stacks does this template support?

**A:** Any tech stack. It's a language-agnostic engineering framework; just configure the corresponding Makefile commands.

### Q: What if I don't know how to write shell scripts?

**A:** Just ask AI: "Help me write a script to check XX". Provide the checking rules, and AI will generate it for you.

### Q: How do I determine feature granularity?

**A:** 
- ✅ Good: "User can register"
- ❌ Too big: "Implement user system"
- ❌ Too small: "Create User model name field"

A size that can be completed in one session is best.

### Q: How do I know if my Harness is good enough?

**A:** Open a fresh session without any verbal instructions, and ask AI five questions:
1. What is this project?
2. How do I start it?
3. How do I verify the code is correct?
4. What features need to be done?
5. What should I do next?

All correct =合格 (qualified).

---

## Evolution & Contributing

### Current Status

This is a **basic skeleton** containing core mechanisms:
- Feature list system
- Three-level verification
- Session workflow
- Quality tracking

### Continuous Evolution

**This template will be continuously optimized based on real-world usage.**

Every problem encountered makes this template better:

1. **Record Issues** → Problems when using the template
2. **Extract Rules** → Generalize solutions
3. **Update Template** → Merge improvements

### Welcome Contributions

- Submit Issues describing your use case and problems
- Share your improvement solutions
- Contribute generic scripts or configurations

---

## Theoretical Foundation

This template's design references the following engineering practices:

- [OpenAI: Harness Engineering](https://openai.com/index/harness-engineering/)
- [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

> **Core Principle: AI Agent performance doesn't depend on model capability, but on engineering infrastructure.**

---

## License

[MIT](LICENSE) © 2026 CMSKL

---

## Support This Project

If this template helps you, please give it a ⭐ Star!

Your support motivates me to continuously improve this template. Every Star means one more person finds this framework valuable, and encourages me to:

- Continuously improve based on real-world feedback
- Add more practical examples and documentation
- Share pitfalls and solutions from actual usage

<p align="center">
  <a href="https://github.com/CMSKL/harness-template">
    <img src="https://img.shields.io/github/stars/CMSKL/harness-template?style=social" alt="GitHub Stars">
  </a>
</p>

---

<p align="center">
  <strong>Start using Harness, make AI your reliable development partner</strong>
</p>
