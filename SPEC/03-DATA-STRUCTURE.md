# 数据结构 - cc-spec-lite

**Version**: 1.0.0
**Last Updated**: 2025-12-29

---

## DATA-SPEC-001: SPEC 文件结构

### 核心文件格式

```yaml
SPEC/
├── VERSION                 # 版本号: v{major}.{minor}.{patch}
├── 01-REQUIREMENTS.md      # 功能需求（REQ-XXX）
├── 02-ARCHITECTURE.md      # 架构设计（ARCH-XXX）
├── 03-DATA-STRUCTURE.md    # 数据模型（DATA-XXX）
├── 04-API-DESIGN.md        # API 规范（API-XXX）
├── 05-UI-DESIGN.md         # UI 设计（UI-XXX）
└── DOCS/                   # 详细设计文档
```

### ID 格式规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 需求 | `REQ-{业务域}-{序号}` | `REQ-AUTH-001` |
| 架构 | `ARCH-{模块}-{序号}` | `ARCH-CACHE-001` |
| 数据 | `DATA-{表名}-{序号}` | `DATA-USER-001` |
| API | `API-{模块}-{序号}` | `API-AUTH-001` |
| UI | `UI-PAGE-{模块}-{序号}` | `UI-PAGE-USER-001` |

---

## DATA-SPEC-002: 需求条目格式

### REQUIREMENTS.md 条目结构

```markdown
### REQ-XXX: 标题

**优先级**: P0/P1/P2
**状态**: 待实现/进行中/已完成
**依赖**: REQ-YYY（可选）

#### 功能描述
- [ ] 子功能1
- [ ] 子功能2

#### 验收标准
- ✅ 已完成
- ⏳ 进行中
- ❌ 未开始
```

### 数据字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ID | string | ✅ | `REQ-{域}-{序号}` |
| 标题 | string | ✅ | 简短描述 |
| 优先级 | enum | ✅ | P0/P1/P2 |
| 状态 | enum | ✅ | 待实现/进行中/已完成 |
| 依赖 | array | ❌ | 关联的其他 REQ |
| 功能描述 | list | ✅ | 功能点清单 |
| 验收标准 | list | ✅ | 验收条件 |

---

## DATA-SPEC-003: Git 引用格式

### Commit Message 格式

```
<type>(<scope>): <description> [REQ-XXX]

示例:
feat(auth): 实现JWT验证 [REQ-AUTH-001]
fix(database): 修复查询性能 [API-DB-002]
docs(readme): 更新安装说明
```

### Type 枚举

| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | Bug 修复 |
| docs | 文档更新 |
| style | 格式调整 |
| refactor | 重构 |
| test | 测试相关 |
| chore | 构建/工具 |

---

## DATA-SPEC-004: 配置文件结构

### .claude-plugin/config.json（待实现）

```json
{
  "name": "cc-spec-lite",
  "version": "1.0.0",
  "languages": ["zh", "en"],
  "defaultLanguage": "zh",
  "installTarget": "~/.claude/",
  "hooks": {
    "preCommit": ".git-hooks/pre-commit",
    "commitMsg": ".git-hooks/commit-msg"
  },
  "commands": [
    "spec-init",
    "spec-audit",
    "spec-migrator"
  ]
}
```

---

## DATA-SPEC-005: CLI 命令数据

### spec new 命令参数

```typescript
interface SpecNewOptions {
  type: 'REQ' | 'ARCH' | 'DATA' | 'API' | 'UI';
  domain: string;  // 业务域，如 AUTH/DB/FRONTEND
  title: string;   // 标题
  file?: string;   // 目标文件，默认自动选择
}
```

### spec validate 输出

```typescript
interface SpecValidateResult {
  valid: boolean;
  errors: ValidationError[];
  warnings: ValidationWarning[];
}

interface ValidationError {
  file: string;
  line: number;
  message: string;
  level: 'error' | 'warning';
}
```

---

## DATA-SPEC-006: 国际化数据

### 语言映射

```typescript
interface LanguageMap {
  zh: string;  // 中文
  en: string;  // 英文
}

// 示例
const errorMessage: LanguageMap = {
  zh: "文件未找到",
  en: "File not found"
};
```

### CLI 输出双语结构（待实现）

```typescript
interface I18nMessage {
  key: string;
  translations: {
    zh: string;
    en: string;
  };
}

const messages: I18nMessage[] = [
  {
    key: "spec.init.success",
    translations: {
      zh: "SPEC 初始化成功",
      en: "SPEC initialized successfully"
    }
  }
];
```

---

## DATA-SPEC-007: 技能文件结构

### SKILL.md 元数据

```yaml
---
name: architect
version: 1.0.0
category: design
dependencies:
  - common
permissions:
  - read: SPEC/
  - write: SPEC/
  - execute: /architect
---
```

### 技能接口定义

```typescript
interface SkillMetadata {
  name: string;
  version: string;
  category: 'design' | 'code' | 'test' | 'ops';
  dependencies: string[];  // 依赖的其他技能
  permissions: {
    read?: string[];
    write?: string[];
    execute?: string[];
  };
}
```

---

## DATA-SPEC-008: Issue 模板数据

### GitHub Issue 结构

```markdown
## 开发计划: [功能名] [REQ-XXX]

### 关联 SPEC
- 需求: SPEC/01-REQUIREMENTS.md [REQ-XXX]
- 架构: SPEC/02-ARCHITECTURE.md [ARCH-XXX]
- 数据: SPEC/03-DATA-STRUCTURE.md [DATA-XXX]
- API: SPEC/04-API-DESIGN.md [API-XXX]

### 依赖关系
- 依赖: #123
- 阻塞: #789
- 可并行: #456

### 实施步骤
- [ ] 步骤1
- [ ] 步骤2

### 代码复用计划
- 复用: [模块路径]
- 新增: [模块路径]
```

---

## DATA-SPEC-009: 文件权限映射

### 安装文件权限

| 文件类型 | 权限 | 说明 |
|---------|------|------|
| 文档文件 (.md) | 644 | 可读可写 |
| 脚本文件 (.sh) | 755 | 可执行 |
| Git Hooks | 755 | 可执行 |
| 配置文件 | 644 | 可读可写 |

---

## DATA-SPEC-010: 版本管理数据

### VERSION 文件格式

```
v1.0.0
```

### 版本号规则

- **Major**: 破坏性变更（SPEC 格式变更）
- **Minor**: 新功能（新增命令/技能）
- **Patch**: Bug 修复/文档更新

### Changelog 格式（待实现）

```markdown
## [1.0.0] - 2025-12-29

### Added
- 双语支持（zh/en）
- spec CLI 工具
- Git hooks 集成

### Changed
- 重构安装脚本

### Fixed
- 修复文件权限问题
```
