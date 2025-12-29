核心铁律:禁止修改触碰,读取,访问~/.claude/目录下任何文件和文件夹,禁止直接开发环境运行安装命令

# Claude Code 开发规范 - cc-spec-lite 项目

> **项目类型**: 框架/工具开发（不是业务应用）
>
> **项目定位**: SPEC-driven 开发框架的 CLI 实现和规范维护

---

## 📦 产品 vs 开发区分（重要！）

### 产品层（给用户用的）
- **位置**: `zh/`、`en/` 目录
- **用途**: 通过 `install.sh` 安装到用户系统（`~/.claude/`）
- **性质**: 框架的输出，不参与本项目开发
- **AI执行**: ❌ **禁止 AI 读取或执行这些文件**
- **更新规则**: 修改后需要同步更新 zh/ 和 en/ 两个版本

### 开发层（本项目用的）
- **位置**: 根目录 `CLAUDE.md` + `SPEC/` 目录
- **用途**: 定义 cc-spec-lite 项目自身的开发规范
- **性质**: 本项目的真源，AI 开发时必须遵循
- **AI执行**: ✅ **只读取本文件和 SPEC/ 目录**

```
┌─────────────────────────────────────────────────────────┐
│  AI 开发时的文件读取范围（严格遵守）                    │
├─────────────────────────────────────────────────────────┤
│  ✅ 读取: /CLAUDE.md（本文件）                          │
│  ✅ 读取: /SPEC/*.md（项目需求/架构）                   │
│  ❌ 忽略: /zh/*、/en/*（产品文件，不参与开发）          │
└─────────────────────────────────────────────────────────┘
```

---

## SPEC 位置

- **项目 SPEC**: `./SPEC/`
  - `01-REQUIREMENTS.md` - 功能需求（CLI工具、i18n支持、插件系统等）
  - `02-ARCHITECTURE.md` - 架构设计（模块划分、技术栈）
  - `03-DATA-STRUCTURE.md` - 数据模型（SPEC 格式、配置结构）
  - `04-API-DESIGN.md` - API 设计（CLI 命令、插件接口）
  - `05-UI-DESIGN.md` - UI 设计（如涉及 TUI/Web UI）
  - `DOCS/` - 详细设计文档

---

## 开发流程

### 新功能开发
```
用户需求 → 调用 /architect → 更新 SPEC/ → 调用 /programmer → 实现
```

### 产品更新（zh/en/）
```
修改规范 → 同步更新 zh/ 和 en/ → 测试安装 → 提交
```

### 技术选型
- **Node.js CLI**: commander, inquirer, chalk
- **i18n**: i18next 或自定义实现
- **测试**: Jest, Playwright（E2E）
- **文档**: Markdown + 双语维护

---

### 配置文件设计模式（产品层核心原则）

**核心理念**：`resources/` 中的配置是**模板/源文件**，安装后复制到用户 `~/.claude/` 才是**实际配置**。

**设计原则**：
1. **配置模板位置**：`resources/{zh|en}/config/*.yaml` 或 `*.conf`
2. **安装后位置**：`~/.claude/config/`（用户实际使用）
3. **读取逻辑**：脚本优先读取 `~/.claude/config/`，不存在则使用硬编码默认值
4. **格式要求**：优先使用 YAML，如需解析工具则提供 fallback 机制

**示例结构**：
```
resources/zh/
├── config/
│   └── aiw-priority.yaml     ← 配置模板（开发时维护）
└── scripts/
    └── ai-cli-runner.sh       ← 读取 ~/.claude/config/aiw-priority.yaml

用户系统安装后（~/.claude/）
├── config/
│   └── aiw-priority.yaml     ← 实际配置（用户可修改）
└── scripts/
    └── ai-cli-runner.sh
```

**配置格式规范**：
- 配置项格式：`{cli_name}+{provider_name}`
- 示例：`codex+auto`、`gemini+openrouter`、`claude+glm`
- 支持优先级列表：按顺序尝试直到成功

**开发时遵守**：
- ✅ 修改 `resources/` 中的配置模板
- ✅ 同步更新 zh/ 和 en/ 两个版本
- ❌ 禁止直接读取或修改 `~/.claude/`（开发服务器）
- ❌ 禁止在开发环境运行安装命令测试

---

## 🚨 项目铁律（违反即失败）

| # | 铁律 | 说明 |
|---|------|------|
| 1 | **双语同步维护** | 修改 zh/ 或 en/ 任何文件时，必须同时更新另一个语言版本 |
| 2 | **产品不参与开发** | zh/ 和 en/ 是产品，AI 开发时禁止读取或执行 |
| 3 | **SPEC 先行** | 所有功能必须先在 SPEC/ 中定义，再开始实现 |
| 4 | **自举验证** | 使用自己的框架规范开发本项目，验证实用性 |
| 5 | **配置模板模式** | resources/ 是模板，~/.claude/ 是实际配置，开发时只维护模板 |

### 双语维护规则（铁律1 详细说明）

**核心原则**：
- ✅ 修改任何 zh/*.md → 必须同步更新 en/*.md
- ✅ 修改任何 en/*.md → 必须同步更新 zh/*.md
- ✅ 提交前检查文件对应关系（1:1 映射）
- ❌ 禁止只更新一种语言的提交

**检查方法**：
```bash
# 检查文件对应关系
bash /tmp/check-files.sh
```

**Git 提交规范**：
```bash
# ✅ 正确：包含两个语言版本的变更
git add zh/skills/architect/SKILL.md en/skills/architect/SKILL.md
git commit -m "docs(architect): 更新架构师技能规范 [REQ-XXX]"

# ❌ 错误：只有一个语言版本
git add zh/skills/architect/SKILL.md
git commit -m "docs(architect): 更新架构师技能规范"
```

---

## 项目约束

- ✅ 使用 TypeScript
- ✅ 遵循 SPEC-driven 开发流程
- ✅ 双语同步更新（zh/ 和 en/）
- ✅ 所有规范变更必须更新 SPEC/
- ❌ 禁止硬编码文本（必须支持 i18n）
- ❌ 禁止破坏现有安装方式
