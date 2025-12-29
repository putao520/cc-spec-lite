# CC-SPEC-Lite

> A lightweight SPEC-driven development framework for Claude Code
>
> 轻量级的 SPEC 驱动开发框架

**What problem does it solve? / 解决什么问题？**

Provides a complete **system-level specification framework** for AI-assisted software development in **Chinese environments**, ensuring long-term consistency across requirements, architecture, and implementation.

为**中文开发环境**下的AI辅助软件提供完整的**系统级规范框架**，确保需求、架构、实现之间的长期一致性。

CC-SPEC-Lite provides a streamlined, professional approach to AI-assisted software development with design-first workflow, role-based skills, and automation scripts.

**Multi-language Support / 多语言支持**: English (en) and 简体中文 (zh)

---

## Table of Contents / 目录

- [Quick Start / 快速开始](#quick-start--快速开始)
- [Installation / 安装](#installation--安装)
- [Uninstallation / 卸载](#uninstallation--卸载)
- [Usage / 使用](#usage--使用)
- [Features / 功能特性](#features--功能特性)
- [How It Compares / 与其他方案对比](#how-it-compares--与其他方案对比)
- [FAQ / 常见问题](#faq--常见问题)
- [Contributing / 贡献](#contributing--贡献)

---

## Quick Start / 快速开始

### 3-Minute Setup / 3分钟设置

```bash
# Step 1: Install via npm / 通过 npm 安装
npm install -g @putao520/cc-spec-lite

# Step 2: Run installer / 运行安装程序
cc-spec install

# Step 3: Start using / 开始使用
cd my-project
/spec-init           # Initialize SPEC / 初始化 SPEC
```

**What happens / 发生什么**:
- ✅ Auto-detects your system language (Chinese/English)
- ✅ 自动检测系统语言（中文/英文）
- ✅ Backs up your existing `~/.claude/` configuration
- ✅ 备份你现有的 `~/.claude/` 配置
- ✅ Installs all necessary files
- ✅ 安装所有必要文件
- ✅ Sets up AI Warden CLI (aiw)
- ✅ 设置 AI Warden CLI (aiw)

---

## Installation / 安装

### Method 1: Install from npm / 方式1: 从 npm 安装

```bash
npm install -g @putao520/cc-spec-lite
cc-spec install
```

### Method 2: Install from source / 方式2: 从源码安装

```bash
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite
npm install -g .
cc-spec install
```

---

### Language Options / 语言选项

**Auto-detection / 自动检测** (Recommended / 推荐):
```bash
cc-spec install
# Automatically detects system locale
# 中国大陆 → 中文版
# 其他地区 → 英文版
```

**Manual selection / 手动选择**:
```bash
# English version / 英文版
cc-spec install --lang en

# Chinese version / 中文版
cc-spec install --lang zh
```

---

### Language Switching / 语言切换

```bash
# Switch to Chinese / 切换到中文
cc-spec install --lang zh --force

# Switch to English / 切换到英文
cc-spec install --lang en --force
```

**What happens / 发生什么**:
- Shows current installed language
- 显示当前已安装语言
- Asks: Keep current / Switch / Cancel
- 询问：保持当前 / 切换 / 取消
- Backs up before switching
- 切换前自动备份

---

### All Commands / 所有命令

```bash
# Install / 安装
cc-spec install [options]
  -l, --lang <en|zh>     Language (default: auto-detect / 默认自动检测)
  -f, --force           Force reinstall / 强制重新安装
  --skip-aiw           Skip aiw check / 跳过 aiw 检查

# Uninstall / 卸载
cc-spec uninstall

# Update / 更新
cc-spec update

# Check status / 检查状态
cc-spec status

# Quick aliases / 快捷命令
spec-install          # Same as 'cc-spec install'
spec-status          # Same as 'cc-spec status'
spec-update          # Same as 'cc-spec update'
```

---

### What Gets Installed / 安装内容

Files are copied to `~/.claude/`:

| Directory | Contents | 内容 |
|-----------|----------|------|
| `skills/` | Architect, Programmer, Testing skills | 架构师、程序员、测试技能 |
| `commands/` | /spec-init, /spec-audit | SPEC初始化、审查命令 |
| `scripts/` | Git hooks, AI CLI runners | Git钩子、AI CLI运行器 |
| `roles/` | Coding standards | 编码规范 |
| `CLAUDE.md` | Global development rules | 全局开发规范 |

**Platform-specific paths / 平台特定路径**:
- **Linux/macOS**: `~/.claude/`
- **Windows**: `C:\Users\YourName\.claude\`

---

### Backup and Restore / 备份和恢复

**Automatic backup on install / 安装时自动备份**:
```
~/.claude/backup/cc-spec-lite-2025-12-29T14-30-00/
└── (Complete backup of pre-installation files)
```

**Restore on uninstall / 卸载时可恢复**:
```bash
cc-spec uninstall
# Asks: Restore pre-installation backup?
# 询问：是否恢复安装前备份？
```

---

## Uninstallation / 卸载

### Standard Uninstall / 标准卸载

```bash
cc-spec uninstall
```

**Prompts you / 提示你**:
1. Confirm uninstall / 确认卸载
2. Restore backup (if available) / 恢复备份（如果有）

**What gets removed / 删除内容**:
- ✅ Skills, commands, scripts, roles
- ✅ CLAUDE.md
- ✅ Backup info file
- ❌ Backup directory (kept for safety / 保留以防万一)

### Clean Uninstall (Remove backups) / 完全卸载（删除备份）

```bash
# After standard uninstall / 在标准卸载后
rm -rf ~/.claude/backup/cc-spec-lite-*    # Linux/macOS
rmdir /s "%USERPROFILE%\.claude\backup\cc-spec-lite-*"  # Windows
```

### Remove npm Package / 删除 npm 包

```bash
npm uninstall -g @putao520/cc-spec-lite
```

---

## Usage / 使用

### Basic Workflow / 基本工作流

```
1. /spec-init        → Initialize project SPEC / 初始化项目 SPEC
2. /architect        → Design architecture / 设计架构
3. /programmer       → Write code / 编写代码
4. /spec-audit       → Validate completeness / 验证完整性
```

### Example Project / 示例项目

```bash
# Create project / 创建项目
mkdir my-app
cd my-app
git init

# Initialize SPEC / 初始化 SPEC
/spec-init
# Answer questions about your project
# 回答关于你的项目的问题

# Review generated SPEC / 查看生成的 SPEC
cat SPEC/01-REQUIREMENTS.md

# Start development / 开始开发
/programmer
# Implement features based on SPEC
# 基于 SPEC 实现功能
```

---

### Available Skills / 可用技能

| Skill | Purpose | 用途 |
|-------|---------|------|
| `/architect` | System design and SPEC management | 系统设计和SPEC管理 |
| `/programmer` | Code implementation | 代码实现 |
| `/readme` | Documentation | 文档编写 |
| `/testing` | E2E and integration tests | E2E和集成测试 |
| `/devloop` | SPEC-test validation loop | SPEC-测试验证循环 |

---

### Custom Commands / 自定义命令

| Command | Purpose | 用途 |
|---------|---------|------|
| `/spec-init` | Interactive SPEC initialization | 交互式SPEC初始化 |
| `/spec-audit` | Verify SPEC completeness | 验证SPEC完整性 |

---

### Scripts / 脚本

**AI CLI Runner / AI CLI 运行器**:
```bash
# Linux/macOS
~/.claude/scripts/ai-cli-runner.sh backend 'REQ-AUTH-001' 'Implement authentication'

# Windows PowerShell
~\.claude\scripts\ai-cli-runner.ps1 backend 'REQ-AUTH-001' 'Implement authentication'
```

**Git Utilities / Git 工具**:
```bash
# Commit with SPEC reference / 带 SPEC 引用的提交
~/.claude/scripts/commit-and-close.sh --message "feat: Add login [REQ-AUTH-001]" --issue 123

# Update SPEC status / 更新 SPEC 状态
~/.claude/scripts/update-spec-status.sh REQ-AUTH-001 implemented
```

---

## Features / 功能特性

### Core Capabilities / 核心能力

- ✅ **SPEC-Driven Development / SPEC 驱动开发**
  - Single source of truth / 单一真实源
  - Structured requirements / 结构化需求
  - Traceable changes / 可追溯变更

- ✅ **Role-Based Skills / 基于角色的技能**
  - Architect for design / 架构师负责设计
  - Programmer for implementation / 程序员负责实现
  - Automatic code review / 自动代码审查

- ✅ **Cross-Platform / 跨平台**
  - Linux, macOS, Windows support
  - 自动检测系统语言
  - Native Bash and PowerShell scripts
  - 原生 Bash 和 PowerShell 脚本

- ✅ **Safe Installation / 安全安装**
  - Automatic backup before install
  - 安装前自动备份
  - Restore option on uninstall
  - 卸载时可恢复

---

## How It Compares / 与其他方案对比

### Problem Domain Comparison / 问题域对比

| Problem / 问题 | OpenSpec | cc-spec-lite |
|---------------|----------|--------------|
| **Scope / 覆盖范围** | Task-level requirements / 任务级需求 | System-level specifications / 系统级规范 |
| **Target Audience / 目标用户** | Individual features / 单个功能 | Long-term projects / 长期项目 |
| **Primary Use Case / 主要场景** | "Describe one feature" / "描述单个功能" | "Maintain system consistency" / "维护系统一致性" |
| **Language Support / 语言支持** | English-focused / 英文为主 | Full bilingual / 完整中英双语 |
| **Development Environment / 开发环境** | International / 国际环境 | Chinese developers / 中文开发者 |
| **Specification Scope / 规范范围** | Feature requirements / 功能需求 | Requirements + Architecture + Data + API / 需求+架构+数据+API |
| **Role Separation / 角色分工** | ❌ Not covered / 未覆盖 | ✅ Architect ↔ Programmer ↔ Testing |
| **Long-term Maintenance / 长期维护** | ⚠️ Per-feature / 按功能 | ✅ System-level SSOT / 系统级单一真源 |
| **AI CLI Integration / AI CLI集成** | ❌ None / 无 | ✅ aiw with role injection / aiw角色注入 |

### When to Use Each / 使用场景

**Choose cc-spec-lite if you / 如果你是以下情况，选择 cc-spec-lite**:
- ✅ Building long-term projects in Chinese / 构建长期的中文项目
- ✅ Need system-level architecture tracking / 需要系统级架构追踪
- ✅ Want role-based AI collaboration / 需要基于角色的AI协作
- ✅ Value bilingual documentation / 重视双语文档
- ✅ Care about cross-platform compatibility / 关注跨平台兼容性

**Consider OpenSpec if you / 如果你是以下情况，考虑 OpenSpec**:
- ✅ Need quick feature description / 需要快速描述单个功能
- ✅ Working in English-only environment / 仅在英文环境工作
- ✅ Don't need architecture tracking / 不需要架构追踪
- ✅ Prefer lightweight task focus / 偏好轻量级任务聚焦

**Complementary Use / 互补使用**:
- Use OpenSpec for initial feature ideation / 用OpenSpec进行功能初步构思
- Import into cc-spec-lite for system-level tracking / 导入cc-spec-lite进行系统级追踪
- Maintain architect-controlled SSOT / 维护architect控制的单一真源

---

## FAQ / 常见问题

### How do I switch languages? / 如何切换语言？

```bash
cc-spec install --lang zh --force   # Switch to Chinese / 切换到中文
cc-spec install --lang en --force   # Switch to English / 切换到英文
```

### Will I lose my existing configuration? / 会丢失现有配置吗？

**No / 不会**. The installer automatically backs up your existing `~/.claude/` before installing. On uninstall, you can choose to restore the backup.
安装程序会在安装前自动备份你现有的 `~/.claude/`。卸载时你可以选择恢复备份。

### Where are files installed? / 文件安装在哪里？

| Platform | Location |
|----------|----------|
| Linux/macOS | `~/.claude/` |
| Windows | `C:\Users\YourName\.claude\` |

### How do I update? / 如何更新？

```bash
npm update -g @putao520/cc-spec-lite
cc-spec update
```

### What is AI Warden CLI (aiw)? / 什么是 AI Warden CLI (aiw)？

AI Warden CLI is a required dependency for running AI agents with role-based context. It will be automatically installed during cc-spec-lite setup.
AI Warden CLI 是运行带角色上下文的 AI 代理的必需依赖。它会在 cc-spec-lite 设置期间自动安装。

**Install manually / 手动安装**:
```bash
npm install -g @putao520/agentic-warden
```

### Skills not found after installation? / 安装后找不到技能？

```bash
# Verify installation / 验证安装
cc-spec status

# Check files / 检查文件
ls -la ~/.claude/skills/    # Linux/macOS
dir %USERPROFILE%\.claude\skills\   # Windows

# Restart Claude Code / 重启 Claude Code
```

---

## Requirements / 系统要求

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **Git** (for version control)
- **Claude Code** (AI development environment)

---

## Contributing / 贡献

Contributions are welcome! Please follow these guidelines:

欢迎贡献！请遵循以下准则：

1. Fork the repository / Fork 仓库
2. Create a feature branch / 创建功能分支
3. Follow SPEC-driven development workflow / 遵循 SPEC 驱动开发流程
4. Submit a pull request / 提交 PR

**Development workflow / 开发工作流**:
```bash
# Initialize project SPEC / 初始化项目 SPEC
/spec-init

# Design your changes / 设计变更
/architect

# Implement / 实现
/programmer

# Validate / 验证
/spec-audit
```

---

## License / 许可证

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

基于 MIT 许可证分发。详见 [LICENSE](LICENSE)。

---

## Links / 链接

- **GitHub**: https://github.com/putao520/cc-spec-lite
- **Issues**: https://github.com/putao520/cc-spec-lite/issues
- **Discussions**: https://github.com/putao520/cc-spec-lite/discussions
- **AI Warden CLI**: https://github.com/putao520/agentic-warden

---

**Version**: 0.0.1
**Repository**: https://github.com/putao520/cc-spec-lite
**Author**: putao520 <yuyao1022@hotmail.com>
