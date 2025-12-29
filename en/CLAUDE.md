# Claude Code Development Standards

> **Document定位**: Global-level CLAUDE.md (~/.claude/CLAUDE.md)
>
> This document defines the core workflows and standards for SPEC-driven development, permanently resident in the user's system.
>
> **Scope**: All projects using this framework
> **Installation Location**: `~/.claude/CLAUDE.md`
>
> **Project-level CLAUDE.md**: User projects should only contain SPEC location instructions (see "Project-level CLAUDE.md Standards" below)

---

## Eight Iron Rules (Violation = Failure)

| # | Rule | Description |
|---|------|-------------|
| 1 | Main session prohibits writing code | All production code must be executed through /programmer skill |
| 2 | Code must undergo review | programmer must read actual files for verification, don't trust AI CLI reports |
| 3 | Context7 first | Must use Context7 to research mature libraries before new feature development |
| 4 | SPEC is the source of truth | Design follows SPEC, code conflicts change code not SPEC |
| 5 | Destroy and rebuild principle | Prohibit incremental changes, only reuse when fully matched, otherwise delete and rewrite |
| 6 | Complete delivery | No TODO/FIXME/stub, 100% implement SPEC |
| 7 | Update SPEC after commit | Update SPEC status immediately after code commit |

### Architect-Specific Iron Rules (Only effective for /architect)

**Iron Rule 1: Prohibit generating code in SPEC**
- Prohibit any concrete code in specific programming languages (classes/functions/pseudo-code)
- Prohibit language-specific syntax (Python type annotations/Go interfaces/TS generics)
- Prohibit algorithm implementations, configuration implementations, and other specific implementation details
- ✅ Only write interface contracts/data structures/architectural patterns (language-agnostic)

**Iron Rule 2: Prohibit unauthorized generation of configuration files and environment variables**
- Prohibit pre-setting .env, .yml, .json and other configuration file content
- Prohibit unauthorized definition of environment variables (unless core architecture dependencies)
- Prohibit pre-setting Docker/K8s and other deployment configurations
- ✅ Only do architectural design unless explicitly requested by user

**Iron Rule 3: User-led design principle**
- User is the senior designer, architect is the execution assistant
- Prohibit recommending or suggesting solutions (user decides, architect executes)
- Prohibit updating SPEC without user confirmation
- ✅ Interactive collaboration until user satisfied before updating SPEC

---

## Temporary File Standards

**Prohibit generating any report/analysis/debug files in project root directory**

**Files that must be generated to temporary directories**:
- All analysis reports: *ANALYSIS.md, *REPORT.md, *ALIGNMENT.md
- All debug output: debug-*, trace-*, verbose-*
- All temporary states: temp-*, tmp-*, backup-*

**Allowed locations**: `/tmp/claude-reports/`, `$HOME/.claude/tmp/`, `/dev/shm/claude-reports/`

**Project root directory should only contain**: Source code, configuration files, build scripts, SPEC documents, README

---

## Main Session Decision Flow (Must execute every time a message is received)

```
User message
    ↓
Step 1: Determine if it involves requirements/design changes
  Following situations = requirement change = must call /architect:
  - User says "change to XXX", "support XXX", "don't XXX"
  - User adjusts function parameters, interfaces, behaviors
  - User modifies technical solutions, architecture decisions
  - Any instructions that cause SPEC content to change
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
  - Answer questions
```

**Key rules**:
- ❌ Prohibit verbally adjusting plans - when user modifies requirements, must call architect to update SPEC
- ❌ Prohibit writing code yourself - even for "very simple changes", must call programmer
- ✅ When in doubt, default to calling skills - better to call more than miss

---

## Main Session and Programmer Responsibility Division

**programmer skill is responsible for automatically executing code commits, main session no longer intervenes in commit process**

programmer workflow:
1. Steps 1-7: Normal development, verification, code review process
2. Step 8: After verification passes, automatically execute code commit, issue closure, SPEC status update, report completion to main session

Main session responsibilities:
- ❌ No longer detect triggers like "code review passed"
- ❌ No longer execute commit scripts
- ✅ Only receive programmer's completion report

**Core principle**: Automatic execution (commit immediately after verification passes without asking), responsibility separation, avoid duplicate commits

---

## Smart Reuse and Destroy-Rebuild Principle

> See details: `skills/shared/SPEC-AUTHORITY-RULES.md`

**Core concepts**:
- **Avoid duplicate development**: Directly reuse when fully matching existing modules
- **Avoid incremental development**: Partial match = mismatch → destroy and rebuild

**Key rules**:
- ✅ Fully matched → Directly reuse
- ❌ Partially matched/unmatched → Delete and rewrite, prohibit incremental modification

---

## Role Division

```
User        → Requirement definition, solution selection, final decisions
Main session → Coordination and scheduling, receive programmer's completion report
/architect  → Update SPEC (01/02/03/04 + DOCS/), assign IDs, don't write code
/programmer → Read SPEC → Create plan → Present for confirmation → Create Issue → Call AI CLI → Review code → Auto commit + update SPEC
```

**Main session only allowed to handle directly**: Pure documentation, configuration value modifications, format adjustments (no logic changes)

### Architect vs Programmer Responsibility Comparison

| Decision Type | architect | programmer |
|---------|-----------|------------|
| Requirement definition | ✅ Assign REQ-XXX, update 01 | ❌ Only read |
| Architecture design | ✅ Design modules, update 02 | ❌ Only read |
| Data design | ✅ Design table structure, update 03 | ❌ Only read |
| API design | ✅ Define interfaces, update 04 | ❌ Only read |
| DOCS creation | ✅ Create architecture docs | ❌ Only read |
| SPEC completeness check | ❌ Don't do | ✅ Must check before development |
| Design verification (architecture principles) | ✅ Verify normalization/SOLID | ❌ Don't do |
| Implementation plan | ❌ Don't care | ✅ Create and present, wait for user confirmation |
| Create Issue | ❌ Don't create | ✅ Create after user confirmation |
| Code implementation | ❌ Don't write code | ✅ Call AI CLI |
| Code review | ❌ Don't review | ✅ Review based on actual files |
| Context7 research | ✅ Technology stack selection | ✅ Specific usage queries |

---

## Development Workflow

### New Features/Refactoring (Complete Workflow)

**Phase 1: Architecture Design (if needed)**
Main session calls /architect → Interactive design → User confirmation → Update SPEC

**Phase 2-3: Development Execution (programmer 8-step workflow)**

```
Step 1: Analyze existing code
       Call Explore sub-agent to analyze codebase
       Identify reusable modules (utility classes, infrastructure, business modules)
       Output: Reusable module list

Step 2: SPEC check and implementation plan
       Call Plan sub-agent
       ├─ Read SPEC, verify completeness
       ├─ Output SPEC understanding summary
       ├─ Use Context7 + AskUserQuestion to select specific libraries
       └─ Create implementation plan (mark SPEC references + user-selected libraries)

Step 3: Review Plan output
       Verify Plan's SPEC understanding is correct
       Verify implementation plan is reasonable
       Adjust or supplement (if needed)

Step 4: 🛑 Present implementation plan, wait for user confirmation
       Present Plan output (including SPEC understanding summary)
       User verification: Is SPEC understanding correct, is plan reasonable
       ⏸️ Wait for user confirmation before proceeding to Step 5

Step 5: Create GitHub Issue
       Persist plan generated by Plan
       Associate SPEC references

Step 6: Call AI-CLI-RUNNER
       Pass session_context: Plan's plan
       Generate production-ready code

Step 7: Code review
       Read actual code files (don't trust AI CLI reports)
       Check against SPEC (REQ-XXX, ARCH-XXX, etc.)
       Verification fails → Fix and re-review

Step 8: Auto commit and status update
       After verification passes, automatically execute commit, close issue, update SPEC
       Report completion results to main session
```

### Bug Fixes/Small Changes (Simplified Workflow)
Confirm SPEC complete → Call /programmer to modify → Verify → Commit

### Documentation/Format Adjustments
Main session executes directly, no SPEC needed

---

## Completion Standards

- ✅ 100% implementation of all requirements in SPEC
- ✅ No placeholders (TODO, FIXME, stub, NotImplemented)
- ✅ Code review passed

---

## Practical Decision Guidelines

### SPEC Completeness Check (Must check before development)

**SPEC completion criteria** (all ✅ required to start development):
- ✅ Requirements complete: All REQ-XXX in 01-REQUIREMENTS.md have clear acceptance criteria
- ✅ Architecture complete: Module division, technology stack, data flow, event flow defined in 02-ARCHITECTURE.md
- ✅ Data structure complete: All table structures, fields, relationships, indexes defined in 03-DATA-STRUCTURE.md
- ✅ API complete: Request/response formats, error codes defined for all interfaces in 04-API-DESIGN.md

**When SPEC is incomplete**:
- ❌ Prohibit starting development
- ✅ Call architect skill to improve architecture design
- ✅ Wait for user to supplement requirement definitions
- ✅ Report missing content, clearly list missing parts

### Parallel Development Judgment

⚠️ **Iron rule: Default to parallel, unless there are clear dependency relationships! Don't choose serial because of conservatism!**

**Mandatory dependency analysis process** (must execute when creating development plan):

1. **Draw dependency graph** (mandatory step):
   ```
   Project A → Project B  (B depends on A)
   Project C → Project D  (D depends on C)
   Project E  (independent)
   ```

2. **Identify dependency types**:
   - Code dependency: B directly imports A's modules
   - API dependency: B calls A's interfaces
   - Data dependency: B reads/writes tables created by A
   - Infrastructure dependency: B needs A's services

3. **Write execution strategy**:
   ```
   Phase 1 (serial): Complete infrastructure project A
   Phase 2 (parallel): Develop projects B, C, D simultaneously
   Phase 3 (parallel): Integration verification
   ```

### Task Routing and Executors

| Task Type | Workflow | SPEC | Context7 | Executor |
|---------|---------|------|----------|----------|
| New features/refactoring | Complete workflow | Must update | Required | /programmer |
| Function modifications | Complete workflow | Must update | Required | /programmer |
| Bug fixes | Simplified | Reference | Optional | /programmer |
| Documentation/config/format | Direct | Not needed | Not needed | Main session |

**Judgment criteria**:
- Not sure if need to call skill? → Default to calling /programmer
- Involves any code modification? → Call /programmer
- Involves architecture or SPEC? → Call /architect

### Context7 Usage

**Must use**:
- Technology selection before new feature development
- Introducing new libraries or using library APIs
- Research best practices before code generation
- Compare multiple library choices

**Strongly recommended**: Complex technical problems, dependency upgrades, performance optimization assessments, security enhancements

**Prohibited**:
- Implement common features without research
- Use outdated library versions or APIs
- Write library usage code from memory

---

## SPEC File System

### Core Files

| File | Responsibility | Maintainer |
|------|---------------|------------|
| 01-REQUIREMENTS.md | Feature requirements, REQ-XXX, acceptance criteria | architect |
| 02-ARCHITECTURE.md | Architecture design, ARCH-XXX, technology stack | architect |
| 03-DATA-STRUCTURE.md | Data models, DATA-XXX, table structures | architect |
| 04-API-DESIGN.md | API specifications, API-XXX, interface definitions | architect |
| 05-UI-DESIGN.md | Frontend UI design, UI-XXX, page specifications | architect |
| VERSION | Version number v{major}.{minor}.{patch} | Main session |
| DOCS/ | Complex system detailed design | architect |

### ID Format

- `REQ-{domain}-{number}`: REQ-AUTH-001
- `ARCH-{domain}-{number}`: ARCH-CACHE-001
- `DATA-{table}-{number}`: DATA-USER-001
- `API-{module}-{number}`: API-AUTH-001
- `UI-PAGE-{module}-{number}`: UI-PAGE-USER-001

### Directory Structure

```
SPEC/
├── VERSION
├── 01-REQUIREMENTS.md
├── 02-ARCHITECTURE.md
├── 03-DATA-STRUCTURE.md
├── 04-API-DESIGN.md
├── 05-UI-DESIGN.md (for frontend projects)
└── DOCS/ (optional)
```

---

## Git Standards

### Commits (Mandatory use of scripts)

```bash
~/.claude/scripts/commit-and-close.sh \
  --message "feat: description [REQ-XXX]" \
  --issue <issue#>
```

**Prohibited**: git commit -m "...", git add && git commit, gh issue close

### Commit Format

```
<type>(<scope>): <description> [REQ-XXX]
Example: feat(auth): Implement JWT authentication [REQ-AUTH-001]
```

### Pre-Commit Hooks

Install: `ln -sf ~/.claude/scripts/spec-pre-commit-hook.sh .git/hooks/pre-commit`

| Check Item | Level | Behavior |
|-----------|-------|----------|
| Sensitive files | Error | Block commit |
| Code not associated with SPEC | Warning | Allow commit, prompt to fix |
| SPEC format issues | Error/Warning | Block on serious issues, warn on minor issues |
| Incomplete SPEC traceability | Warning | Allow commit, prompt to supplement |

---

## Issue Management

**Must create**: New features, architecture refactoring, multi-file modifications, complex bugs
**Optional**: Simple bugs, technical debt
**Don't create**: Documentation, format adjustments

**Responsibility division**:
- SPEC (design specs): Architecture design, requirement definitions, data design, API design
- Issue (work plans): Implementation steps, code reuse, dependencies, status tracking

**Core principle**: SPEC defines "what", Issue plans "how"

### Issue Template

```markdown
## Development Plan: [Feature Name] [REQ-XXX]

### Associated SPEC
- Requirements: SPEC/01-REQUIREMENTS.md [REQ-XXX]
- Architecture: SPEC/02-ARCHITECTURE.md [ARCH-XXX]
- Data: SPEC/03-DATA-STRUCTURE.md [DATA-XXX]
- API: SPEC/04-API-DESIGN.md [API-XXX]

### Dependencies
- Depends on: #123 (must complete first)
- Blocks: #789 (waiting for this Issue)
- Can parallel: #456

### Implementation Steps
- [ ] Analyze existing code, identify reusable modules
- [ ] Step 1
- [ ] Step 2
- [ ] Verify completion

### Code Reuse Plan
- Reuse: [module path and purpose]
- Add: [module path and responsibility]
```

---

## Project-Level CLAUDE.md Standards

**Core principle**: CLAUDE.md = SPEC pointer, not design document

### Hierarchy

```
Global CLAUDE.md (~/.claude/CLAUDE.md) → Permanent resident, defines development workflows and standards
Product-level CLAUDE.md (product root/CLAUDE.md) → Points to product SPEC, defines cross-project shared constraints
Project-level CLAUDE.md (project root/CLAUDE.md) → Points to project SPEC
Service-level CLAUDE.md (services/xxx/CLAUDE.md) → Points to service SPEC (for microservices)
```

### Standard Template

```markdown
## SPEC Location
- ./SPEC/

## Product-level SPEC Location (if applicable)
- ../SPEC/
```

### Allowed Content

- SPEC location instructions (./SPEC/ or ../SPEC/)
- Project-specific constraints and development workflow references (reference, don't define)
- Role division instructions (brief references)

### Prohibited Content (Must be in SPEC)

**The following content must be defined in SPEC files, should not be duplicated in CLAUDE.md:**

- Feature requirement definitions (must be in SPEC/01-REQUIREMENTS.md)
- Module lists and responsibility tables (must be in SPEC/02-ARCHITECTURE.md)
- Technology stack detailed descriptions (must be in SPEC/02-ARCHITECTURE.md)
- Data model definitions, table structures, field lists (must be in SPEC/03-DATA-STRUCTURE.md)
- API interface definitions, endpoint lists, request/response formats (must be in SPEC/04-API-DESIGN.md)
- ID format definitions (REQ-XXX, ARCH-XXX, DATA-XXX, API-XXX)
- Architecture principles and design pattern detailed descriptions
- Detailed workflow steps (should reference global standards, not redefine)

### Compliance Check

Using `/spec-audit` command will automatically check if CLAUDE.md content conforms to "SPEC pointer" positioning.

**Check focus**:
- ✅ Content nature: Whether it contains content that should be in SPEC
- ❌ Don't check file length: Framework projects can be long, business projects recommended to be brief
- ✅ Check content types: Requirements, architecture, data models, API definitions must be in SPEC

---

## AI CLI RUNNER Standards

### Execution Mode

- ✅ **Foreground mode (default)**: All individual tasks, regardless of duration
- ✅ **Background mode (exception)**: Only when **multiple independent projects** need simultaneous development, must use `run_in_background=True`
- ❌ Prohibit auto-conversion: Can't auto-convert to background after starting foreground
- ❌ Prohibit using command &: All background tasks must use `run_in_background=True`
- ❌ Prohibit mindless background: Don't auto-add `run_in_background=True` to all calls

### Batch Processing Priority Principle

**Same project + same role = must merge into one AI CLI call**

Reason: Each call has fixed TOKEN cost (reading SPEC, analyzing code), batch execution significantly reduces cost

```bash
# ✅ Correct: Batch execution
ai-cli-runner.sh backend 'REQ-001,REQ-002,REQ-003' 'Implement all backend APIs'

# ❌ Wrong: Execute individually (TOKEN waste)
ai-cli-runner.sh backend 'REQ-001' 'Login'
ai-cli-runner.sh backend 'REQ-002' 'Register'
```

### Concurrency Rules

**Strictly prohibited**: Split same project by feature/module for concurrency
**Allowed**: Different independent projects can be concurrent (different codebases, different deployment units, no dependencies, resource isolation)

### 12-Hour Timeout (Mandatory)

All ai-cli-runner.sh calls must set `timeout=43200000`

Reason: Complex development may take hours, prevent interruption from network issues

```bash
# ✅ Correct
Bash(command="~/.claude/scripts/ai-cli-runner.sh 'backend' 'REQ-001' 'Implement feature'", timeout=43200000)

# ❌ Wrong: Missing timeout or short timeout
Bash(command="~/.claude/scripts/ai-cli-runner.sh ...")
```

### Role List

| Role | Applicable Scenarios |
|------|---------------------|
| fullstack | Complete application (frontend + backend + database) |
| backend | General backend services, RESTful APIs, microservices (default) |
| frontend | Web/mobile/desktop applications |
| database | SQL/NoSQL, data modeling |

### task_context Format

```
【Background Document】SPEC/DOCS/AI-DEVELOPER-GUIDE.md
【Feature List】(Must complete all at once)
- REQ-XXX: Feature description
- REQ-YYY: Feature description
【Code Reuse】Reference src/xxx.py
【Acceptance Criteria】Code review passed
```

---

## Shared Standards References

| Standard | Location |
|----------|----------|
| SPEC Authority Principles | `skills/shared/SPEC-AUTHORITY-RULES.md` |

---

## Prohibit Meaningless Interruptions

**Only applies to Step 4-8 execution phase** (effective after user confirms plan)

Premise: Steps 0-3 must be fully executed, Step 3's user confirmation is mandatory wait point

**Execution after plan confirmation is continuous**:
- After user confirms plan, execute all task blocks in sequence
- After task block completes, directly continue to next
- After all complete, enter verification and review

**Prohibited questioning patterns**:
- ❌ "Task block X completed, continue to task block Y?"
- ❌ "Push current progress first?"
- ❌ "Do you need me to continue?"
- ❌ Report progress then request permission to continue

**Must ask/wait**:
- ✅ Step 4: Present plan, wait for user confirmation
- ✅ SPEC conflicts or ambiguities require user decisions
- ✅ Discovered blocking issues unable to continue

---

## AI Execution Constraints

1. This specification is a mandatory operating system, not optional suggestions
2. Prohibit AI from self-judging "whether to follow process" - specification defines when to follow which process
3. Prohibit AI from deviating from specification for "efficiency", "simplicity", "user might want"
4. When uncertain, strictly follow specification, don't decide yourself
