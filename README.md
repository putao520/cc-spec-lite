# CC-SPEC-Lite

A lightweight SPEC-driven development framework for Claude Code.

## Overview

CC-SPEC-Lite provides a streamlined approach to AI-assisted software development:

- **SPEC-Driven Development**: Design-first workflow with single source of truth
- **Core Skills**: Architect for design, Programmer for implementation
- **Automation Scripts**: Git commit workflows and AI CLI runner

## Installation

### Via Plugin Marketplace

```bash
# Add marketplace
/plugin marketplace add putao520/cc-spec-lite

# Install plugin
/plugin install cc-spec-lite@cc-spec-lite
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/putao520/cc-spec-lite.git

# Copy to Claude config directory
cp -r cc-spec-lite/* ~/.claude/
```

## Skills

| Skill | Description |
|-------|-------------|
| **architect** | System architecture design and SPEC management |
| **programmer** | Production code development and implementation |
| **readme** | Project documentation specialist |

### Usage

```bash
/architect    # Start architecture design session
/programmer   # Execute code implementation
```

## Scripts

Cross-platform scripts available in both Bash and PowerShell:

| Script (Bash) | Script (PowerShell) | Purpose |
|---------------|---------------------|---------|
| `ai-cli-runner.sh` | `ai-cli-runner.ps1` | Execute AI CLI with role-based context |
| `commit-and-close.sh` | `commit-and-close.ps1` | Commit changes and close GitHub issues |

## Roles (Coding Standards)

| Role | Description |
|------|-------------|
| common | General development standards |
| frontend-standards | Frontend development guidelines |
| database-standards | Database design standards |

## SPEC Structure

```
SPEC/
├── 01-REQUIREMENTS.md      # Functional requirements (REQ-XXX)
├── 02-ARCHITECTURE.md      # System architecture (ARCH-XXX)
├── 03-DATA-STRUCTURE.md    # Data models (DATA-XXX)
├── 04-API-DESIGN.md        # API specifications (API-XXX)
├── 05-UI-DESIGN.md         # UI/UX design (UI-XXX)
└── DOCS/                   # Extended documentation
```

## Core Principles

1. **SPEC is Truth**: Design documents are authoritative
2. **No Shortcuts**: Complete implementation required
3. **Code Review**: All code must be verified

## Requirements

- Claude Code v2.0.12+
- Git
- Shell environment (one of the following):

| Platform | Shell | Notes |
|----------|-------|-------|
| Linux | Bash | Native support |
| macOS | Bash/Zsh | Native support |
| Windows | PowerShell 5.1+ | Use `.ps1` scripts |
| Windows | Git Bash | Use `.sh` scripts |
| Windows | WSL | Use `.sh` scripts |

## License

MIT License - see [LICENSE](LICENSE) for details.
