# 架构设计 - cc-spec-lite

**Version**: 1.0.0
**Last Updated**: 2025-12-29

---

## ARCH-CORE-001: 项目架构

### 项目类型
- **框架/工具**: CLI 工具 + 规范文档
- **开发模式**: SPEC-driven
- **部署方式**: npm 包 + Git 仓库

### 目录结构

```
cc-spec-lite/
├── CLAUDE.md              # 项目开发规范（本文件）
├── SPEC/                  # 项目需求文档
│   ├── 01-REQUIREMENTS.md
│   ├── 02-ARCHITECTURE.md
│   ├── 03-DATA-STRUCTURE.md
│   ├── 04-API-DESIGN.md
│   └── DOCS/
├── zh/                    # 中文产品（安装到 ~/.claude/）
├── en/                    # 英文产品（安装到 ~/.claude/）
├── install.sh             # 安装脚本
├── README.md              # 项目说明
└── .git/
```

### 分层架构

```
┌─────────────────────────────────────┐
│  产品层（Product Layer）            │
│  zh/, en/ - 给用户用的规范文件      │
└─────────────────────────────────────┘
              ↓ 安装
┌─────────────────────────────────────┐
│  用户系统（User System）            │
│  ~/.claude/ - 安装目标位置          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  开发层（Development Layer）        │
│  CLAUDE.md + SPEC/ - 项目开发规范   │
└─────────────────────────────────────┘
```

---

## ARCH-CORE-002: 模块划分

### 核心模块

| 模块 | 职责 | 文件 |
|------|------|------|
| **CLI 工具** | spec 命令实现 | `src/spec-cli.ts`（待实现） |
| **安装脚本** | 文件安装和配置 | `install.sh` |
| **规范文档** | 开发规范定义 | `zh/`, `en/` |
| **Git Hooks** | 自动检查和验证 | `zh/.git-hooks/`, `en/.git-hooks/` |
| **命令系统** | 自定义命令入口 | `zh/commands/`, `en/commands/` |
| **技能系统** | AI 技能定义 | `zh/skills/`, `en/skills/` |

### 模块依赖

```
CLI 工具
  ↓ 读取
规范文档（zh/en）
  ↓ 生成
Git Hooks
  ↓ 集成到
用户项目
```

---

## ARCH-CORE-003: 技术栈

### CLI 工具（待实现）
- **语言**: TypeScript
- **框架**: Commander.js
- **交互**: Inquirer.js
- **样式**: Chalk
- **测试**: Jest

### 安装脚本
- **语言**: Bash
- **目标**: `~/.claude/`

### 文档
- **格式**: Markdown
- **语言**: 中文 + 英文
- **维护**: 同步更新

---

## ARCH-CORE-004: 数据流

### 安装流程
```
用户运行 install.sh
  ↓
选择语言（zh/en）
  ↓
复制文件到 ~/.claude/
  ↓
设置权限（644）
  ↓
安装 Git Hooks（可选）
  ↓
完成
```

### CLI 使用流程
```
用户运行 spec <command>
  ↓
解析命令参数
  ↓
读取 SPEC 文件
  ↓
执行操作（validate/new/status）
  ↓
输出结果（双语）
```

### Git Hooks 流程
```
git commit
  ↓
pre-commit hook
  ↓
检查 SPEC 引用
  ↓
验证文件格式
  ↓
通过/阻止提交
```

---

## ARCH-CORE-005: i18n 架构

### 文档结构
```
zh/
├── CLAUDE.md
├── commands/
│   ├── spec-init.md
│   └── spec-audit.md
├── skills/
│   ├── architect/
│   ├── programmer/
│   └── shared/
└── roles/

en/
├── CLAUDE.md
├── commands/
│   ├── spec-init.md
│   └── spec-audit.md
├── skills/
│   ├── architect/
│   ├── programmer/
│   └── shared/
└── roles/
```

### 同步机制
- **手动同步**: 开发者更新时同时维护两个版本
- **自动检查**: Git hooks 验证文件对应关系
- **CI 验证**: 自动检查双语一致性（待实现）

---

## ARCH-CORE-006: 扩展点

### 命令扩展
- 位置: `commands/*.md`
- 方式: 创建新的 Markdown 命令文件
- 触发: 用户输入 `/command-name`

### 技能扩展
- 位置: `skills/*/SKILL.md`
- 方式: 创建新的技能目录
- 触发: AI 调用 `/skill-name`

### 角色扩展
- 位置: `roles/*.md`
- 方式: 创建新的角色定义
- 触发: AI CLI 调用时指定 `-r role-name`
