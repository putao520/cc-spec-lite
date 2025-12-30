---
description: SPEC需求描述态 - 主动进入SPEC完善并触发程序员执行
argument-hint: <需求描述>
---

# /spec 命令

## 核心职责

**主动进入 SPEC 需求描述态，通过完善的 SPEC 自动触发程序员执行**

- ✅ 引导用户描述需求
- ✅ 交互式完善 SPEC（需求/架构/数据/API）
- ✅ SPEC 完整性检查
- ✅ 自动调用 /programmer 执行

---

## 设计目标

**解决模型注意力不集中问题**

- ❌ **问题**：长对话中模型容易偏离 SPEC-driven 流程
- ✅ **解决**：显式进入"SPEC 需求描述态"，强制聚焦 SPEC 完善
- ✅ **机制**：SPEC 完善后无缝衔接程序员执行

---

## 执行流程

### 阶段1：需求描述（交互式）

**步骤1：开放式需求收集**

```markdown
# 🎯 SPEC 需求描述模式

欢迎使用 SPEC-driven 开发！

请描述你想要实现的功能：
[等待用户自由输入...]

**提示**：
- 可以是功能需求："实现用户登录"
- 可以是架构调整："把 MySQL 换成 PostgreSQL"
- 可以是 Bug 修复："修复登录时的 Token 错误"
- 可以是新功能："添加图片上传功能"
```

**步骤2：AI 分析 + SPEC 完善引导**

基于用户描述，识别需要完善的 SPEC 维度：

| 用户描述类型 | 识别的 SPEC 缺失 | 引导动作 |
|-------------|-----------------|---------|
| 新功能 | 缺少 REQ-XXX | 引导到 01-REQUIREMENTS.md |
| 功能调整 | REQ-XXX 验收标准不清晰 | 引导完善验收标准 |
| 数据相关 | 缺少 DATA-XXX | 引导到 03-DATA-STRUCTURE.md |
| API 相关 | 缺少 API-XXX | 引导到 04-API-DESIGN.md |
| 架构调整 | 缺少 ARCH-XXX | 引导到 02-ARCHITECTURE.md |

**交互式询问示例**：

```markdown
基于你的描述，我需要完善以下 SPEC：

**1. 需求定义（REQ-XXX）**
- 功能名称：[推导的功能名]
- 核心逻辑：[推导的逻辑]
- 验收标准：[需要补充]

**请补充验收标准**：
[用户输入...]

**2. 数据模型（DATA-XXX）**
- 涉及的实体：[推导的实体]
- 字段设计：[需要补充]

**请描述数据结构**：
[用户输入...]

**3. API 设计（API-XXX）**
- 接口端点：[推导的路径]
- 请求/响应：[需要补充]

**请描述接口格式**：
[用户输入...]
```

**关键原则**：
- ✅ 基于用户描述**动态追问**
- ✅ 每个问题都是**开放式文本输入**
- ❌ 不要使用选项列表
- ❌ 不要问无关的问题

---

### 阶段2：调用 /architect 更新 SPEC

**收集足够信息后，展示 SPEC 摘要**：

```markdown
## 📋 SPEC 摘要

### 需求定义
**REQ-XXX：[功能名]**
- 描述：[用户描述]
- 验收标准：
  - [标准1]
  - [标准2]

### 数据模型
**DATA-XXX：[实体名]**
- 字段：
  - [字段1]：[类型] - [说明]
  - [字段2]：[类型] - [说明]

### API 设计
**API-XXX：[接口名]**
- 端点：POST /api/xxx
- 请求：[格式]
- 响应：[格式]

---

**这个 SPEC 是否准确？**
[✅ 准确，更新 SPEC 并开始开发]
[✏️ 需要修正]
```

用户确认后，调用 /architect：

```markdown
/architect

# 更新 SPEC 请求

**需求描述**：
[用户的完整描述]

**收集的 SPEC 信息**：
[整理后的 SPEC 结构]

**请执行**：
1. 分配 REQ-XXX、DATA-XXX、API-XXX
2. 更新对应的 SPEC 文件（01/03/04）
3. 确保格式符合规范
```

---

### 阶段3：自动调用 /programmer 执行

**SPEC 更新完成后，无缝衔接程序员**：

```markdown
✅ SPEC 已更新！

**已更新文件**：
- SPEC/01-REQUIREMENTS.md [REQ-XXX]
- SPEC/03-DATA-STRUCTURE.md [DATA-XXX]
- SPEC/04-API-DESIGN.md [API-XXX]

---

**现在开始实现吗？**
[✅ 开始实现（自动调用 /programmer）]
[❌ 暂不实现，仅更新 SPEC]
```

如果用户选择"开始实现"，自动调用：

```markdown
/programmer

# 根据 SPEC 实现功能

**关联 SPEC**：
- REQ-XXX
- DATA-XXX
- API-XXX

**请按标准流程执行**：
1. 分析现有代码
2. 制定计划
3. 展示计划等待确认
4. 调用 AI CLI 实现
5. 代码审查
6. 提交并更新 SPEC
```

---

## 交互模式

### 模式1：完整流程（SPEC → 代码）

```
用户输入需求
    ↓
/spec 引导描述
    ↓
交互式完善 SPEC
    ↓
调用 /architect 更新 SPEC
    ↓
自动调用 /programmer 实现
    ↓
完成
```

### 模式2：仅更新 SPEC

```
用户输入需求
    ↓
/spec 引导描述
    ↓
交互式完善 SPEC
    ↓
调用 /architect 更新 SPEC
    ↓
完成（不调用 /programmer）
```

**触发条件**：在"是否开始实现"环节选择"暂不实现"

---

## 与其他命令的协作

```
/spec (引导需求描述)
    ↓
/architect (更新 SPEC)
    ↓
/programmer (实现功能)
    ↓
/spec-audit (验证完整性)
```

**与 /spec-init 的区别**：

| 命令 | 用途 | 触发时机 |
|------|------|----------|
| /spec-init | 初始化项目 SPEC | 新项目或旧项目首次建立 SPEC |
| /spec | 完善单个功能 SPEC | 已有 SPEC，添加/修改具体功能 |

---

## 禁止操作

- ❌ **禁止跳过 SPEC 完整性检查**
- ❌ **禁止使用固定选项** - 必须开放式对话
- ❌ **禁止自行实现功能** - 必须通过 /programmer
- ❌ **禁止遗漏任何 SPEC 维度** - 需求/数据/API 必须完整

---

## 核心原则

**/spec = SPEC 需求描述态**

- 显式模式切换，强制聚焦 SPEC
- 交互式完善，确保 SPEC 完整
- 无缝衔接 /programmer，避免注意力分散
- 用户主导流程，AI 执行引导

---

## 示例对话

### 示例1：新功能

```
用户: /spec 实现用户注册功能

AI: # 🎯 SPEC 需求描述模式
    欢迎使用 SPEC-driven 开发！
    ...
    请描述注册功能的详细需求：

用户: 用户可以通过邮箱和密码注册，注册后需要验证邮箱

AI: 基于你的描述，我需要完善以下 SPEC：

    **1. 需求定义（REQ-AUTH-002）**
    - 功能名称：用户注册
    - 验收标准：
      - 支持邮箱+密码注册
      - 注册成功后发送验证邮件
      - [还有什么？]

    用户: 密码需要加密存储，邮箱验证链接24小时有效

    AI: **2. 数据模型（DATA-USER-001）**
    - 需要的字段：
      - email（邮箱）
      - password_hash（密码哈希）
      - email_verified（验证状态）
      - [还需要什么？]

    用户: 还需要 created_at 和 verification_token

    AI: **3. API 设计（API-AUTH-002）**
    - 端点：POST /api/auth/register
    - 请求格式：
      ```json
      {
        "email": "user@example.com",
        "password": "plain_password"
      }
      ```
    - 响应格式？

    用户: 返回用户ID和提示"验证邮件已发送"

    AI: ## 📋 SPEC 摘要
    [展示完整 SPEC]

    这个 SPEC 是否准确？
    [✅ 准确，更新 SPEC 并开始开发]
    用户: ✅

    AI: [调用 /architect 更新 SPEC]
    ✅ SPEC 已更新！
    现在开始实现吗？
    [✅ 开始实现]
    用户: ✅

    AI: [调用 /programmer 实现]
```

---

## 输出格式

### 成功输出（完整流程）

```markdown
✅ SPEC 需求描述流程完成！

**已更新的 SPEC**：
- REQ-AUTH-002：用户注册功能
- DATA-USER-001：用户表扩展
- API-AUTH-002：注册接口

**已实现功能**：
- 邮箱+密码注册
- 密码加密存储
- 邮箱验证机制
- 24小时验证链接有效期

**代码位置**：
- src/api/auth/register.ts
- src/models/user.ts
- src/services/email.ts

**下一步**：
1. 测试功能 → /programmer
2. 查看 SPEC → cat SPEC/01-REQUIREMENTS.md
```

### 仅更新 SPEC 输出

```markdown
✅ SPEC 更新完成！

**已更新的 SPEC**：
- REQ-XXX：[功能名]
- DATA-XXX：[实体名]
- API-XXX：[接口名]

**查看完整 SPEC**：
- cat SPEC/01-REQUIREMENTS.md
- cat SPEC/03-DATA-STRUCTURE.md
- cat SPEC/04-API-DESIGN.md

**开始实现时**：
- 再次执行 /spec 并选择"开始实现"
- 或直接调用 /programmer
```
