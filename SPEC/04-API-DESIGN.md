# API 设计 - cc-spec-lite

**Version**: 1.0.0
**Last Updated**: 2025-12-29

---

## API-CLI-001: spec CLI 命令接口

### 命令概览

```bash
spec <command> [options]

Commands:
  init              初始化 SPEC 目录
  new               创建新 SPEC 条目
  validate          验证 SPEC 格式
  status            显示状态概览
  install           安装 Git hooks

Options:
  -h, --help        显示帮助
  -v, --version     显示版本
  -l, --lang        语言选择（zh/en）
```

---

## API-CONFIG-001: 安装配置接口

### 交互式配置流程

#### 接口流程

```
npm install @putao520/cc-spec-lite
    ↓
lib/installer.js 执行
    ↓
[交互式界面 Step 1] 语言选择
    输入: zh / en
    ↓
[交互式界面 Step 2] CLI 优先级选择
    ├─ 选项1: 保持默认 (codex → gemini → claude)
    └─ 选项2: 自定义顺序
    ↓
[交互式界面 Step 3] 供应商配置（每个 CLI）
    ├─ 读取: ~/.aiw/providers.json
    ├─ 显示: 可用供应商列表
    └─ 输入: 为每个 CLI 选择供应商
    ↓
生成配置文件: ~/.claude/config/aiw-priority.yaml
    ↓
复制其他文件到 ~/.claude/
    ↓
完成
```

### Step 2: CLI 优先级选择

**界面呈现**（英文）:

```
=========================================================
     AI CLI Priority Configuration
=========================================================

Choose priority order for AI CLIs (highest to lowest)

Available AI CLIs:
  [1] codex    - (default recommended)
  [2] gemini   - Google Gemini
  [3] claude   - Claude Anthropic

Options:
  [1] Keep default order (codex → gemini → claude)
  [2] Customize priority order

Enter option [1-2]:
```

**选择逻辑**:

| 用户输入 | 行为 |
|---------|------|
| 1 或默认顺序 | 使用固定顺序：codex → gemini → claude |
| 2 | 进入自定义选择流程 |

**自定义流程**（三个问题）:
```
Select 1st priority (highest): [1-3]
Select 2nd priority: [1-2]
Select 3rd priority: [1]
```

### Step 3: 供应商配置

**读取供应商列表**:

| 操作 | 说明 |
|------|------|
| 读取路径 | `~/.aiw/providers.json` |
| 解析 JSON | 获取 `providers` 对象的所有键 |
| 添加内置 | 始终包含 `auto` |
| 输出示例 | `['auto', 'official', 'glm', 'openrouter']` |

**界面呈现**（每个 CLI 重复）:

```
---------------------------------------------------------
 [N] {cli_name} - Provider Selection
---------------------------------------------------------

Available providers:
  [1] auto       - Auto routing (recommended)
  [2] official   - Anthropic official API
  [3] glm        - Zhipu AI
  [4] openrouter - OpenRouter aggregation

Select provider for {cli_name} [1-N]:
```

**配置约束**:

| 约束 | 说明 |
|------|------|
| 所有 CLI 可选 | 任何 CLI 可以使用任何供应商 |
| 默认值 | auto（推荐） |
| 动态列表 | 根据用户配置动态显示 |

### 配置文件生成

**输出路径**: `~/.claude/config/aiw-priority.yaml`

**生成格式**:

| 条件 | 格式 |
|------|------|
| 用户选择配置 | 根据用户输入生成 |
| 配置文件已存在 | 覆盖（重新安装时） |
| 读取失败 | 使用默认值 |

**YAML 结构**:

```yaml
priority:
  - cli: {cli_1}
    provider: {provider_1}
  - cli: {cli_2}
    provider: {provider_2}
  - cli: {cli_3}
    provider: {provider_3}
```

### 错误处理

| 错误场景 | 处理方式 |
|---------|---------|
| `~/.aiw/providers.json` 不存在 | 仅使用 `auto` 选项 |
| `~/.aiw/providers.json` 格式错误 | 警告并仅使用 `auto` |
| 配置文件写入失败 | 报错并终止安装 |
| 用户取消输入 | 使用默认值继续 |

### 完成确认

**成功输出**:

```
✅ Configuration complete!

Priority order with providers:
  1. {cli_1}+{provider_1}
  2. {cli_2}+{provider_2}
  3. {cli_3}+{provider_3}

Writing configuration to: ~/.claude/config/aiw-priority.yaml
```

---

## API-CLI-002: spec init

### 接口定义

```bash
spec init [options]
```

### 功能
- 创建 `SPEC/` 目录结构
- 生成核心文件（01-06）
- 初始化 VERSION 文件

### 选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `-f, --force` | boolean | false | 强制覆盖现有文件 |

### 输出

```
✅ SPEC 目录已创建: ./SPEC/
✅ 核心文件已生成:
   - 01-REQUIREMENTS.md
   - 02-ARCHITECTURE.md
   - 03-DATA-STRUCTURE.md
   - 04-API-DESIGN.md
   - 05-UI-DESIGN.md
   - 06-TESTING-STRATEGY.md
✅ VERSION 文件已创建: v1.0.0
```

---

## API-CLI-003: spec new

### 接口定义

```bash
spec new -t <type> -d <domain> -T <title> [options]
```

### 功能
- 创建新的 SPEC 条目
- 自动分配 ID
- 插入到对应的文件

### 选项

| 选项 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `-t, --type` | string | ✅ | REQ/ARCH/DATA/API/UI |
| `-d, --domain` | string | ✅ | 业务域（如 AUTH/DB） |
| `-T, --title` | string | ✅ | 标题 |
| `-f, --file` | string | ❌ | 目标文件（默认自动选择） |

### 示例

```bash
# 创建需求
spec new -t REQ -d AUTH -T "实现JWT登录验证"

# 创建架构
spec new -t ARCH -d CACHE -T "Redis缓存层设计"

# 创建数据模型
spec new -t DATA -d USER -T "用户表结构"
```

### 输出

```
✅ 新 SPEC 条目已创建:
   ID: REQ-AUTH-001
   文件: 01-REQUIREMENTS.md
   标题: 实现JWT登录验证
```

---

## API-CLI-004: spec validate

### 接口定义

```bash
spec validate [options]
```

### 功能
- 验证 SPEC 格式
- 检查 ID 唯一性
- 验证引用完整性

### 选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `-s, --strict` | boolean | false | 严格模式（警告也报错） |
| `-f, --format` | string | 'text' | 输出格式（text/json） |

### 输出（text 格式）

```
✅ SPEC 验证通过

检查结果:
- 需求条目: 12 个
- 架构条目: 8 个
- 数据条目: 15 个
- API 条目: 10 个
- ID 唯一性: ✅
- 引用完整性: ✅
```

### 输出（json 格式）

```json
{
  "valid": true,
  "errors": [],
  "warnings": [],
  "summary": {
    "requirements": 12,
    "architecture": 8,
    "data": 15,
    "api": 10
  }
}
```

---

## API-CLI-005: spec status

### 接口定义

```bash
spec status [options]
```

### 功能
- 显示所有 SPEC 条目状态
- 统计完成度
- 显示依赖关系

### 选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `-t, --type` | string | 'all' | 过滤类型（REQ/ARCH/DATA/API/UI） |
| `-s, --status` | string | 'all' | 过滤状态（todo/in-progress/done） |

### 输出

```
📊 SPEC 状态概览

需求（REQ）:
  待实现:   5 个
  进行中:   3 个
  已完成:   4 个
  ━━━━━━━━━━━━━━━━━━
  总计:     12 个（33% 完成）

架构（ARCH）:
  待实现:   2 个
  进行中:   1 个
  已完成:   5 个
  ━━━━━━━━━━━━━━━━━━
  总计:     8 个（62% 完成）

...
```

---

## API-CLI-006: spec install

### 接口定义

```bash
spec install [options]
```

### 功能
- 安装 Git hooks
- 配置 commit-msg 模板
- 设置 pre-commit 检查

### 选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `-f, --force` | boolean | false | 强制覆盖现有 hooks |
| `-l, --local` | boolean | false | 仅安装到当前仓库 |

### 输出

```
✅ Git hooks 已安装:
   - .git/hooks/pre-commit
   - .git/hooks/commit-msg
   - .git/hooks/post-commit
```

---

## API-HOOK-001: Git Hooks

### pre-commit hook

#### 功能
- 检查敏感文件（.env、密钥）
- 验证代码提交是否关联 SPEC
- 检查 SPEC 格式

#### 返回值

```bash
# 成功
exit 0

# 失败
exit 1
echo "错误: 提交未包含 SPEC 引用"
```

### commit-msg hook

#### 功能
- 验证 commit message 格式
- 提取 SPEC 引用（REQ-XXX）
- 检查 type/scope 合法性

#### 正则规则

```regex
^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+ (\[REQ-[A-Z]+-[0-9]+\])?$
```

### post-commit hook

#### 功能
- 更新 SPEC 状态
- 记录提交历史
- 触发 CI 检查（待实现）

---

## API-CMD-001: 命令系统接口

### 命令触发

```markdown
用户输入: /spec-init
    ↓
Claude Code 解析
    ↓
加载: commands/spec-init.md
    ↓
执行命令逻辑
```

### 命令文件格式

```markdown
# /spec-init - SPEC 初始化命令

## 核心职责
- 交互式创建 SPEC 目录
- 引导用户填写项目信息
- 生成初始 SPEC 文件

## 输入参数
- 项目名称
- 技术栈
- 语言（zh/en）

## 输出
- SPEC/ 目录
- 6 个核心文件
- VERSION 文件
```

---

## API-PLUGIN-001: 技能接口

### 技能调用

```markdown
用户: 调用 /architect
    ↓
主会话: 加载 skills/architect/SKILL.md
    ↓
AI: 执行技能定义的流程
    ↓
输出: 更新 SPEC/ 文件
```

### 技能元数据

```yaml
name: architect
version: 1.0.0
category: design
dependencies:
  - common
permissions:
  read: ["SPEC/"]
  write: ["SPEC/"]
```

---

## API-I18N-001: 国际化接口

### 语言检测

```typescript
function detectLanguage(): 'zh' | 'en' {
  const locale = process.env.LANG || 'en_US.UTF-8';
  return locale.startsWith('zh') ? 'zh' : 'en';
}
```

### 消息获取

```typescript
function getMessage(key: string, lang: 'zh' | 'en'): string {
  const messages = {
    'spec.init.success': {
      zh: 'SPEC 初始化成功',
      en: 'SPEC initialized successfully'
    }
  };
  return messages[key][lang];
}
```

---

## API-FILE-001: 文件操作接口

### 文件读取

```typescript
interface ReadOptions {
  encoding?: BufferEncoding;
  lang?: 'zh' | 'en';
}

function readSpecFile(
  file: string,
  options?: ReadOptions
): Promise<string>;
```

### 文件写入

```typescript
interface WriteOptions {
  createDir?: boolean;
  mode?: number;
}

function writeSpecFile(
  file: string,
  content: string,
  options?: WriteOptions
): Promise<void>;
```

---

## API-VALIDATE-001: 验证接口

### ID 验证

```typescript
interface IDValidationResult {
  valid: boolean;
  error?: string;
}

function validateSpecID(id: string): IDValidationResult {
  // REQ-{DOMAIN}-{NUMBER}
  const regex = /^(REQ|ARCH|DATA|API|UI)-([A-Z0-9]+)-([0-9]+)$/;
  const match = id.match(regex);

  if (!match) {
    return {
      valid: false,
      error: 'ID 格式错误，应为: TYPE-DOMAIN-NUMBER'
    };
  }

  return { valid: true };
}
```

### 引用验证

```typescript
interface ReferenceValidationResult {
  valid: boolean;
  missing: string[];
}

function validateReferences(specContent: string): ReferenceValidationResult {
  // 提取所有 [REQ-XXX]、[ARCH-XXX] 引用
  // 检查这些 ID 是否在 SPEC 中存在
  return {
    valid: true,
    missing: []
  };
}
```
