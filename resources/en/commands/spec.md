---
description: SPEC Requirement Description Mode - Proactively enter SPEC refinement and trigger programmer execution
argument-hint: <requirement description>
---

# /spec Command

## Core Responsibilities

**Proactively enter SPEC requirement description mode, automatically trigger programmer execution through complete SPEC**

- ✅ Guide users to describe requirements
- ✅ Interactively refine SPEC (requirements/architecture/data/API)
- ✅ SPEC completeness check
- ✅ Automatically call /programmer for execution

---

## Design Goals

**Solve model attention focus issues**

- ❌ **Problem**: Model tends to deviate from SPEC-driven workflow in long conversations
- ✅ **Solution**: Explicitly enter "SPEC requirement description mode" to force focus on SPEC refinement
- ✅ **Mechanism**: Seamlessly trigger programmer execution after SPEC completion

---

## Execution Flow

### Phase 1: Requirement Description (Interactive)

**Step 1: Open Requirement Collection**

```markdown
# 🎯 SPEC Requirement Description Mode

Welcome to SPEC-driven development!

Please describe the feature you want to implement:
[Wait for user free-form input...]

**Tips**:
- Can be a feature requirement: "Implement user login"
- Can be an architecture adjustment: "Switch from MySQL to PostgreSQL"
- Can be a bug fix: "Fix Token error in login"
- Can be a new feature: "Add image upload functionality"
```

**Step 2: AI Analysis + SPEC Refinement Guidance**

Based on user description, identify SPEC dimensions that need refinement:

| User Description Type | Identified SPEC Gaps | Guidance Action |
|----------------------|---------------------|-----------------|
| New feature | Missing REQ-XXX | Guide to 01-REQUIREMENTS.md |
| Feature adjustment | REQ-XXX acceptance criteria unclear | Guide to refine acceptance criteria |
| Data related | Missing DATA-XXX | Guide to 03-DATA-STRUCTURE.md |
| API related | Missing API-XXX | Guide to 04-API-DESIGN.md |
| Architecture adjustment | Missing ARCH-XXX | Guide to 02-ARCHITECTURE.md |

**Interactive Inquiry Example**:

```markdown
Based on your description, I need to refine the following SPEC:

**1. Requirement Definition (REQ-XXX)**
- Feature name: [Derived feature name]
- Core logic: [Derived logic]
- Acceptance criteria: [Need to supplement]

**Please supplement acceptance criteria**:
[User input...]

**2. Data Model (DATA-XXX)**
- Entities involved: [Derived entities]
- Field design: [Need to supplement]

**Please describe data structure**:
[User input...]

**3. API Design (API-XXX)**
- Endpoint: [Derived path]
- Request/Response: [Need to supplement]

**Please describe interface format**:
[User input...]
```

**Key Principles**:
- ✅ **Dynamically question** based on user description
- ✅ Each question is **open-ended text input**
- ❌ Don't use option lists
- ❌ Don't ask irrelevant questions

---

### Phase 2: Call /architect to Update SPEC

**After collecting sufficient information, display SPEC summary**:

```markdown
## 📋 SPEC Summary

### Requirement Definition
**REQ-XXX: [Feature Name]**
- Description: [User description]
- Acceptance criteria:
  - [Criterion 1]
  - [Criterion 2]

### Data Model
**DATA-XXX: [Entity Name]**
- Fields:
  - [Field 1]: [Type] - [Description]
  - [Field 2]: [Type] - [Description]

### API Design
**API-XXX: [Interface Name]**
- Endpoint: POST /api/xxx
- Request: [Format]
- Response: [Format]

---

**Is this SPEC accurate?**
[✅ Accurate, update SPEC and start development]
[✏️ Needs correction]
```

After user confirmation, call /architect:

```markdown
/architect

# Update SPEC Request

**Requirement Description**:
[Complete user description]

**Collected SPEC Information**:
[Organized SPEC structure]

**Please Execute**:
1. Assign REQ-XXX, DATA-XXX, API-XXX
2. Update corresponding SPEC files (01/03/04)
3. Ensure format complies with standards
```

---

### Phase 3: Automatically Call /programmer for Execution

**After SPEC update completion, seamlessly transition to programmer**:

```markdown
✅ SPEC Updated!

**Updated Files**:
- SPEC/01-REQUIREMENTS.md [REQ-XXX]
- SPEC/03-DATA-STRUCTURE.md [DATA-XXX]
- SPEC/04-API-DESIGN.md [API-XXX]

---

**Start implementation now?**
[✅ Start implementation (automatically call /programmer)]
[❌ Don't implement yet, only update SPEC]
```

If user chooses "Start implementation", automatically call:

```markdown
/programmer

# Implement Feature Based on SPEC

**Associated SPEC**:
- REQ-XXX
- DATA-XXX
- API-XXX

**Please execute following standard process**:
1. Analyze existing code
2. Create plan
3. Present plan for confirmation
4. Call AI CLI for implementation
5. Code review
6. Commit and update SPEC
```

---

## Interaction Modes

### Mode 1: Complete Workflow (SPEC → Code)

```
User inputs requirement
    ↓
/spec guides description
    ↓
Interactively refine SPEC
    ↓
Call /architect to update SPEC
    ↓
Automatically call /programmer for implementation
    ↓
Complete
```

### Mode 2: Update SPEC Only

```
User inputs requirement
    ↓
/spec guides description
    ↓
Interactively refine SPEC
    ↓
Call /architect to update SPEC
    ↓
Complete (don't call /programmer)
```

**Trigger Condition**: Choose "Don't implement yet" in "Start implementation now" step

---

## Collaboration with Other Commands

```
/spec (guide requirement description)
    ↓
/architect (update SPEC)
    ↓
/programmer (implement feature)
    ↓
/spec-audit (verify completeness)
```

**Difference from /spec-init**:

| Command | Purpose | Trigger Timing |
|---------|---------|----------------|
| /spec-init | Initialize project SPEC | New project or existing project first-time SPEC establishment |
| /spec | Refine single feature SPEC | Existing SPEC, adding/modifying specific features |

---

## Prohibited Operations

- ❌ **Skip SPEC completeness check**
- ❌ **Use fixed options** - Must use open-ended dialogue
- ❌ **Implement features yourself** - Must go through /programmer
- ❌ **Omit any SPEC dimensions** - Requirements/data/API must be complete

---

## Core Principles

**/spec = SPEC Requirement Description Mode**

- Explicit mode switch, force SPEC focus
- Interactive refinement, ensure SPEC completeness
- Seamless transition to /programmer, avoid attention distraction
- User-led process, AI executes guidance

---

## Example Dialogue

### Example 1: New Feature

```
User: /spec Implement user registration feature

AI: # 🎯 SPEC Requirement Description Mode
    Welcome to SPEC-driven development!
    ...
    Please describe the detailed requirements for registration:

User: Users can register via email and password, need to verify email after registration

AI: Based on your description, I need to refine the following SPEC:

    **1. Requirement Definition (REQ-AUTH-002)**
    - Feature name: User registration
    - Acceptance criteria:
      - Support email+password registration
      - Send verification email after successful registration
      - [What else?]

    User: Password needs encrypted storage, email verification link valid for 24 hours

    AI: **2. Data Model (DATA-USER-001)**
    - Required fields:
      - email (email)
      - password_hash (password hash)
      - email_verified (verification status)
      - [What else is needed?]

    User: Also need created_at and verification_token

    AI: **3. API Design (API-AUTH-002)**
    - Endpoint: POST /api/auth/register
    - Request format:
      ```json
      {
        "email": "user@example.com",
        "password": "plain_password"
      }
      ```
    - Response format?

    User: Return user ID and message "Verification email sent"

    AI: ## 📋 SPEC Summary
    [Display complete SPEC]

    Is this SPEC accurate?
    [✅ Accurate, update SPEC and start development]
    User: ✅

    AI: [Call /architect to update SPEC]
    ✅ SPEC Updated!
    Start implementation now?
    [✅ Start implementation]
    User: ✅

    AI: [Call /programmer for implementation]
```

---

## Output Format

### Success Output (Complete Workflow)

```markdown
✅ SPEC Requirement Description Process Complete!

**Updated SPEC**:
- REQ-AUTH-002: User registration feature
- DATA-USER-001: User table extension
- API-AUTH-002: Registration interface

**Implemented Features**:
- Email+password registration
- Password encrypted storage
- Email verification mechanism
- 24-hour verification link validity

**Code Locations**:
- src/api/auth/register.ts
- src/models/user.ts
- src/services/email.ts

**Next Steps**:
1. Test feature → /programmer
2. View SPEC → cat SPEC/01-REQUIREMENTS.md
```

### SPEC-Only Output

```markdown
✅ SPEC Update Complete!

**Updated SPEC**:
- REQ-XXX: [Feature name]
- DATA-XXX: [Entity name]
- API-XXX: [Interface name]

**View Complete SPEC**:
- cat SPEC/01-REQUIREMENTS.md
- cat SPEC/03-DATA-STRUCTURE.md
- cat SPEC/04-API-DESIGN.md

**When Ready to Implement**:
- Execute /spec again and choose "Start implementation"
- Or directly call /programmer
```
