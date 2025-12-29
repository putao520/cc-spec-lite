# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code

**What problem does it solve?**

Provides a complete **system-level specification framework** for AI-assisted software development in **Chinese environments**, ensuring long-term consistency across requirements, architecture, and implementation.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Uninstallation](#uninstallation)
- [Usage](#usage)
- [Features](#features)
- [Comparison](#comparison)
- [FAQ](#faq)
- [Contributing](#contributing)

---

## Quick Start

### 3-Minute Setup

```bash
# Step 1: Install via npm
npm install -g @putao520/cc-spec-lite

# Step 2: Run installer
cc-spec install

# Step 3: Start using
cd my-project
/spec-init           # Initialize SPEC
```

**What happens**:
- ✅ Auto-detects your system language (Chinese → zh, Others → en)
- ✅ Backs up your existing `~/.claude/` configuration
- ✅ Installs all necessary files
- ✅ Sets up AI Warden CLI (aiw)

---

## Installation

### Method 1: Install from npm

```bash
npm install -g @putao520/cc-spec-lite
cc-spec install
```

### Method 2: Install from source

```bash
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite
npm install -g .
cc-spec install
```

---

### Language Options

**Auto-detection** (Recommended):
```bash
cc-spec install
# Automatically detects system locale
# China (zh_CN) → Chinese version
# Other regions → English version
```

**Manual selection**:
```bash
# English version
cc-spec install --lang en

# Chinese version
cc-spec install --lang zh
```

---

### Language Switching

```bash
# Switch to Chinese
cc-spec install --lang zh --force

# Switch to English
cc-spec install --lang en --force
```

**What happens**:
- Shows current installed language
- Asks: Keep current / Switch / Cancel
- Backs up before switching

---

### All Commands

```bash
# Install
cc-spec install [options]
  -l, --lang <en|zh>     Language (default: auto-detect)
  -f, --force           Force reinstall (allows language switching)
  --skip-aiw           Skip aiw check

# Uninstall
cc-spec uninstall

# Update
cc-spec update

# Check status
cc-spec status

# Quick aliases
spec-install          # Same as 'cc-spec install'
spec-status          # Same as 'cc-spec status'
spec-update          # Same as 'cc-spec update'
```

---

### What Gets Installed

Files are copied to `~/.claude/`:

| Directory | Contents |
|-----------|----------|
| `skills/` | Architect, Programmer, Testing skills |
| `commands/` | /spec-init, /spec-audit |
| `scripts/` | Git hooks, AI CLI runners |
| `roles/` | Coding standards |
| `CLAUDE.md` | Global development rules |

**Platform-specific paths**:
- **Linux/macOS**: `~/.claude/`
- **Windows**: `C:\Users\YourName\.claude\`

---

### Backup and Restore

**Automatic backup on install**:
```
~/.claude/backup/cc-spec-lite-2025-12-29T14-30-00/
└── (Complete backup of pre-installation files)
```

**Restore on uninstall**:
```bash
cc-spec uninstall
# Asks: Restore pre-installation backup?
```

---

## Uninstallation

### Standard Uninstall

```bash
cc-spec uninstall
```

**Prompts you**:
1. Confirm uninstall
2. Restore backup (if available)

**What gets removed**:
- ✅ Skills, commands, scripts, roles
- ✅ CLAUDE.md
- ✅ Backup info file
- ❌ Backup directory (kept for safety)

### Clean Uninstall (Remove backups)

```bash
# After standard uninstall
rm -rf ~/.claude/backup/cc-spec-lite-*    # Linux/macOS
rmdir /s "%USERPROFILE%\.claude\backup\cc-spec-lite-*"  # Windows
```

### Remove npm Package

```bash
npm uninstall -g @putao520/cc-spec-lite
```

---

## Usage

### Basic Workflow

```
1. Initialize: /spec-init → Create project SPEC
2. Design: Discuss requirements with Claude → Auto invokes architect skill
3. Develop: Say "Start development" → Auto invokes programmer skill
4. Validate: /spec-audit → Verify SPEC completeness
```

**Key Point**: You don't manually invoke `/architect` or `/programmer`. Claude Code automatically selects the appropriate skill based on conversation context.

### Example Project

```bash
# Create project
mkdir my-app
cd my-app
git init

# Initialize SPEC
/spec-init
# Answer questions about your project

# Review generated SPEC
cat SPEC/01-REQUIREMENTS.md

# Start development - just say "Let's implement this"
# Claude Code will automatically use programmer skill
```

### Available Skills

These are **automatically invoked** by Claude Code based on context:

| Skill | Purpose |
|-------|---------|
| `architect` | System design and SPEC management |
| `programmer` | Code implementation |
| `readme` | Documentation |
| `testing` | E2E and integration tests |
| `devloop` | SPEC-test validation loop |

### Custom Commands

These are **explicit commands** you invoke:

| Command | Purpose |
|---------|---------|
| `/spec-init` | Interactive SPEC initialization |
| `/spec-audit` | Verify SPEC completeness |

---

### Scripts

**AI CLI Runner**:
```bash
# Linux/macOS
~/.claude/scripts/ai-cli-runner.sh backend 'REQ-AUTH-001' 'Implement authentication'

# Windows PowerShell
~\.claude\scripts\ai-cli-runner.ps1 backend 'REQ-AUTH-001' 'Implement authentication'
```

**Git Utilities**:
```bash
# Commit with SPEC reference
~/.claude/scripts/commit-and-close.sh --message "feat: Add login [REQ-AUTH-001]" --issue 123

# Update SPEC status
~/.claude/scripts/update-spec-status.sh REQ-AUTH-001 implemented
```

---

## Features

### Core Capabilities

- ✅ **SPEC-Driven Development**
  - Single source of truth
  - Structured requirements
  - Traceable changes

- ✅ **Role-Based Skills**
  - Architect for design
  - Programmer for implementation
  - Automatic code review

- ✅ **Cross-Platform**
  - Linux, macOS, Windows support
  - Auto-detects system language
  - Native Bash and PowerShell scripts

- ✅ **Safe Installation**
  - Automatic backup before install
  - Restore option on uninstall

---

## Comparison

### Problem Domain

| Dimension | OpenSpec | cc-spec-lite |
|-----------|----------|--------------|
| **Coverage** | Task-level requirements | System-level specifications |
| **Target** | Individual features | Long-term projects |
| **Primary Use** | Feature description | System consistency |
| **Language** | English-focused | Full bilingual |
| **Environment** | International | Chinese developers |
| **Spec Scope** | Feature requirements | Requirements + Architecture + Data + API |
| **Roles** | Not covered | Architect ↔ Programmer ↔ Testing |
| **Maintenance** | Per-feature | System-level SSOT |
| **AI CLI** | None | aiw with role injection |

### Specification Documents

| OpenSpec | cc-spec-lite |
|----------|--------------|
| Feature spec | `01-REQUIREMENTS.md` (REQ-XXX) |
| (No equivalent) | `02-ARCHITECTURE.md` (ARCH-XXX) |
| (No equivalent) | `03-DATA-STRUCTURE.md` (DATA-XXX) |
| Interface spec | `04-API-DESIGN.md` (API-XXX) |
| (No equivalent) | `05-UI-DESIGN.md` (UI-XXX) |

---

## FAQ

### How do I switch languages?

```bash
cc-spec install --lang zh --force   # Switch to Chinese
cc-spec install --lang en --force   # Switch to English
```

### Will I lose my existing configuration?

**No**. The installer automatically backs up your existing `~/.claude/` before installing. On uninstall, you can choose to restore the backup.

### Where are files installed?

| Platform | Location |
|----------|----------|
| Linux/macOS | `~/.claude/` |
| Windows | `C:\Users\YourName\.claude\` |

### How do I update?

```bash
npm update -g @putao520/cc-spec-lite
cc-spec update
```

### What is AI Warden CLI (aiw)?

AI Warden CLI is a required dependency for running AI agents with role-based context. It will be automatically installed during cc-spec-lite setup.

**Install manually**:
```bash
npm install -g @putao520/agentic-warden
```

### Skills not found after installation?

```bash
# Verify installation
cc-spec status

# Check files
ls -la ~/.claude/skills/    # Linux/macOS
dir %USERPROFILE%\.claude\skills\   # Windows

# Restart Claude Code
```

---

## Requirements

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **Git** (for version control)
- **Claude Code** (AI development environment)

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Follow SPEC-driven development workflow
4. Submit a pull request

**Development workflow**:
```bash
# Initialize project SPEC
/spec-init

# Design your changes
/architect

# Implement
# Just say "Let's implement this" - Claude Code auto-invokes programmer

# Validate
/spec-audit
```

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## Links

- **GitHub**: https://github.com/putao520/cc-spec-lite
- **Issues**: https://github.com/putao520/cc-spec-lite/issues
- **Discussions**: https://github.com/putao520/cc-spec-lite/discussions
- **AI Warden CLI**: https://github.com/putao520/agentic-warden

---

**Version**: 0.0.1
**Repository**: https://github.com/putao520/cc-spec-lite
**Author**: putao520 <yuyao1022@hotmail.com>
