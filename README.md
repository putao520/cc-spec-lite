# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code

CC-SPEC-Lite provides a streamlined, professional approach to AI-assisted software development with design-first workflow, role-based skills, and automation scripts.

## Table of Contents

- [What is CC-SPEC-Lite?](#what-is-cc-spec-lite)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Custom Commands](#custom-commands)
- [Skills](#skills)
- [Scripts](#scripts)
- [Roles](#roles)
- [SPEC Structure](#spec-structure)
- [Development Workflow](#development-workflow)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## What is CC-SPEC-Lite?

CC-SPEC-Lite is a focused, lightweight SPEC-driven development framework for Claude Code. It streamlines professional software engineering by concentrating on core development activities:

- **Design-First Approach**: All development starts with architecture and specification documents
- **Role-Based Skills**: Specialized AI agents for architecture (architect) and implementation (programmer)
- **Automated Workflows**: Cross-platform scripts for Git operations and AI CLI execution
- **Coding Standards**: Role-based guidelines for frontend, backend, and database development
- **Interactive Guidance**: AI-driven SPEC initialization through dialogue and questions

## Features

### Core Capabilities

- **SPEC-Driven Development**: Single source of truth with structured documents
- **Specialized Skills**:
  - `architect`: System architecture design and SPEC management
  - `programmer`: Production code development with code review
  - `readme`: Project documentation specialist
- **Custom Commands**:
  - `/spec-init`: Interactive SPEC initialization for new projects
  - `/spec-audit`: Verify SPEC completeness and code consistency
- **Cross-Platform Scripts**: Bash and PowerShell support for Linux, macOS, and Windows
- **Automated Git Workflows**: Issue tracking, commit generation, and SPEC status updates
- **Role-Based Standards**: Consistent coding guidelines across different domains

### Key Benefits

✅ **Consistency**: Standardized development workflow across all projects
✅ **Quality**: Built-in code review and SPEC validation
✅ **Traceability**: Every code change traces back to SPEC requirements
✅ **Automation**: Reduced manual work with intelligent scripts
✅ **Flexibility**: Works with any technology stack

### What's NOT Included

This is the **Lite version** focused on requirements and development:
- ❌ No test coverage verification
- ❌ No code quality analysis
- ❌ No security auditing
- ❌ No delivery validation

For complete testing, quality, and delivery features, use the full **cc-spec** framework.

## Installation

### Prerequisites

- **Claude Code**: v2.0.12 or higher
- **AI Warden CLI (aiw)**: v1.0.0 or higher
  - Required for running AI CLI with role-based context
  - Installation: https://github.com/putao520/agentic-warden
  - Verify: `aiw --version`
- **Git**: For version control operations
- **Shell Environment**:
  - Linux: Bash (native)
  - macOS: Bash or Zsh (native)
  - Windows: PowerShell 5.1+, Git Bash, or WSL

### Method 1: Via Plugin Marketplace (Recommended)

```bash
# Add marketplace
claude plugin marketplace add putao520/cc-spec-lite

# Install plugin
claude plugin install cc-spec-lite@cc-spec-lite
```

### Method 2: Manual Installation

```bash
# Clone repository
git clone https://github.com/putao520/cc-spec-lite.git

# Copy to Claude config directory
cp -r cc-spec-lite/* ~/.claude/

# Verify installation
ls ~/.claude/skills/
```

### Method 3: Development Installation

```bash
# Clone for development
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite

# Create symbolic link (optional, for active development)
ln -sf $(pwd)/skills ~/.claude/skills
ln -sf $(pwd)/scripts ~/.claude/scripts
ln -sf $(pwd)/roles ~/.claude/roles
```

### Verification

After installation, verify the skills are available:

```bash
# In Claude Code
/architect --help
/programmer --help
```

## Quick Start

### 1. Initialize a New Project

```bash
# Create project directory
mkdir my-project
cd my-project

# Initialize Git
git init

# Create SPEC directory
mkdir -p SPEC/DOCS
echo "v1.0.0" > SPEC/VERSION
```

### 2. Design Your Architecture

```bash
# Start architect skill
/architect

# Define requirements, architecture, data models, and APIs
# Architect will create/update:
# - SPEC/01-REQUIREMENTS.md
# - SPEC/02-ARCHITECTURE.md
# - SPEC/03-DATA-STRUCTURE.md
# - SPEC/04-API-DESIGN.md
# - SPEC/05-UI-DESIGN.md (if frontend)
```

### 3. Implement Features

```bash
# Start programmer skill
/programmer

# Programmer will:
# - Read SPEC documents
# - Create implementation plan
# - Generate production code
# - Perform code review
# - Commit changes with proper format
```

## Custom Commands

CC-SPEC-Lite provides two custom commands to streamline SPEC management:

### /spec-init - SPEC Initialization

**Purpose**: Initialize project SPEC with AI-driven interactive guidance

**Usage**:
```bash
/spec-init
```

**Modes**:

**New Project (Empty Directory)**:
- Interactive dialogue to understand your project
- AI asks focused questions based on your description
- Derives architecture, data models, and API design
- Calls `/architect` to generate complete SPEC

**Existing Project (With Code)**:
- Automatically detects existing codebase
- Routes to `/architect` for code analysis
- Generates SPEC with inferred content (marked as `[推断]`)

**Already Has SPEC**:
- Detects existing SPEC
- Prompts to use `/architect` for modifications

**Example**:
```
User: /spec-init
AI: Please describe your project you want to build:
User: I want to build an e-commerce backend with multi-merchant support
AI: [Asks clarifying questions about merchant isolation, payment, etc.]
AI: [Shows understanding summary]
User: Confirm understanding
AI: [Calls /architect to generate SPEC]
```

**Key Features**:
- ✅ Open-ended dialogue (no fixed options)
- ✅ AI asks only relevant questions
- ✅ Understanding confirmation before generation
- ❌ No complex code analysis (delegates to /architect)

### /spec-audit - SPEC Validation

**Purpose**: Verify SPEC completeness and code consistency

**Usage**:
```bash
/spec-audit
```

**What It Checks**:

1. **Format Validation**
   - File structure completeness
   - ID format correctness (REQ-XXX/ARCH-XXX/DATA-XXX/API-XXX)
   - VERSION format

2. **Requirement Completeness**
   - Acceptance criteria for each REQ-XXX
   - Priority levels (P0/P1/P2)
   - Traceability to code implementation

3. **Architecture Consistency**
   - Module implementation matches ARCH-XXX
   - Technology stack alignment
   - Dependency relationships

4. **Data Model Consistency**
   - Database schema matches DATA-XXX
   - Foreign key relationships
   - Required indexes

5. **API Consistency**
   - Endpoint implementation matches API-XXX
   - Error code coverage
   - Authentication/authorization

**What It Does NOT Check** (Lite version):
- ❌ Test coverage
- ❌ Code quality metrics
- ❌ Security vulnerabilities
- ❌ Delivery readiness

**Output**: Generates comprehensive audit report with scores, issues, and improvement suggestions

**Example**:
```markdown
# SPEC Audit Report
Format Completeness: ✅ 100%
Requirement Completeness: ⚠️  85%
Architecture Consistency: ✅ 90%
Data Consistency: ⚠️  75%
API Consistency: ✅ 95%

Overall Score: 89%

Issues Found:
- REQ-USER-005 missing acceptance criteria
- DATA-PRODUCT-001 missing idx_price index
- API-USER-001 response format mismatch

Suggestions: Use /architect to fix issues, /programmer to implement missing features
```

## Skills

### Architect

**Purpose**: System architecture design and SPEC management

**Usage**:
```bash
/architect
```

**Capabilities**:
- Define functional requirements (REQ-XXX)
- Design system architecture (ARCH-XXX)
- Specify data models (DATA-XXX)
- Design API interfaces (API-XXX)
- Create UI/UX specifications (UI-XXX)

**When to Use**:
- Starting a new project
- Adding new features
- Refactoring architecture
- Changing requirements
- Designing APIs or data structures

**Example Workflow**:
```
User: "I need to add user authentication"
Architect: Analyzes requirements → Creates REQ-AUTH-001 →
          Designs authentication flow → Updates SPEC →
          Assigns ARCH-AUTH-001, API-AUTH-001
```

### Programmer

**Purpose**: Production code development and implementation

**Usage**:
```bash
/programmer
```

**Capabilities**:
- Read and validate SPEC documents
- Create implementation plans
- Generate production-ready code
- Perform code reviews
- Commit changes with proper format

**When to Use**:
- Implementing features defined in SPEC
- Fixing bugs
- Refactoring code

**Example Workflow**:
```
User: "Implement REQ-AUTH-001"
Programmer: Reads SPEC → Creates plan →
           Generates code → Reviews against SPEC →
           Commits changes
```

### Readme

**Purpose**: Project documentation specialist

**Usage**:
```bash
/readme
```

**Capabilities**:
- Create comprehensive README.md
- Document installation procedures
- Write usage examples
- Maintain configuration guides
- Update contributing guidelines

**When to Use**:
- Project initialization
- Adding new features
- Updating documentation
- Preparing for release

## Scripts

### AI CLI Runner

Executes AI CLI with role-based context and SPEC integration.

> **Note**: This script requires [AI Warden CLI (aiw)](https://github.com/putao520/agentic-warden) to be installed.

**Bash**:
```bash
~/.claude/scripts/ai-cli-runner.sh <role> <requirements> <description>
```

**PowerShell**:
```powershell
~\.claude\scripts\ai-cli-runner.ps1 <role> <requirements> <description>
```

**Roles**: `fullstack`, `backend`, `frontend`, `database`, `system`, `deployment`, `devops`, `assistant-programmer`

**Example**:
```bash
# Backend development
ai-cli-runner.sh backend 'REQ-AUTH-001,REQ-AUTH-002' 'Implement authentication and authorization'

# Frontend development
ai-cli-runner.sh frontend 'REQ-UI-001' 'Create user dashboard component'
```

### Commit and Close

Commit changes and close GitHub issues with automatic SPEC tracking.

**Bash**:
```bash
~/.claude/scripts/commit-and-close.sh --message "feat: Add user login [REQ-AUTH-001]" --issue 123
```

**PowerShell**:
```powershell
~\.claude\scripts\commit-and-close.ps1 -Message "feat: Add user login" -Issue 123
```

**Features**:
- Automatic commit formatting
- Issue closing
- SPEC status updates
- Pre-commit hooks

### SPEC Pre-Commit Hook

Validates SPEC integrity before allowing commits.

**Installation**:
```bash
ln -sf ~/.claude/scripts/spec-pre-commit-hook.sh .git/hooks/pre-commit
```

**Checks**:
- Sensitive files (blocking)
- Code-SPEC association (warning)
- SPEC format validation (error/warning)
- Test traceability (warning)

### Update SPEC Status

Updates requirement statuses in SPEC documents after implementation.

**Bash**:
```bash
~/.claude/scripts/update-spec-status.sh REQ-AUTH-001 implemented
```

**PowerShell**:
```powershell
~\.claude\scripts\update-spec-status.ps1 REQ-AUTH-001 implemented
```

## Roles

Role-based coding standards ensure consistency across different development domains.

### Available Roles

| Role | File | Description |
|------|------|-------------|
| **Common** | `roles/common.md` | General development standards applicable to all projects |
| **Frontend** | `roles/frontend-standards.md` | React/Vue/Angular best practices, component design, state management |
| **Database** | `roles/database-standards.md` | Schema design, indexing, migrations, SQL/NoSQL patterns |

**Usage**: Roles are automatically loaded by the programmer skill based on project type.

## SPEC Structure

CC-SPEC-Lite uses a structured approach to project specification:

```
SPEC/
├── VERSION                    # Current version (v{major}.{minor}.{patch})
├── 01-REQUIREMENTS.md         # Functional requirements (REQ-XXX)
├── 02-ARCHITECTURE.md         # System architecture (ARCH-XXX)
├── 03-DATA-STRUCTURE.md       # Data models (DATA-XXX)
├── 04-API-DESIGN.md           # API specifications (API-XXX)
├── 05-UI-DESIGN.md            # UI/UX design (UI-XXX) [optional]
└── DOCS/                      # Extended documentation
    ├── architecture.md        # Detailed architecture docs
    ├── data-flow.md           # Data flow diagrams
    └── algorithm-design.md    # Algorithm specifications
```

### ID Format Convention

- **Requirements**: `REQ-{DOMAIN}-{NUMBER}` (e.g., `REQ-AUTH-001`)
- **Architecture**: `ARCH-{DOMAIN}-{NUMBER}` (e.g., `ARCH-CACHE-001`)
- **Data**: `DATA-{TABLE}-{NUMBER}` (e.g., `DATA-USER-001`)
- **API**: `API-{MODULE}-{NUMBER}` (e.g., `API-AUTH-001`)
- **UI**: `UI-PAGE-{MODULE}-{NUMBER}` or `UI-COMP-{TYPE}-{NUMBER}`

## Development Workflow

### Phase 1: Architecture Design

```bash
/architect
```

1. Define requirements in `01-REQUIREMENTS.md`
2. Design architecture in `02-ARCHITECTURE.md`
3. Specify data models in `03-DATA-STRUCTURE.md`
4. Design APIs in `04-API-DESIGN.md`
5. (Optional) Design UI in `05-UI-DESIGN.md`

### Phase 2: Implementation

```bash
/programmer
```

1. Programmer reads and validates SPEC
2. Creates implementation plan
3. Generates production code
4. Performs code review against SPEC
5. Commits with proper format

### Phase 3: Verification

- Code review successful
- SPEC requirements met
- Documentation updated

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_CODE_HOME` | Claude Code installation directory | `~/.claude` |
| `SPEC_AUTO_COMMIT` | Enable auto-commit after SPEC updates | `false` |
| `GIT_TEMPLATE_DIR` | Git template directory for hooks | `~/.claude/templates` |

### Claude Code Configuration

Add to `~/.claude/settings.json`:

```json
{
  "skillsPath": "~/.claude/skills",
  "scriptsPath": "~/.claude/scripts",
  "rolesPath": "~/.claude/roles",
  "specPath": "./SPEC"
}
```

### Git Configuration

Recommended Git aliases:

```bash
git config --global alias.spec-commit '!~/.claude/scripts/commit-and-close.sh'
```

## Troubleshooting

### Common Issues

**Issue**: aiw command not found

**Solution**:
```bash
# AI Warden CLI is required for ai-cli-runner scripts
# Install from: https://github.com/putao520/agentic-warden

# Verify installation
aiw --version

# If not installed, follow installation guide from:
# https://github.com/putao520/agentic-warden#installation
```

**Issue**: Skills not found after installation

**Solution**:
```bash
# Verify installation
ls -la ~/.claude/skills/

# Check file permissions
chmod +x ~/.claude/scripts/*.sh

# Restart Claude Code
```

**Issue**: Pre-commit hook not executing

**Solution**:
```bash
# Reinstall hook
ln -sf ~/.claude/scripts/spec-pre-commit-hook.sh .git/hooks/pre-commit

# Verify executable
chmod +x .git/hooks/pre-commit
```

**Issue**: PowerShell scripts blocked on Windows

**Solution**:
```powershell
# Check execution policy
Get-ExecutionPolicy

# Allow scripts (current user)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

**Issue**: SPEC documents not found

**Solution**:
```bash
# Verify SPEC directory exists
ls -la SPEC/

# Create if missing
mkdir -p SPEC/DOCS
echo "v1.0.0" > SPEC/VERSION
```

### Debug Mode

Enable verbose logging:

```bash
# Set environment variable
export DEBUG=true
export VERBOSE=true

# Run scripts with debug output
~/.claude/scripts/ai-cli-runner.sh backend 'REQ-001' 'Debug mode'
```

### Getting Help

- **Documentation**: Check `SPEC/DOCS/` for detailed guides
- **Issues**: Report bugs at https://github.com/putao520/cc-spec-lite/issues
- **Discussions**: Ask questions at https://github.com/putao520/cc-spec-lite/discussions

## Contributing

Contributions are welcome! Please follow these guidelines:

### Contribution Workflow

1. **Fork** the repository
2. **Create** a feature branch
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit** your changes
   ```bash
   ~/.claude/scripts/commit-and-close.sh --message "feat: Add amazing feature" --issue 123
   ```
4. **Push** to the branch
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open** a Pull Request

### Contribution Guidelines

- Follow the SPEC-driven development workflow
- Update documentation for new features
- Follow existing code style and standards
- Write clear, descriptive commit messages

### Code Review Process

All submissions go through code review:
1. Automated checks (pre-commit hooks)
2. Peer review (maintainer approval)
3. SPEC validation (requirements must be met)

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

## Acknowledgments

- Built for [Claude Code](https://claude.ai/code)
- Inspired by professional software engineering practices
- Community-driven development

---

**Version**: 1.0.0
**Repository**: https://github.com/putao520/cc-spec-lite
**Author**: putao
**License**: MIT
