# SPEC-INIT Skill Specification - SPEC Initialization Expert

**Version**: 1.0.0
**Purpose**: Quickly generate SPEC document collections for new or existing projects
**Responsibilities**: Project status detection, code reverse analysis, interactive SPEC design, document generation
**Last Updated**: 2025-12-27

---

## 🎯 Skill Positioning

**Core Value**: Lower the entry barrier for SPEC-driven development and quickly initialize projects

**Applicable Scenarios**:
1. ✅ **Empty Project Initialization**: Empty directory or newly created, requiring SPEC design from scratch
2. ✅ **Existing Project Completion**: Has code but no SPEC, requiring reverse generation of SPEC documents
3. ✅ **SPEC Supplement and Improvement**: Has partial SPEC requiring completion of missing content

---

## 🛠️ Execution Flow

### Step 0: Project Status Detection

**Detection Items**:
```bash
# Check directory structure
[ -d "SPEC/" ] && echo "SPEC directory exists" || echo "No SPEC directory"
[ -f "SPEC/VERSION" ] && echo "VERSION file exists" || echo "No VERSION file"

# Check code files
find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" \) | wc -l

# Check configuration files
[ -f "package.json" ] && echo "Node.js project"
[ -f "go.mod" ] && echo "Go project"
[ -f "requirements.txt" ] && echo "Python project"
[ -f "pom.xml" ] && echo "Java/Maven project"
```

**Status Classification**:

| Status | Criteria | Processing Flow |
|--------|----------|-----------------|
| **Empty Project** | No code files, no SPEC | → Step 1A: Interactive Design |
| **Legacy Project** | Has code, no SPEC | → Step 1B: Reverse Generation |
| **Partial SPEC** | Has code, has SPEC but incomplete | → Step 1C: Supplement and Improve |
| **Complete Project** | Has code, complete SPEC | → Indicates ready |

---

## Step 1A: Empty Project - Interactive Design

### 1A.1 Project Information Collection

**Required Information**:
```markdown
## Project Basic Information

1. Project Name: __________
2. Project Type: [Web Application/Backend Service/CLI Tool/Library/SDK/Other]
3. Technology Stack: [Programming Languages, Frameworks, Database]
4. Core Functions: [2-3 sentences describing the problem the project solves]
```

**Example Dialogue**:
```
🤖 Welcome to SPEC-INIT! Let me help you quickly establish SPEC documents.

Please tell me:
1. What is the project name?
2. What type of project is this? (Web Application/Backend Service/CLI Tool/Library, etc.)
3. What technology stack do you plan to use?
4. What problem does this project solve?

User: I want to build a user authentication service
User: Using Go and gRPC
User: Providing unified user login, registration, and permission management
```

### 1A.2 Guided Design

**Design Process**:
```
Collect basic information
    ↓
Phase 1: Functional Requirements (01-REQUIREMENTS.md)
  ├─ What are the core functions?
  ├─ What are the key user roles?
  └─ What are the main user scenarios?
    ↓
Phase 2: Architecture Design (02-ARCHITECTURE.md)
  ├─ How is the system layered?
  ├─ What are the main modules?
  └─ How do modules communicate?
    ↓
Phase 3: Data Design (03-DATA-STRUCTURE.md)
  ├─ What data needs to be stored?
  ├─ How are data tables designed?
  └─ What are the core entities?
    ↓
Phase 4: API Design (04-API-DESIGN.md, if applicable)
  ├─ What interfaces are provided externally?
  ├─ What are the request/response formats?
  └─ How are error codes defined?
    ↓
Phase 5: Initialization Complete
  ├─ Create SPEC/VERSION
  ├─ Generate all documents
  └─ Provide follow-up guidance
```

**Key Principles**:
- ✅ **User-Driven Design**: Don't recommend solutions, only ask questions and collect information
- ✅ **Gradual Improvement**: Design one domain at a time to avoid information overload
- ✅ **Immediate Validation**: After completing each document, ask user for confirmation
- ❌ **No Code Generation**: Only generate SPEC documents, code handled by /programmer

---

## Step 1B: Existing Project - Reverse Generation

### 1B.1 Codebase Analysis

**Call Explore Tool**:
```python
Task(
    subagent_type="Explore",
    prompt="""
Analyze this codebase structure and functionality for generating SPEC documents.

Scan scope:
- All source code files
- Configuration files (package.json, go.mod, requirements.txt, etc.)
- Existing documentation (README.md, docs/, etc.)

Analysis content:
1. Project type and main functions
2. Technology stack (language, framework, database, middleware)
3. Module division and directory structure
4. Data models (if database-related code exists)
5. API interfaces (if HTTP/gRPC interfaces exist)
6. Core business logic

Output format:
- Project overview
- Function list
- Module structure
- Technology stack list
- Data model summary
- API interface list
"""
)
```

### 1B.2 SPEC Document Generation

**Generation Strategy**:
```
Based on Explore analysis results
    ↓
Identify missing SPEC documents
    ↓
Call architect skill to generate
    ↓
Show generated SPEC content
    ↓
Write to file after user confirmation
```

**Generation Standards**:
- ✅ Retain actual project content (don't fabricate)
- ✅ Use table format (language-agnostic)
- ✅ Mark sources (code location, file paths)
- ❌ Don't add content that doesn't exist in code
- ⚠️ Mark uncertain content as `[To Be Confirmed]`

**Example Output**:
```markdown
# 01-REQUIREMENTS.md (Reverse Generated)

## REQ-INIT-001: User Authentication (Source: auth/service.go)

**Function Description**: Based on code analysis, this module provides user authentication functionality

**User Roles**:
- Administrator (Source: role_admin table)
- Regular User (Source: role_user table)

**Core Functions**:
- [ ] User Login (Source: Login() function)
- [ ] User Registration (Source: Register() function)
- [ ] Token Verification (Source: VerifyToken() function)

**Items to Confirm**:
- [ ] Acceptance criteria need to be provided by user
- [ ] Business rules need additional explanation
```

---

## Step 1C: Partial SPEC - Supplement and Improve

### 1C.1 Missing Content Detection

**Check SPEC Completeness**:
```bash
# Check which SPEC files exist
ls -1 SPEC/*.md

# Check VERSION file
cat SPEC/VERSION

# Check ID definitions
grep -c "^REQ-" SPEC/01-REQUIREMENTS.md
grep -c "^ARCH-" SPEC/02-ARCHITECTURE.md
grep -c "^DATA-" SPEC/03-DATA-STRUCTURE.md
grep -c "^API-" SPEC/04-API-DESIGN.md
```

**Completeness Judgment Matrix**:

| SPEC File | Status | Processing Method |
|-----------|--------|-------------------|
| 01-REQUIREMENTS.md | Exists but <5 REQ-XXX items | Call architect to supplement |
| 02-ARCHITECTURE.md | Doesn't exist | Call architect to generate |
| 03-DATA-STRUCTURE.md | Doesn't exist | Call architect to generate |
| 04-API-DESIGN.md | Doesn't exist | Call architect to generate (if has APIs) |
| 05-UI-DESIGN.md | Doesn't exist | Call architect to generate (if frontend) |

### 1C.2 Supplement Generation

**Supplement Process**:
```
Detect missing content
    ↓
Show missing list to user
    ↓
Ask user for supplement strategy
  ├─ Auto-generate (based on code analysis)
  ├─ Interactive design (user-driven)
  └─ Mixed mode (part auto + part interactive)
    ↓
Call architect to execute supplement
    ↓
Verify SPEC completeness
```

---

## Step 2: SPEC Completeness Verification

### Verification Checklist

**File-Level Checks**:
- [ ] SPEC/VERSION exists and format is correct
- [ ] 01-REQUIREMENTS.md exists and contains REQ-XXX
- [ ] 02-ARCHITECTURE.md exists and contains ARCH-XXX
- [ ] 03-DATA-STRUCTURE.md exists (if has data)
- [ ] 04-API-DESIGN.md exists (if has APIs)
- [ ] 05-UI-DESIGN.md exists (if frontend)

**Content-Level Checks**:
- [ ] Each REQ-XXX has clear description
- [ ] Each ARCH-XXX has technology stack definition
- [ ] Each DATA-XXX has table structure definition
- [ ] Each API-XXX has interface definition
- [ ] No TODO/FIXME placeholders

**Association Checks**:
- [ ] REQ-XXX can be traced to DATA-XXX
- [ ] REQ-XXX can be traced to API-XXX
- [ ] Data models are consistent with APIs

---

## Step 3: Completion and Follow-up Guidance

### 3.1 Generate Completion Report

```markdown
## 🎉 SPEC Initialization Complete!

### Generated Documents
✅ SPEC/VERSION
✅ SPEC/01-REQUIREMENTS.md (X requirements)
✅ SPEC/02-ARCHITECTURE.md (X architecture decisions)
✅ SPEC/03-DATA-STRUCTURE.md (X data models)
✅ SPEC/04-API-DESIGN.md (X API interfaces)

### Next Steps
1. Review generated SPEC documents
2. Supplement [To Be Confirmed] content
3. Start development: /programmer
4. Update SPEC: /architect

### Continuous Improvement
- Update SPEC status after code implementation
- Supplement missing content promptly
- Regularly review SPEC-code consistency
```

### 3.2 Provide Quick Guidance

**Provide guidance based on project type**:

| Project Type | Next Step Recommendation |
|--------------|--------------------------|
| **Empty Project** | "You can now call /programmer to start development" |
| **Existing Project** | "Please review reverse-generated SPEC and supplement missing content" |
| **Partial SPEC** | "Missing parts have been supplemented, can continue development" |

---

## 🚨 Core Iron Laws

### Iron Law 1: User-Driven Design
- ❌ Prohibit recommending technology stacks or architecture solutions
- ❌ Prohibit making decisions for users
- ✅ Only ask questions, collect information, organize into documents
- ✅ Write to file only after user confirmation

### Iron Law 2: No Code Generation
- ❌ Prohibit generating any code in spec-init
- ❌ Prohibit creating Issues or calling programmer
- ✅ Only generate SPEC documents
- ✅ Code handled by /programmer

### Iron Law 3: Retain Actual Content
- ✅ Only reflect actual content in code when reverse-generating
- ❌ Don't add content that doesn't exist in code
- ⚠️ Mark uncertain content as `[To Be Confirmed]`

### Iron Law 4: Complete Delivery
- ❌ Prohibit leaving TODO/FIXME placeholders
- ✅ Must generate complete document structure at once
- ✅ `[To Be Confirmed]` markers are clear todos, not placeholders

---

## 📋 Output Specifications

### SPEC/VERSION Format
```
v1.0.0
```

### 01-REQUIREMENTS.md Template
```markdown
# Requirements Specification

## REQ-XXX: [Function Name]

**Description**: [Function description]

**User Roles**: [Role list]

**Acceptance Criteria**:
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]
```

### 02-ARCHITECTURE.md Template
```markdown
# Architecture Design

## ARCH-XXX: [Architecture Decision Name]

**Decision**: [Decision description]

**Reason**: [Selection reason]

**Technology Stack**:
- [Programming language]
- [Framework]
- [Database]
- [Middleware]
```

---

## 🔧 Technical Implementation

### Call Explore Tool

**Timing**: Step 1B (Existing project reverse generation)

**Purpose**: Comprehensive codebase scan to extract architecture information

**Input**: Project root directory path

**Output**: Structured project analysis report

### Call Architect Skill

**Timing**:
- Step 1A (Final phase of interactive design)
- Step 1B (After reverse generation to improve)
- Step 1C (Supplement missing SPEC)

**Purpose**: Generate/improve SPEC documents

**Input**: Collected project information or code analysis results

**Output**: SPEC documents conforming to architect standards

---

## 📊 Usage Examples

### Example 1: Empty Project Initialization

```
User: /spec-init

spec-init: Welcome! Let me help you establish SPEC documents.
spec-init: Detected this is an empty project.
spec-init: Please tell me the project name?

User: My User Authentication Service

spec-init: Understood. What type of project is this?
[User answers: Backend service, Go language, gRPC interfaces]

spec-init: Good. What are the core functions?
[User answers: Providing unified login, registration, permission management]

spec-init: Understood. Let me design SPEC for you...
[Generate interactive design questions]

spec-init: 🎉 SPEC initialization complete! Generated 5 documents.
spec-init: Next step: /programmer to start implementation
```

### Example 2: Existing Project Reverse Generation

```
User: /spec-init

spec-init: Detecting project status...
spec-init: Detected existing project (Go language, 123 files)
spec-init: Analyzing codebase...
[Call Explore tool]

spec-init: Analysis complete! Found:
spec-init: - 3 main modules: auth, user, api
spec-init: - 5 data tables: user, role, permission, token, session
spec-init: - 12 API interfaces

spec-init: Generating SPEC documents...
[Generate reverse SPEC]

spec-init: 🎉 SPEC initialization complete!
spec-init: ⚠️ Found 12 [To Be Confirmed] items, please review and supplement.
spec-init: Next step: Review SPEC → /programmer to start development
```

---

