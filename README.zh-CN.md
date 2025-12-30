# CC-SPEC-Lite

> Claude Code 的轻量级 SPEC 驱动开发框架

**解决什么问题？**

为 AI 辅助软件开发提供完整的**系统级规范框架**，确保需求、架构和实现的长期一致性。

---

## 快速开始

```bash
npm install -g @putao520/cc-spec-lite
```

就这样！安装自动运行。你可以使用：

```bash
/spec-init        # 初始化项目 SPEC
/architect        # 设计系统架构
"Let's implement"  # 开始编码（自动调用程序员技能）
```

---

## 安装

### 从 npm 安装（推荐）

```bash
npm install -g @putao520/cc-spec-lite
```

安装会自动运行并引导你完成：
1. **语言选择**（从操作系统区域设置自动检测）
2. **AI CLI 优先级配置**（选择你喜欢的 AI 代理和供应商）

### 配置了什么？

安装期间，你会设置：
- **AI 代理优先级**：尝试哪些 AI 代理以及按什么顺序（codex、gemini、claude）
- **供应商选择**：每个代理使用哪个供应商（auto、official、glm、openrouter 等）

配置保存到 `~/.claude/config/aiw-priority.yaml`，之后可以修改。

### 从源码安装

```bash
git clone https://github.com/putao520/cc-spec-lite.git
cd cc-spec-lite
npm install -g .
```

### 语言选项

**自动检测**（默认）：
```bash
npm install -g @putao520/cc-spec-lite
# 自动从操作系统区域设置检测
# zh-CN, zh-TW, zh-HK, zh-SG → 中文
# 其他区域 → 英文
```

**手动切换语言**：
```bash
cc-spec install --lang zh --force   # 切换到中文
cc-spec install --lang en --force   # 切换到英文
```

---

## 使用方法

### 基本工作流

```
1. /spec-init        → 初始化项目 SPEC
2. 讨论设计         → 自动调用架构师技能
3. "Let's implement"  → 自动调用程序员技能
4. /spec-audit       → 验证 SPEC 完整性
```

**关键点**：你不需要手动调用 `/architect` 或 `/programmer` 这样的技能。Claude Code 会根据对话上下文自动选择合适的技能。

### 示例：构建 Web 应用

```bash
mkdir my-app && cd my-app
git init

/spec-init                    # 初始化 SPEC
"我需要用户认证"              # 讨论设计
"Let's implement"             # 开始编码
/spec-audit                   # 验证完整性
```

---

## 功能特性

- ✅ **系统级 SPEC** - 从需求到 UI 的完整规范
- ✅ **自动技能选择** - Claude Code 自动选择合适的技能
- ✅ **AI CLI 优先级配置** - 配置首选的 AI 代理和供应商，支持自动回退
- ✅ **跨平台** - 支持 Linux、macOS、Windows
- ✅ **安全安装** - 自动备份，卸载时恢复

---

## 命令

### 安装命令

```bash
cc-spec install [options]
  -l, --lang <en|zh>     语言（默认：从操作系统自动检测）
  -f, --force           强制重新安装 / 切换语言
  --skip-aiw           跳过 aiw 检查

cc-spec uninstall --force
cc-spec update
cc-spec status
```

### 开发命令

```bash
/spec-init       初始化项目 SPEC
/spec            进入 SPEC 需求描述模式
/spec-audit      验证 SPEC 完整性
```

#### /spec - SPEC 需求描述模式

**用途**：主动进入 SPEC 驱动开发工作流，确保在实现之前聚焦规范。

**何时使用**：
- 开始新功能
- 修改现有功能
- 修复 Bug 并更新 SPEC
- 任何需要 SPEC 文档的代码变更

**工作流**：
```
1. /spec "描述你的需求"
   ↓
2. 交互式需求完善
   - AI 提出澄清问题
   - 定义验收标准
   - 指定数据模型和 API
   ↓
3. 自动更新 SPEC
   - 调用 /architect 更新 SPEC 文件
   - 分配 REQ-XXX、DATA-XXX、API-XXX ID
   ↓
4. 选择是否开始实现
   - 确认则自动调用 /programmer
   - 或仅更新 SPEC
```

**示例**：
```bash
/spec "实现带邮箱验证的用户注册功能"
```

**优势**：
- ✅ 强制 SPEC 先行思维
- ✅ 防止长对话中的注意力分散
- ✅ 确保编码前规范完整
- ✅ 无缝过渡到实现

---

## AI CLI 优先级配置

### 概述

本框架支持多个 AI 代理（codex、gemini、claude）和供应商（auto、glm、openrouter 等）。安装期间，你可以配置首选的优先级顺序。

### 工作原理

当你运行 AI CLI 任务时，系统会：
1. 尝试你首选的 AI 代理 + 供应商组合
2. 如果失败，自动回退到下一优先级
3. 继续直到成功或所有选项耗尽

### 配置文件

**位置**：`~/.claude/config/aiw-priority.yaml`

**格式**：
```yaml
priority:
  - cli: codex
    provider: auto
  - cli: gemini
    provider: auto
  - cli: claude
    provider: auto
```

**配置格式**：`{cli_name}+{provider_name}`

**支持的 AI 代理**：
- `codex` - 默认 AI 代理
- `gemini` - Google Gemini
- `claude` - Anthropic Claude

**支持的供应商**（来自 `~/.aiw/providers.json`）：
- `auto` - 内置智能路由（推荐）
- `official` - 官方供应商
- `glm` - GLM 供应商
- `openrouter` - OpenRouter API
- 你的 aiw 设置中配置的其他供应商

### 交互式配置（安装时）

安装期间，会提示你：

**步骤1：选择 AI 代理优先级顺序**
```
? 选择你首选的 AI 代理顺序（使用方向键，空格选择）：
❯ ⬡ codex
  ⬡ gemini
  ⬡ claude
```

**步骤2：为每个代理选择供应商**
```
? 为 'codex' 选择供应商：
  ◯ auto（推荐）
  ◯ official
  ◯ glm
  ◯ openrouter
```

### 手动配置

直接编辑配置文件：

```bash
# Linux/macOS
nano ~/.claude/config/aiw-priority.yaml

# Windows
notepad %USERPROFILE%\.claude\config\aiw-priority.yaml
```

### 使用自定义 AI 代理

你可以通过直接指定代理来覆盖配置的优先级：

```bash
# Bash 脚本
~/.claude/scripts/ai-cli-runner.sh "backend" "REQ-001" "实现 API" "" "gemini"

# PowerShell 脚本
~\.claude\scripts\ai-cli-runner.ps1 "backend" "REQ-001" "实现 API" "" "claude" "glm"
```

### 默认配置

如果配置文件不存在，系统使用：
```
codex+auto → gemini+auto → claude+auto
```

---

## 卸载

```bash
cc-spec uninstall --force
npm uninstall -g @putao520/cc-spec-lite
```

你现有的配置会被备份，卸载时自动恢复。

---

## 常见问题

### 如何切换语言？

```bash
cc-spec install --lang zh --force
```

### 如何重新配置 AI CLI 优先级？

```bash
# 重新安装以重新配置
cc-spec install --force

# 或直接编辑配置文件
nano ~/.claude/config/aiw-priority.yaml
```

### 如何更改使用的 AI 代理？

编辑 `~/.claude/config/aiw-priority.yaml` 并重新排序优先级列表：

```yaml
priority:
  - cli: gemini        # 先尝试这个
    provider: auto
  - cli: codex         # 回退到这个
    provider: auto
  - cli: claude        # 最后的选择
    provider: auto
```

### 我会丢失现有配置吗？

**不会**。安装前自动备份。

### 文件安装在哪里？

| 平台 | 位置 |
|----------|----------|
| Linux/macOS | `~/.claude/` |
| Windows | `C:\Users\YourName\.claude\` |

### 如何更新？

```bash
npm update -g @putao520/cc-spec-lite
```

更新会自动运行。

### 出现问题怎么办？

```bash
cc-spec status              # 检查安装
ls ~/.claude/skills/        # 验证文件
```

---

## 系统要求

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **Git**
- **Claude Code**

---

## 贡献

欢迎贡献！

1. Fork 仓库
2. 创建功能分支
3. 遵循 SPEC 驱动开发工作流
4. 提交 Pull Request

---

## 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 链接

- **GitHub**: https://github.com/putao520/cc-spec-lite
- **Issues**: https://github.com/putao520/cc-spec-lite/issues
- **Discussions**: https://github.com/putao520/cc-spec-lite/discussions

---

**版本**: 0.3.0
**作者**: putao520 <yuyao1022@hotmail.com>
