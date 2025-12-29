# Skill Interface Specification Document

> **Version**: v1.1
> **Date**: 2025-12-26
> **Scope**: All AI skills including architect, programmer, etc.
> **Updates**: Implement balanced automation checkpoint mechanism (reduce manual intervention, maintain safety guarantees)

---

## 1. Core Design Philosophy

### 1.1 User-Centric Principle

```
┌─────────────────────────────────────────────────────────────────────────┐
│  User is absolute center, skills are responsive tools                    │
│                                                                         │
│  ✅ Correct Understanding:                                              │
│     - User decides which skill to call at any time                      │
│     - Skills respond based on context, no preset workflows              │
│     - Balanced automation: Balance between efficiency and safety        │
│     - Simple tasks auto-pass, complex tasks retain review               │
│                                                                         │
│  ❌ Incorrect Understanding:                                            │
│     - Must call in architect → programmer order                         │
│     - Fixed call order between skills                                   │
│     - State machine controls skill invocation                           │
│     - All tasks require manual review                                   │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.4 Balanced Automation Strategy

**Core Principle**: Maximize automation while ensuring code quality

| Checkpoint | Old Mechanism | Balanced Mechanism |
|------------|---------------|-------------------|
| **Checkpoint 1** | User confirms SPEC complete | ✅ **Auto-verify** (Gate C1) + ❌ Ask on failure |
| **Checkpoint 2** | All tasks need user confirmation | ✅ **Simple tasks auto-pass** + Complex tasks retain confirmation |
| **Checkpoint 4** | User confirms Bug classification | ✅ **Auto-classify** (based on failure rules) |

**Simple task criteria**:
- Bug fixes (associated Issue + impact < 3 files)
- Documentation updates (only `.md` files modified)
- Configuration adjustments (only config files modified)
- Small changes (file changes < 3 + no architectural impact)

**Complex feature criteria**:
- New feature implementation (REQ-XXX involves multiple modules)
- Code refactoring (modifying > 5 files or core modules)
- Architecture changes (involving ARCH-XXX)
- Cross-service modifications (affecting multiple projects)

**Manual review mechanism**:
- Add `/programmer --review` command
- User can trigger code review at any time
- Verify consistency between code and SPEC
- Generate quality report and improvement suggestions

### 1.2 Skill Independence

Each skill is an independent module with:
- Clear responsibility boundaries
- Independent input/output interfaces
- Self-contained context management
- No dependency on other skill call order

### 1.3 State Machine Context Management

State machine is not a skill call controller, but:
- Trigger condition evaluator for checkpoints
- Coordinator for automation workflows
- Manager for REQ-XXX tag status

---

## 2. Skill Call Trigger Conditions

### 2.1 Main Session Decision Flow (Mandatory)

```
User message
    ↓
Step 1: Determine if it involves requirements/design changes
  Following situations = requirement change = must call /architect:
  - User says "change to XXX", "support XXX", "don't XXX"
  - User adjusts function parameters, interfaces, behaviors
  - User modifies technical solutions, architecture decisions
  - Any instructions causing SPEC content changes
  → Immediately call /architect, prohibit verbally adjusting plans
    ↓ No
Step 2: Determine if it involves code implementation
  Following situations = must call /programmer:
  - User says "continue", "start implementing", "write code"
  - Code development after plan confirmation
  - Bug fixes, function modifications
  → Immediately call /programmer, prohibit writing code yourself
    ↓ No
Step 3: Main session handles directly (only for following situations)
  - Pure documentation (README, comments)
  - Configuration value modifications
  - Format adjustments
  - Answering questions
```

### 2.2 Skill Call Decision Tree

```
User request type
    ↓
Code modification → /programmer
    ├─ Feature implementation
    ├─ Bug fixes
    └─ Code refactoring

Architecture design → /architect
    ├─ Requirement changes
    ├─ Technology selection
    ├─ Architecture adjustments
    └─ SPEC updates
```

### 2.3 Context Passing Specification

```
Each skill call must include complete context:

【Project Root Directory】
Complete path

【Associated File References】
- SPEC file paths + descriptions
- Key section references
- Core constraint descriptions

【Task Background】
- User's original request
- Current project status
- Existing code/modules

【Execution Requirements】
- Must do
- Must not do
- Acceptance criteria

【Temporary Files】
- AI-DEVELOPER-GUIDE path (if applicable)
```

---

## 3. Balanced Checkpoint Trigger Mechanism

### 3.1 Checkpoint General Specification

- **Trigger judgment**: Automatically evaluate task complexity based on state and context
- **Executor**: Current called skill responsible for judgment and execution
- **Ask method**: Use AskUserQuestion for complex tasks, simple tasks auto-pass
- **Auto-record**: Review results automatically recorded to Issue and SPEC tags

### 3.2 Checkpoint 1: SPEC Completeness Verification (Auto)

**Balanced optimization**: Fully automated, only ask on failure

#### Gate C1: SPEC Completeness Auto Check

**Check items**:
- ✅ Requirements complete: All REQ-XXX have clear acceptance criteria
- ✅ Architecture complete: Module division, tech stack, data flow defined
- ✅ Data complete: Table structures, fields, relationships, indexes defined
- ✅ API complete: Interface formats, error codes defined

**Trigger timing**: After architect completes design

**Auto execution logic**:
```python
if SPEC completeness check passes:
    Auto-append tag "✅ SPEC Complete (YYYY-MM-DD)"
    Allow direct entry to development phase (no user confirmation needed)
else:
    Report missing content list to user
    Wait for user decision:
    - Call architect to supplement SPEC
    - Or force continue (risk warning)
```

**No trigger scenarios**: Bug fixes, code review, small changes

### 3.3 Checkpoint 2: Implementation Plan Confirmation (Conditional Auto)

**Balanced optimization**: Simple tasks auto-pass, complex features retain confirmation

#### Task Complexity Auto Judgment

| Judgment Dimension | Simple Tasks | Complex Features |
|-------------------|--------------|------------------|
| **Task type** | Bug fixes, doc updates, config adjustments | New features, refactoring, architecture changes |
| **Impact scope** | < 3 files | ≥ 3 files |
| **SPEC impact** | No REQ-XXX changes | Involves REQ-XXX |
| **Architecture impact** | None | Involves ARCH-XXX |
| **Cross-service impact** | Single project | Multiple projects |

#### Simple Tasks: Auto Pass Flow

**Judgment conditions** (meet any one):
1. Bug fix (associated Issue + impact < 3 files)
2. Documentation update (only `.md` files modified)
3. Configuration adjustment (only config files modified)
4. Small change (file changes < 3 + no architectural impact)

**Auto execution flow**:
```python
if judged as simple task():
    Display simplified implementation plan (within 1 screen)
    Append note: "🤖 Simple task, auto-pass checkpoint 2"
    Directly continue steps 4-8 (no wait for confirmation)
```

#### Complex Features: Retain Confirmation Flow

**Judgment conditions** (meet any one):
1. New feature implementation (REQ-XXX involves multiple modules)
2. Code refactoring (modifying > 5 files or core modules)
3. Architecture change (involving ARCH-XXX)
4. Cross-service modification (affecting multiple projects)

**Retain confirmation flow**:
```python
if judged as complex feature():
    Display detailed implementation plan
    Include: SPEC understanding summary, task block division, complete feature list
    ⏸️ Wait for explicit user confirmation
    After confirmation, continue steps 4-8
```

### 3.4 Checkpoint 4: Bug Classification Handling (Auto)

**Balanced optimization**: Auto-classify and handle based on failure rules

#### Test Failure Auto Classification Rules

| Failure Type | Test Layer | Auto Classification | Auto Handling |
|-------------|------------|---------------------|---------------|
| Code logic error | Unit tests | Code Bug | Auto-call programmer to fix |
| Interface mismatch | Integration tests | API contract issue | Auto-call programmer to fix |
| SPEC non-compliance | E2E tests | SPEC conflict | **Ask user** for decision |
| Environment issue | Any | Non-code issue | Auto-retry, report on failure |

**Auto execution logic**:
```python
# Test failure auto classification
if test_type == "unit tests":
    Bug_type = "Code logic error"
    Handling = "Auto-call programmer to fix"
elif test_type == "integration tests" and failure_reason contains interface:
    Bug_type = "API contract non-compliance"
    Handling = "Auto-call programmer to fix"
elif test_type == "E2E tests" and failure_reason contains SPEC non-compliance:
    Bug_type = "SPEC conflict"
    Handling = "Report to user, wait for decision"
    Ask content:
    1. Call architect to update SPEC
    2. Call programmer to modify code to match SPEC
    3. Force pass (mark as technical debt)
elif test_type == "environment issue":
    Handling = "Auto-retry up to 3 times, report to user on failure"
```

### 3.5 Safety Net Mechanism (Fully Retained)

Following checks **fully retained**, ensuring automation doesn't reduce code quality:

| Safety Check | Trigger Timing | Behavior |
|--------------|----------------|----------|
| **Pre-commit Hook** | git commit | Block on sensitive files, warn on others |
| **Gate C1** | Architect complete | SPEC completeness auto verification |
| **Gate C2** | Programmer step 7 | Code quality auto review |

---

## 4. Skill Collaboration Mechanism

### 4.1 Automated Collaboration (No Manual)

```
Bug fix workflow:
Discover issue → Auto-generate Issue
↓
programmer receives Bug → Auto-analyze fix → Commit code → Close Issue → Update tag "✅ Fixed"
```

### 4.2 Issue Lifecycle Management

```
Issue creation timing:
- After plan confirmation (created by programmer)
- When Bug discovered (created by programmer)
- When requirement changes (created by architect)

Issue status transition:
open → in_progress → resolved/closed
  ↓        ↓          ↓
Developing Fixing   Completed

Tag association:
Each Issue auto-associates REQ-XXX tags
Tag status changes with Issue
```

### 4.3 SPEC Status Sync

```
REQ-XXX tag auto update flow:
"✅ SPEC Complete" → "✅ Implemented"

Trigger conditions:
- architect completes → Append "✅ SPEC Complete"
- programmer commits → Append "✅ Implemented (commit: xxx)"
```

---

## 5. Error Handling and Recovery

### 5.1 Skill Call Errors

```
Skill call failure handling:
1. Parameter error → Main session re-analyzes, corrects parameters and retries
2. Missing context → Request user to provide complete information
3. Network timeout → Retry, report to user after multiple failures
4. AI CLI error → Log error, provide diagnostic information
```

### 5.2 Checkpoint Handling Errors

```
User response exception handling:
1. Not in options → Prompt to re-select, limit to 3 attempts
2. Timeout no response → Default to safest option (usually "adjust plan")
3. Contradictory choice → Point out contradiction, request clarification
```

### 5.3 Automation Flow Errors

```
Error handling:
- AI CLI fix fails → Log error, notify user to intervene
```

---

## 6. Input/Output Interface Specification

### 6.1 Standard Input Format

```json
{
  "session_context": {
    "project_root": "/path/to/project",
    "spec_files": [
      {
        "path": "SPEC/01-REQUIREMENTS.md",
        "description": "Feature requirements definition",
        "key_sections": ["REQ-AUTH-001", "REQ-AUTH-002"]
      }
    ],
    "constraints": {
      "must_do": ["list"],
      "forbidden": ["list"]
    }
  },
  "user_request": "User's original request",
  "additional_context": {}
}
```

### 6.2 Standard Output Format

```json
{
  "status": "success|error|needs_review",
  "result": {
    "output": "Execution result",
    "files_created": ["path1", "path2"],
    "issues_created": ["#123"],
    "labels_updated": ["REQ-XXX: new status"]
  },
  "next_steps": [
    "Next step suggestions"
  ],
  "needs_review": {
    "review_point": 1-4,
    "question": "Ask content",
    "options": ["Option 1", "Option 2"]
  }
}
```

### 6.3 Error Output Format

```json
{
  "status": "error",
  "error_type": "parameter|context|execution|network",
  "error_message": "Detailed error message",
  "suggestion": "Fix suggestion",
  "recovery_steps": ["Step 1", "Step 2"]
}
```

---

## 7. Performance and Constraints

### 7.1 Timeout Settings

| Operation Type | Default Timeout | Configurable |
|----------------|-----------------|--------------|
| skill call | 12 hours | Yes |
| Single AI CLI | 4 hours | Yes |
| Checkpoint response | 5 minutes | No |

### 7.2 Resource Limits

- Memory usage: Single session < 8GB
- File operations: Temporary files < 1GB
- Concurrent tasks: Maximum 3 per project
- Issue quantity: < 50 per session

### 7.3 Retry Mechanism

| Error Type | Retry Count | Retry Strategy |
|------------|-------------|----------------|
| Network error | 3 times | Exponential backoff |
| API limit | 5 times | Linear interval |
| Parameter error | 1 time | No retry |
| AI CLI error | 2 times | Immediate retry |

---

## 8. Version Compatibility

### 8.1 Backward Compatibility

- Skill interfaces maintain backward compatibility
- New versions support old version input formats
- Breaking changes identified by version number

### 8.2 Deprecation Strategy

- Deprecated features notified 6 months in advance
- Provide migration guide
- Old versions supported for at least 3 months

---

*This document is the foundational specification for skill collaboration, all skill implementations must follow the interfaces and collaboration mechanisms defined in this document.*

