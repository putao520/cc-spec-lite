# Common Coding Standards - CODING-STANDARDS-COMMON

**Scope**: All programming tasks (backend, frontend, system, database, etc.)

---

## 🚨 Core Iron Rules (Violation Results in Failure)

### Iron Rule 1: SPEC is the Only Source of Truth (SSOT)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  SPEC Authority Hierarchy (Absolutely Non-Negotiable)                  │
│                                                                         │
│  SPEC > Task Description > AI Understanding > User Oral Requirements  │
│                                                                         │
│  ❌ Forbidden: Starting to code without reading SPEC                   │
│  ❌ Forbidden: Believing task description is more accurate than SPEC   │
│  ❌ Forbidden: Deviating from SPEC because "I think X is better than Y"│
│  ❌ Forbidden: "SPEC is too complex, I'll simplify it"              │
│  ❌ Forbidden: "SPEC doesn't say it, but I think it should be added"   │
│  ❌ Forbidden: Implementing only partial SPEC requirements           │
│  ❌ Forbidden: Using technology stacks not specified in SPEC          │
│                                                                         │
│  ✅ Required: Complete reading of relevant SPEC documents before coding│
│  ✅ Required: Understand specific requirements and constraints for each SPEC ID │
│  ✅ Required: Code implementation 100% consistent with SPEC            │
│  ✅ Required: Report SPEC issues promptly instead of making decisions │
│  ✅ Required: Change code, not SPEC, when there's a conflict         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Iron Rule 2: Smart Reuse and Destroy-Rebuild

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Phase 1: SPEC-Guided Deep Analysis (Reuse Decision)                 │
│  ─────────────────────────────────────────────────────────────────────  │
│  1. Comprehensive scan of existing modules:                         │
│     - Common modules: utilities, algorithms, data structures, common components │
│     - Infrastructure modules: configuration management, logging, error handling, communication protocols │
│     - Domain modules: business logic, data processing, computation modules │
│                                                                         │
│  2. SPEC-based precise evaluation of match degree:                  │
│     - Complete match: existing module fully meets SPEC requirements  │
│     - Partial match: existing module partially meets, needs extension or modification │
│     - No match: existing module cannot meet requirements or violates SPEC constraints │
│                                                                         │
│  3. Reuse decision:                                                   │
│     ✅ Complete match → Direct reuse, no re-development needed       │
│     ❌ Partial/No match → Execute destroy-rebuild                     │
│                                                                         │
│  ⚠️ Key: Reuse based on SPEC functional completeness, not code similarity │
│  ⚠️ Key: Partial match equals no match, must destroy-rebuild        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│  Phase 2: SPEC-Driven Complete Rewrite (Destroy-Rebuild)             │
│  ─────────────────────────────────────────────────────────────────────  │
│  Definition:                                                           │
│  - Not modification: not modifying or extending existing code         │
│  - Not incremental: not gradually adding features or fixes            │
│  - Not refactoring: not adjusting existing code structure            │
│  - But complete rewrite: delete all related code, redesign and implement │
│                                                                         │
│  Execution:                                                            │
│  1. Delete all old code that violates SPEC                             │
│  2. Design and implement new implementation from scratch that fully complies with SPEC │
│  3. Each SPEC ID must have clear, fully SPEC-compliant implementation   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Iron Rule 3: Prohibitive Incremental Development

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Absolutely Prohibited Incremental Development Behaviors             │
│                                                                         │
│  ❌ "Keep old implementation, add new features"                      │
│  ❌ "Compatibility code to support old interfaces"                  │
│  ❌ "Migrate code, gradually convert"                                │
│  ❌ "Extend existing class, add new methods"                          │
│  ❌ "Modify existing function, add parameters"                        │
│  ❌ "Keep old logic for compatibility"                                │
│  ❌ "Make rough version first, improve later"                        │
│  ❌ "Add in subsequent iterations"                                   │
│                                                                         │
│  Why destroy-rebuild is necessary:                                     │
│  1. Avoid technical debt: incremental modifications accumulate historical baggage │
│  2. Ensure code quality: rewrite ensures compliance with latest standards │
│  3. Simplify thinking process: no need to consider compatibility, focus on target implementation │
│  4. Improve development efficiency: faster and more reliable than complex incremental modifications │
└─────────────────────────────────────────────────────────────────────────┘
```

### Iron Rule 4: Context7 Research First

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Must research mature libraries before new feature development        │
│                                                                         │
│  ✅ Required use cases:                                              │
│     - Technology selection before new feature development              │
│     - Introducing new libraries or using library APIs                │
│     - Referencing best practices before code generation               │
│     - Comparing multiple library choices                              │
│                                                                         │
│  ❌ Forbidden:                                                        │
│     - Implementing common functions from scratch without research      │
│     - Using outdated library versions or APIs                         │
│     - Writing library usage code from memory                          │
│     - Reinventing the wheel                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Core Design Principles

### SOLID Principles

**Single Responsibility Principle (SRP)**:
- ✅ A module/class/function is responsible for only one thing
- ✅ Only one reason to modify
- ❌ Avoid "God classes" or "God functions"

**Open/Closed Principle (OCP)**:
- ✅ Open for extension, closed for modification
- ✅ Use interfaces, abstract classes, polymorphism for extension

**Liskov Substitution Principle (LSP)**:
- ✅ Subclasses can be used instead of parent classes
- ✅ Subclasses don't change parent class behavior contracts

**Interface Segregation Principle (ISP)**:
- ✅ Use multiple specific interfaces instead of single general interfaces
- ❌ Avoid "fat interfaces"

**Dependency Inversion Principle (DIP)**:
- ✅ Depend on abstractions, not concrete implementations
- ✅ Use Dependency Injection

### Other Core Principles

**DRY (Don't Repeat Yourself)**:
- ✅ Extract reusable code to functions/classes/modules
- ❌ Avoid copy-pasting code

**KISS (Keep It Simple, Stupid)**:
- ✅ Prefer simple and direct solutions
- ✅ Avoid over-engineering and unnecessary complexity

---

## 📝 Naming Conventions

### Variables and Functions
- **camelCase**: `userName`, `getUserById()`, `isValid`
- Use meaningful names (avoid `a`, `tmp`, `data`)
- Boolean values use `is`/`has`/`should` prefix

### Classes and Components
- **PascalCase**: `UserService`, `DatabaseConnection`

### Constants
- **UPPER_SNAKE_CASE**: `MAX_RETRY_COUNT`, `API_BASE_URL`

### File Names
- **kebab-case**: `user-service.ts`, `database-config.js`

---

## 🏗️ Code Structure Standards

| Metric | Limit | Handling Approach |
|--------|-------|-------------------|
| File Size | ≤300 lines | Split into multiple modules |
| Function Size | ≤50 lines | Split into multiple small functions |
| Nesting Depth | ≤3 levels | Early return/extract function |
| Cyclomatic Complexity | ≤10 | Strategy pattern/lookup table |
| Parameter Count | ≤5 | Use object for parameters |

---

## 🔒 Code Quality Requirements (Zero Tolerance)

### ❌ Strictly Prohibited

**Placeholders and Incomplete Code**:
- ❌ `TODO` / `FIXME` comments
- ❌ `stub` functions or empty implementations
- ❌ Commented out code
- ❌ `console.log` debug statements (production code)

**Incomplete Implementation**:
- ❌ Code missing error handling
- ❌ Public interfaces missing input validation
- ❌ Unreleased resources

### ✅ Mandatory Requirements

**Error Handling**:
- ✅ All potentially failing operations must have error handling
- ✅ Error messages are clear and actionable
- ✅ Log errors (including context information)

**Input Validation**:
- ✅ Validate all external inputs
- ✅ Type checking and boundary checks
- ✅ Reject invalid inputs and return clear errors

**Resource Management**:
- ✅ Timely close database connections, file handles, network connections
- ✅ Use RAII, defer, with/using for automatic resource management

**Type Safety**:
- ✅ Avoid `any` or unsafe type casts
- ✅ Use generics to improve type safety

---

## 🛡️ Security Requirements

### Input Validation
- ✅ Whitelist validation preferred over blacklist
- ✅ Length, format, type checking

### SQL Injection Protection
- ✅ Use parameterized queries or ORM
- ❌ Prohibit string concatenation SQL

### XSS Protection
- ✅ Output encoding (HTML, JavaScript, URL)
- ✅ Set CSP (Content Security Policy)

### Authentication and Authorization
- ✅ Check permissions before performing operations
- ✅ Principle of least privilege

### Sensitive Data
- ✅ Encrypt passwords, keys, tokens
- ❌ Don't log sensitive information

---

## ⚡ Performance Requirements

### Algorithm Complexity
- ✅ Avoid O(n²) and above complexity (on large datasets)
- ✅ Use caching to reduce repeated calculations

### Database Optimization
- ✅ Use indexes to speed up queries
- ✅ Avoid N+1 query problems
- ✅ Paginate large dataset queries

### Asynchronous and Concurrent
- ✅ Use async processing for I/O operations
- ✅ Avoid blocking main thread
- ✅ Pay attention to concurrency safety

---

## 🔍 Code Review Requirements

### Review Checklist

**SPEC Consistency**:
- [ ] Code implementation 100% consistent with SPEC
- [ ] Each SPEC ID has corresponding implementation
- [ ] No unauthorized additions beyond SPEC

**Quality Checks**:
- [ ] No TODO/FIXME/stub
- [ ] Complete error handling
- [ ] Complete input validation
- [ ] Resources correctly released

**Architecture Checks**:
- [ ] Follow SOLID principles
- [ ] No duplicate code
- [ ] Clear module boundaries

---

## ✅ Development Checklist

### Before Development
- [ ] Completely read relevant SPEC documents
- [ ] Confirm specific requirements for each SPEC ID
- [ ] Scan existing code, evaluate reuse possibilities
- [ ] Context7 research on technical solutions

### During Development
- [ ] Follow naming conventions
- [ ] Keep code simple (KISS)
- [ ] Avoid duplicate code (DRY)
- [ ] Implement all SPEC requirements (complete at once)
- [ ] Complete error handling
- [ ] Input validation and security checks

### After Development
- [ ] Verify SPEC implementation completeness item by item
- [ ] Code review
- [ ] No TODO/FIXME/placeholders

---

**Core Philosophy**:
- SPEC is the only source of truth, code must 100% comply with SPEC
- Partial match equals no match, must destroy-rebuild
- Prohibit any form of incremental development
- Quality over speed, correctness over speed
