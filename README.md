# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code

**What problem does it solve?**

Provides a complete **system-level specification framework** for AI-assisted software development, ensuring long-term consistency across requirements, architecture, and implementation.

---

## Quick Start

```bash
npm install -g @putao520/cc-spec-lite
```

That's it! Installation runs automatically. You're ready to use:

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
```

Installation runs automatically and will guide you through:
1. **Language selection** (auto-detected from OS locale)
2. **AI CLI priority configuration** (choose your preferred AI agents and providers)

### What Gets Configured?

During installation, you'll set up:
- **AI Agent Priority**: Which AI agents to try and in what order (codex, gemini, claude)
- **Provider Selection**: Which provider to use for each agent (auto, official, glm, openrouter, etc.)

The configuration is saved to `~/.claude/config/aiw-priority.yaml` and can be modified later.

### Install from source

```bash
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite
npm install -g .
```

### Language Options

**Auto-detection** (Default):
```bash
npm install -g @putao520/cc-spec-lite
# Automatically detects from OS locale
# zh-CN, zh-TW, zh-HK, zh-SG → Chinese
# Other locales → English
```

**Switch languages manually**:
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
- ✅ **AI CLI Priority Configuration** - Configure preferred AI agents and providers with automatic fallback
- ✅ **Cross-Platform** - Works on Linux, macOS, Windows
- ✅ **Safe Installation** - Automatic backup, restore on uninstall

---

## Commands

### Installation

```bash
cc-spec install [options]
  -l, --lang <en|zh>     Language (default: auto-detect from OS)
  -f, --force           Force reinstall / language switch
  --skip-aiw           Skip aiw check

cc-spec uninstall --force
cc-spec update
cc-spec status
```

### Development

```bash
/spec-init       Initialize project SPEC
/spec-audit      Verify SPEC completeness
```

---

## AI CLI Priority Configuration

### Overview

This framework supports multiple AI agents (codex, gemini, claude) and providers (auto, glm, openrouter, etc.). During installation, you can configure your preferred priority order.

### How It Works

When you run AI CLI tasks, the system will:
1. Try your first preferred AI agent + provider combination
2. If it fails, automatically fallback to the next priority
3. Continue until successful or all options exhausted

### Configuration File

**Location**: `~/.claude/config/aiw-priority.yaml`

**Format**:
```yaml
priority:
  - cli: codex
    provider: auto
  - cli: gemini
    provider: auto
  - cli: claude
    provider: auto
```

**Configuration Format**: `{cli_name}+{provider_name}`

**Supported AI Agents**:
- `codex` - Default AI agent
- `gemini` - Google Gemini
- `claude` - Anthropic Claude

**Supported Providers** (from `~/.aiw/providers.json`):
- `auto` - Built-in intelligent routing (recommended)
- `official` - Official provider
- `glm` - GLM provider
- `openrouter` - OpenRouter API
- Other providers configured in your aiw setup

### Interactive Configuration (Installation)

During installation, you'll be prompted for:

**Step 1: Select AI Agent Priority Order**
```
? Select your preferred AI agent order (use arrow keys, space to select):
❯ ⬡ codex
  ⬡ gemini
  ⬡ claude
```

**Step 2: Select Provider for Each Agent**
```
? Select provider for 'codex':
  ◯ auto (recommended)
  ◯ official
  ◯ glm
  ◯ openrouter
```

### Manual Configuration

Edit the configuration file directly:

```bash
# Linux/macOS
nano ~/.claude/config/aiw-priority.yaml

# Windows
notepad %USERPROFILE%\.claude\config\aiw-priority.yaml
```

### Using Custom AI Agent

You can override the configured priority by specifying the agent directly:

```bash
# Bash script
~/.claude/scripts/ai-cli-runner.sh "backend" "REQ-001" "Implement API" "" "gemini"

# PowerShell script
~\.claude\scripts\ai-cli-runner.ps1 "backend" "REQ-001" "Implement API" "" "claude" "glm"
```

### Default Configuration

If no configuration file exists, the system uses:
```
codex+auto → gemini+auto → claude+auto
```

---

## Uninstallation

```bash
cc-spec uninstall --force
npm uninstall -g @putao520/cc-spec-lite
```

Your existing configuration is backed up and automatically restored on uninstall.

---

## FAQ

### How do I switch languages?

```bash
cc-spec install --lang zh --force
```

### How do I reconfigure AI CLI priority?

```bash
# Reinstall to reconfigure
cc-spec install --force

# Or edit the configuration file directly
nano ~/.claude/config/aiw-priority.yaml
```

### How do I change which AI agent is used?

Edit `~/.claude/config/aiw-priority.yaml` and reorder the priority list:

```yaml
priority:
  - cli: gemini        # Try this first
    provider: auto
  - cli: codex         # Fallback to this
    provider: auto
  - cli: claude        # Last resort
    provider: auto
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
```

The update runs automatically.

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

**Version**: 0.0.2
**Author**: putao520 <yuyao1022@hotmail.com>
