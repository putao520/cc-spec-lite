---
description: SPEC Initialization - AI-driven interactive project SPEC creation
argument-hint: [project path (optional)]
---

# SPEC Initialization Command

## Core Responsibilities

**Unified entry point for SPEC initialization, intelligently routes based on project state**

- ❌ **Don't do** complex code analysis
- ❌ **Don't do** SPEC format inference
- ✅ **Only do** project state detection
- ✅ **Only do** interactive information collection (for new projects)
- ✅ **Only do** intelligent routing to /architect

---

## Execution Flow

### Phase 0: Project State Detection (Automatic)

```bash
# 1. Check if SPEC/ exists and is complete
if [ -d "SPEC" ]; then
    spec validate SPEC/ 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ SPEC fully initialized"
        echo "Use /architect to modify existing SPEC"
        exit 0
    fi
fi

# 2. Check if this is a new project
if [ ! -d ".git" ]; then
    echo "⚠️  Not a git repository"
    echo "Recommended: git init first"
fi

# 3. Detect project type
if [ -f "package.json" ]; then
    PROJECT_TYPE="node"
elif [ -f "pom.xml" ]; then
    PROJECT_TYPE="java"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
else
    PROJECT_TYPE="unknown"
fi
```

---

### Phase 1: New Project Interactive Dialogue

**For projects without SPEC or with incomplete SPEC:**

```markdown
## Interactive Information Collection

### Question 1: Project Name
**AI**: What is your project name?
**User**: [e.g., E-commerce Backend System]

### Question 2: Project Type
**AI**: What type of project is this?
- Web Application
- Mobile Application
- Desktop Application
- API Service
- Library/SDK
- Other

**User**: [Select one]

### Question 3: Primary Technology Stack
**AI**: What are the main technologies?
**User**: [e.g., Next.js + PostgreSQL + Prisma]

### Question 4: Core Features
**AI**: What are the core features? List them briefly.
**User**: [e.g., User authentication, Product catalog, Order processing, Payment integration]

### Question 5: Special Requirements
**AI**: Any special requirements or constraints?
- Performance requirements
- Security requirements
- Compliance requirements
- Deployment environment
- Other

**User**: [Optional description]

### Question 6: Development Team Size
**AI**: What is your team size?
- Solo (1 person)
- Small team (2-5 people)
- Medium team (6-20 people)
- Large team (20+ people)

**User**: [Select one]
```

---

### Phase 2: Generate SPEC Structure

After collecting information, route to `/architect` with context:

```markdown
/architect, please help initialize SPEC for this project:

**Project Information Collected**:
- Name: {project_name}
- Type: {project_type}
- Tech Stack: {tech_stack}
- Core Features: {core_features}
- Special Requirements: {special_requirements}
- Team Size: {team_size}

**Required Actions**:
1. Create SPEC/ directory structure
2. Generate VERSION file (v0.1.0)
3. Create 01-REQUIREMENTS.md with REQ-XXX IDs for core features
4. Create 02-ARCHITECTURE.md with system architecture
5. Create 03-DATA-STRUCTURE.md if database is used
6. Create 04-API-DESIGN.md if it's an API service
7. Assign appropriate IDs (REQ-XXX, ARCH-XXX, DATA-XXX, API-XXX)

**User Confirmation**: Please present the generated SPEC for review before finalizing.
```

---

### Phase 3: Existing Project SPEC Analysis

**For projects with existing SPEC:**

```bash
# Check SPEC completeness
spec validate SPEC/ 2>/dev/null
VALIDATION_RESULT=$?

if [ $VALIDATION_RESULT -ne 0 ]; then
    echo "⚠️  SPEC validation failed"
    echo ""
    echo "Issues found:"
    spec validate SPEC/ 2>&1 | grep -E "ERROR|WARNING"
    echo ""
    echo "Use /architect to fix SPEC issues"
    exit 1
fi

echo "✅ SPEC is valid and complete"
echo ""
echo "Current SPEC status:"
echo "- Requirements: $(grep -c 'REQ-' SPEC/01-REQUIREMENTS.md 2>/dev/null || echo 0)"
echo "- Architecture: $(grep -c 'ARCH-' SPEC/02-ARCHITECTURE.md 2>/dev/null || echo 0)"
echo "- Data Models: $(grep -c 'DATA-' SPEC/03-DATA-STRUCTURE.md 2>/dev/null || echo 0)"
echo "- API Definitions: $(grep -c 'API-' SPEC/04-API-DESIGN.md 2>/dev/null || echo 0)"
```

---

## Output Format

### Success Output

```markdown
✅ SPEC Initialization Complete!

**Project**: [Project Name]
**Location**: ./SPEC/

**Generated Files**:
- ✅ VERSION (v0.1.0)
- ✅ 01-REQUIREMENTS.md (3 requirements)
- ✅ 02-ARCHITECTURE.md (system architecture)
- ✅ 03-DATA-STRUCTURE.md (data models)
- ✅ 04-API-DESIGN.md (API specifications)

**Next Steps**:
1. Review generated SPEC files
2. Use /spec-audit to verify completeness
3. Start development with /programmer

**Quick Actions**:
- /spec-audit      # Verify SPEC completeness
- /architect       # Modify SPEC
- /programmer      # Start implementation
```

### Error Output

```markdown
❌ SPEC Initialization Failed

**Error**: [Error description]

**Common Issues**:
- Not in a project directory
- Git repository not initialized
- Insufficient permissions

**Suggestions**:
- [Suggested actions]
```

---

## Integration with Other Commands

```
/spec-init
    ↓ (initialize SPEC)
/spec-audit
    ↓ (verify completeness)
/architect
    ↓ (improve/refine SPEC)
/programmer
    ↓ (implement based on SPEC)
/spec-audit (final check)
```

---

## Examples

### Example 1: New Node.js API Project

```bash
/spec-init

**Dialogue**:
AI: What is your project name?
User: Task Management API

AI: What type of project is this?
User: API Service

AI: What are the main technologies?
User: Node.js, Express, PostgreSQL, Prisma

AI: What are the core features?
User: User authentication, task CRUD, team collaboration

AI: Any special requirements?
User: RESTful API, JWT auth, real-time notifications

**Generated SPEC**:
- REQ-TASK-001: User Authentication
- REQ-TASK-002: Task Management
- REQ-TASK-003: Team Collaboration
- ARCH-TASK-001: API Architecture
- ARCH-TASK-002: Database Design
- DATA-TASK-001: users table
- DATA-TASK-002: tasks table
- API-TASK-001: Auth endpoints
- API-TASK-002: Task endpoints
```

### Example 2: Existing Project

```bash
/spec-init

**Output**:
✅ Project already has SPEC

SPEC Status:
- Requirements: 12 defined
- Architecture: Complete
- Data Models: 8 tables
- API Definitions: 25 endpoints

Status: ✅ Complete

Use /architect to modify SPEC
```

---

## Key Principles

**Minimalism**:
- Only guide the user through essential questions
- Don't overwhelm with technical details
- Let architect handle complex design

**Smart Routing**:
- New projects → Interactive dialogue → Generate SPEC
- Existing projects → Analyze SPEC → Report status
- Incomplete SPEC → Suggest improvements

**User Control**:
- User is the expert, AI is the guide
- User confirms before finalizing SPEC
- User can skip optional questions

---

## Error Handling

```bash
# Not in project directory
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: Not a git repository"
    echo "Recommend: git init"
fi

# SPEC already exists
if [ -d "SPEC" ] && [ -f "SPEC/01-REQUIREMENTS.md" ]; then
    echo "⚠️  SPEC already exists"
    read -p "Overwrite? [y/N]: " overwrite
    if [[ "$overwrite" != "y" && "$overwrite" != "Y" ]]; then
        exit 0
    fi
fi

# Architect not available
if ! command -v architect &> /dev/null; then
    echo "❌ /architect command not available"
    echo "Please install cc-spec-lite framework"
    exit 1
fi
```

---

**Note**: This command is a thin router. It detects project state and routes appropriately without performing complex analysis itself. All SPEC generation is handled by the /architect skill.
