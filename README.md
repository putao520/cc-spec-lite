# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code

**What problem does it solve?**

Provides a complete **system-level specification framework** for AI-assisted software development, ensuring long-term consistency across requirements, architecture, and implementation.

---

## Quick Start

### 3-Minute Setup

```bash
npm install -g @putao520/cc-spec-lite
cc-spec install
```

That's it! Framework is now installed and ready to use.

---

## Installation

### Install from npm

```bash
npm install -g @putao520/cc-spec-lite
cc-spec install
```

### Install from source

```bash
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite
npm install -g .
cc-spec install
```

---

### Language Selection

**Auto-detection** (Recommended):
```bash
cc-spec install
# China (zh_CN) → Chinese version
# Other regions → English version
```

**Manual selection**:
```bash
cc-spec install --lang en    # English
cc-spec install --lang zh    # Chinese
```

---

### Switch Languages

```bash
cc-spec install --lang zh --force   # Switch to Chinese
cc-spec install --lang en --force   # Switch to English
```

---

## Usage

### Basic Workflow

```
1. Initialize project
   /spec-init

2. Design & discuss requirements
   Just talk to Claude - it automatically handles architecture

3. Start development
   Say "Let's implement this" - Claude automatically handles coding

4. Validate completeness
   /spec-audit
```

**Key Point**: You don't need to manually invoke skills like `/architect` or `/programmer`. Claude Code automatically selects the right skill based on your conversation context.

---

### Example: Building a Web App

```bash
# Create your project
mkdir my-app
cd my-app
git init

# Initialize SPEC
/spec-init
# Answer questions: project type, tech stack, features

# Discuss design
"I need a user authentication system with JWT"
# Claude automatically uses architect skill to design it

# Start coding
"Let's implement the authentication"
# Claude automatically uses programmer skill to write code

# Validate
/spec-audit
# Verify everything is complete and documented
```

---

## Features

- ✅ **System-Level SPEC**
  - Complete specifications: Requirements, Architecture, Data, API, UI
  - Single source of truth for entire project
  - Traceable changes from idea to code

- ✅ **Automatic Skill Selection**
  - Claude Code picks the right skill at the right time
  - No manual skill invocation needed
  - Seamless workflow from design to code

- ✅ **Cross-Platform**
  - Works on Linux, macOS, Windows
  - Auto-detects your system language
  - Native scripts for each platform

- ✅ **Safe Installation**
  - Automatic backup before installing
  - Restore option when uninstalling
  - Never lose your existing configuration

---

## Commands

### Installation Commands

```bash
cc-spec install [options]
  -l, --lang <en|zh>     Language (default: auto-detect)
  -f, --force           Force reinstall
  --skip-aiw           Skip aiw check

cc-spec uninstall
cc-spec update
cc-spec status
```

### Development Commands

```bash
/spec-init       Initialize project SPEC (interactive)
/spec-audit      Verify SPEC completeness
```

---

## Uninstallation

### Standard Uninstall

```bash
cc-spec uninstall
```

Your existing configuration is backed up and can be restored.

### Complete Removal

```bash
# Uninstall the package
cc-spec uninstall
npm uninstall -g @putao520/cc-spec-lite

# Remove backups (optional)
rm -rf ~/.claude/backup/cc-spec-lite-*    # Linux/macOS
rmdir /s "%USERPROFILE%\.claude\backup\cc-spec-lite-*"  # Windows
```

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

AI Warden CLI is a required dependency that enables role-based AI agents. It's automatically installed during setup.

**Install manually**:
```bash
npm install -g @putao520/aiw
```

### Something's not working?

```bash
# Check installation status
cc-spec status

# Verify files are present
ls -la ~/.claude/skills/    # Linux/macOS
dir %USERPROFILE%\.claude\skills\   # Windows

# Restart Claude Code after installation
```

---

## Requirements

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **Git** (for version control)
- **Claude Code** (AI development environment)

---

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow SPEC-driven development workflow
4. Submit a pull request

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Links

- **GitHub**: https://github.com/putao520/cc-spec-lite
- **Issues**: https://github.com/putao520/cc-spec-lite/issues
- **Discussions**: https://github.com/putao520/cc-spec-lite/discussions

---

**Version**: 0.0.1
**Author**: putao520 <yuyao1022@hotmail.com>
