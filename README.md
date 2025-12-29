# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code

**What problem does it solve?**

Provides a complete **system-level specification framework** for AI-assisted software development, ensuring long-term consistency across requirements, architecture, and implementation.

---

## Quick Start

```bash
npm install -g @putao520/cc-spec-lite
cc-spec install
```

That's it! You're ready to use:

```bash
/spec-init        # Initialize project SPEC
/architect        # Design system architecture
"Let's implement"  # Start coding (auto-invokes programmer)
```

---

## Installation

### Install from npm (Recommended)

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

### Language Options

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

**Switch languages**:
```bash
cc-spec install --lang zh --force   # Switch to Chinese
cc-spec install --lang en --force   # Switch to English
```

---

## Usage

### Basic Workflow

```
1. /spec-init        → Initialize project SPEC
2. Discuss design    → Auto-invokes architect skill
3. "Let's implement"  → Auto-invokes programmer skill
4. /spec-audit       → Verify SPEC completeness
```

**Key Point**: You don't manually invoke skills like `/architect` or `/programmer`. Claude Code automatically selects the right skill based on conversation context.

### Example: Building a Web App

```bash
mkdir my-app && cd my-app
git init

/spec-init                    # Initialize SPEC
"I need user authentication" # Discuss design
"Let's implement"             # Start coding
/spec-audit                   # Validate completeness
```

---

## Features

- ✅ **System-Level SPEC** - Complete specifications from requirements to UI
- ✅ **Auto Skill Selection** - Claude Code picks the right skill automatically
- ✅ **Cross-Platform** - Works on Linux, macOS, Windows
- ✅ **Safe Installation** - Automatic backup, restore on uninstall

---

## Commands

### Installation

```bash
cc-spec install [options]
  -l, --lang <en|zh>     Language (default: auto-detect)
  -f, --force           Force reinstall
  --skip-aiw           Skip aiw check

cc-spec uninstall
cc-spec update
cc-spec status
```

### Development

```bash
/spec-init       Initialize project SPEC
/spec-audit      Verify SPEC completeness
```

---

## Uninstallation

```bash
cc-spec uninstall
npm uninstall -g @putao520/cc-spec-lite
```

Your existing configuration is backed up and can be restored.

---

## FAQ

### How do I switch languages?

```bash
cc-spec install --lang zh --force
```

### Will I lose my existing configuration?

**No**. Automatic backup before installing.

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

### Something's not working?

```bash
cc-spec status              # Check installation
ls ~/.claude/skills/        # Verify files
```

---

## Requirements

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **Git**
- **Claude Code**

---

## Contributing

Contributions welcome!

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
