# SPEC-INIT 技能规范 - SPEC初始化专家

**版本**: 1.0.0
**目的**: 为新项目或现有项目快速生成SPEC文档集合
**职责**: 项目状态检测、代码逆向分析、交互式SPEC设计、文档生成
**最后更新**: 2025-12-27

---

## 🎯 技能定位

**核心价值**：降低SPEC-driven development的入门门槛，快速启动项目

**适用场景**：
1. ✅ **空项目初始化**：目录为空或刚创建，需要从零设计SPEC
2. ✅ **现有项目补全**：已有代码但无SPEC，需要逆向生成SPEC文档
3. ✅ **SPEC补充完善**：已有部分SPEC，需要补充缺失内容

---

## 🛠️ 执行流程

### 步骤0：项目状态检测

**检测项**：
```bash
# 检查目录结构
[ -d "SPEC/" ] && echo "有SPEC目录" || echo "无SPEC目录"
[ -f "SPEC/VERSION" ] && echo "有VERSION文件" || echo "无VERSION文件"

# 检查代码文件
find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" \) | wc -l

# 检查配置文件
[ -f "package.json" ] && echo "Node.js项目"
[ -f "go.mod" ] && echo "Go项目"
[ -f "requirements.txt" ] && echo "Python项目"
[ -f "pom.xml" ] && echo "Java/Maven项目"
```

**状态分类**：

| 状态 | 判断标准 | 处理流程 |
|------|---------|----------|
| **空项目** | 无代码文件、无SPEC | → 步骤1A：交互式设计 |
| **遗留项目** | 有代码、无SPEC | → 步骤1B：逆向生成 |
| **部分SPEC** | 有代码、有SPEC但不完整 | → 步骤1C：补充完善 |
| **完整项目** | 有代码、SPEC完整 | → 提示已就绪 |

---

## 步骤1A：空项目 - 交互式设计

### 1A.1 项目信息收集

**必填信息**：
```markdown
## 项目基本信息

1. 项目名称：__________
2. 项目类型：[Web应用/后端服务/CLI工具/库/SDK/其他]
3. 技术栈：[编程语言、框架、数据库]
4. 核心功能：[2-3句话描述项目要解决的问题]
```

**示例对话**：
```
🤖 欢迎使用SPEC-INIT！让我帮您快速建立SPEC文档。

请告诉我：
1. 项目名称是什么？
2. 这是什么类型的项目？（Web应用/后端服务/CLI工具/库等）
3. 计划使用什么技术栈？
4. 这个项目要解决什么问题？

用户：我要做一个用户认证服务
用户：使用Go和gRPC
用户：提供统一的用户登录、注册、权限管理
```

### 1A.2 引导式设计

**设计流程**：
```
收集基本信息
    ↓
阶段1：功能需求（01-REQUIREMENTS.md）
  ├─ 核心功能是什么？
  ├─ 有哪些关键用户角色？
  └─ 主要用户场景有哪些？
    ↓
阶段2：架构设计（02-ARCHITECTURE.md）
  ├─ 系统如何分层？
  ├─ 有哪些主要模块？
  └─ 模块间如何通信？
    ↓
阶段3：数据设计（03-DATA-STRUCTURE.md）
  ├─ 需要存储哪些数据？
  ├─ 数据表如何设计？
  └─ 有哪些核心实体？
    ↓
阶段4：API设计（04-API-DESIGN.md，如适用）
  ├─ 对外提供什么接口？
  ├─ 请求/响应格式是什么？
  └─ 错误码如何定义？
    ↓
阶段5：初始化完成
  ├─ 创建SPEC/VERSION
  ├─ 生成所有文档
  └─ 提供后续指引
```

**关键原则**：
- ✅ **用户主导设计**：不推荐方案，只提问收集
- ✅ **逐步完善**：一次设计一个领域，避免信息过载
- ✅ **即时验证**：每完成一个文档，询问用户是否确认
- ❌ **不生成代码**：只生成SPEC文档，代码由 /programmer 负责

---

## 步骤1B：现有项目 - 逆向生成

### 1B.1 代码库分析

**调用Explore工具**：
```python
Task(
    subagent_type="Explore",
    prompt="""
分析这个代码库的结构和功能，用于生成SPEC文档。

扫描范围：
- 所有源代码文件
- 配置文件（package.json, go.mod, requirements.txt等）
- 现有文档（README.md, docs/等）

分析内容：
1. 项目类型和主要功能
2. 技术栈（语言、框架、数据库、中间件）
3. 模块划分和目录结构
4. 数据模型（如果有数据库相关代码）
5. API接口（如果有HTTP/gRPC接口）
6. 核心业务逻辑

输出格式：
- 项目概述
- 功能清单
- 模块结构
- 技术栈列表
- 数据模型摘要
- API接口清单
"""
)
```

### 1B.2 SPEC文档生成

**生成策略**：
```
基于Explore分析结果
    ↓
识别缺失的SPEC文档
    ↓
调用architect技能生成
    ↓
展示生成的SPEC内容
    ↓
用户确认后写入文件
```

**生成规范**：
- ✅ 保留项目实际内容（不凭空捏造）
- ✅ 使用表格格式（语言无关）
- ✅ 标注来源（代码位置、文件路径）
- ❌ 不添加代码中不存在的内容
- ⚠️ 不确定的内容标记为 `[待确认]`

**示例输出**：
```markdown
# 01-REQUIREMENTS.md（逆向生成）

## REQ-INIT-001: 用户认证（来源：auth/service.go）

**功能描述**：基于代码分析，此模块提供用户认证功能

**用户角色**：
- 管理员（来源：role_admin表）
- 普通用户（来源：role_user表）

**核心功能**：
- [ ] 用户登录（来源：Login()函数）
- [ ] 用户注册（来源：Register()函数）
- [ ] Token验证（来源：VerifyToken()函数）

**待确认项**：
- [ ] 验收标准需要用户提供
- [ ] 业务规则需要补充说明
```

---

## 步骤1C：部分SPEC - 补充完善

### 1C.1 缺失检测

**检查SPEC完整性**：
```bash
# 检查哪些SPEC文件存在
ls -1 SPEC/*.md

# 检查VERSION文件
cat SPEC/VERSION

# 检查ID定义
grep -c "^REQ-" SPEC/01-REQUIREMENTS.md
grep -c "^ARCH-" SPEC/02-ARCHITECTURE.md
grep -c "^DATA-" SPEC/03-DATA-STRUCTURE.md
grep -c "^API-" SPEC/04-API-DESIGN.md
```

**完整性判断矩阵**：

| SPEC文件 | 状态 | 处理方式 |
|----------|------|----------|
| 01-REQUIREMENTS.md | 存在但REQ-XXX<5个 | 调用architect补充 |
| 02-ARCHITECTURE.md | 不存在 | 调用architect生成 |
| 03-DATA-STRUCTURE.md | 不存在 | 调用architect生成 |
| 04-API-DESIGN.md | 不存在 | 调用architect生成（如有API） |
| 05-UI-DESIGN.md | 不存在 | 调用architect生成（如前端） |

### 1C.2 补充生成

**补充流程**：
```
检测缺失内容
    ↓
展示缺失清单给用户
    ↓
询问用户补充策略
  ├─ 自动生成（基于代码分析）
  ├─ 交互式设计（用户主导）
  └─ 混合模式（部分自动+部分交互）
    ↓
调用architect执行补充
    ↓
验证SPEC完整性
```

---

## 步骤2：SPEC完整性验证

### 验证检查清单

**文件级检查**：
- [ ] SPEC/VERSION 存在且格式正确
- [ ] 01-REQUIREMENTS.md 存在且包含 REQ-XXX
- [ ] 02-ARCHITECTURE.md 存在且包含 ARCH-XXX
- [ ] 03-DATA-STRUCTURE.md 存在（如有数据）
- [ ] 04-API-DESIGN.md 存在（如有API）
- [ ] 05-UI-DESIGN.md 存在（如前端）

**内容级检查**：
- [ ] 每个 REQ-XXX 有明确描述
- [ ] 每个 ARCH-XXX 有技术栈定义
- [ ] 每个 DATA-XXX 有表结构定义
- [ ] 每个 API-XXX 有接口定义
- [ ] 无 TODO/FIXME 占位符

**关联性检查**：
- [ ] REQ-XXX 可追溯到 DATA-XXX
- [ ] REQ-XXX 可追溯到 API-XXX
- [ ] 数据模型与API一致

---

## 步骤3：完成与后续指引

### 3.1 生成完成报告

```markdown
## 🎉 SPEC初始化完成！

### 已生成文档
✅ SPEC/VERSION
✅ SPEC/01-REQUIREMENTS.md (X个需求)
✅ SPEC/02-ARCHITECTURE.md (X个架构决策)
✅ SPEC/03-DATA-STRUCTURE.md (X个数据模型)
✅ SPEC/04-API-DESIGN.md (X个API接口)

### 下一步操作
1. 审查生成的SPEC文档
2. 补充[待确认]的内容
3. 开始开发：/programmer
4. 更新SPEC：/architect

### 持续改进
- 代码实现后更新SPEC状态
- 发现遗漏时及时补充
- 定期审查SPEC与代码一致性
```

### 3.2 提供快速指引

**根据项目类型提供指引**：

| 项目类型 | 下一步建议 |
|---------|-----------|
| **空项目** | "现在可以调用 /programmer 开始开发了" |
| **现有项目** | "请审查逆向生成的SPEC，补充缺失内容" |
| **部分SPEC** | "已补充缺失部分，现在可以继续开发" |

---

## 🚨 核心铁律

### 铁律1：用户主导设计
- ❌ 禁止推荐技术栈或架构方案
- ❌ 禁止替用户做决策
- ✅ 只提问、收集信息、整理成文档
- ✅ 用户确认后才写入

### 铁律2：不生成代码
- ❌ 禁止在spec-init中生成任何代码
- ❌ 禁止创建Issue或调用programmer
- ✅ 只生成SPEC文档
- ✅ 代码由 /programmer 负责

### 铁律3：保留实际内容
- ✅ 逆向生成时只反映代码中的实际内容
- ❌ 不凭空添加代码中不存在的内容
- ⚠️ 不确定的内容标记为 `[待确认]`

### 铁律4：完整交付
- ❌ 禁止留下TODO/FIXME占位符
- ✅ 必须一次性生成完整的文档结构
- ✅ [待确认] 标记是明确的待办项，不是占位符

---

## 📋 输出规范

### SPEC/VERSION 格式
```
v1.0.0
```

### 01-REQUIREMENTS.md 模板
```markdown
# 需求规范

## REQ-XXX: [功能名称]

**描述**：[功能描述]

**用户角色**：[角色列表]

**验收标准**：
- [ ] [标准1]
- [ ] [标准2]
- [ ] [标准3]
```

### 02-ARCHITECTURE.md 模板
```markdown
# 架构设计

## ARCH-XXX: [架构决策名称]

**决策**：[决策描述]

**理由**：[选择理由]

**技术栈**：
- [编程语言]
- [框架]
- [数据库]
- [中间件]
```

---

## 🔧 技术实现

### 调用Explore工具

**时机**：步骤1B（现有项目逆向生成）

**目的**：全面扫描代码库，提取架构信息

**输入**：项目根目录路径

**输出**：结构化的项目分析报告

### 调用architect技能

**时机**：
- 步骤1A（交互式设计的最后阶段）
- 步骤1B（逆向生成后完善）
- 步骤1C（补充缺失SPEC）

**目的**：生成/完善SPEC文档

**输入**：收集的项目信息或代码分析结果

**输出**：符合architect规范的SPEC文档

---

## 📊 使用示例

### 示例1：空项目初始化

```
用户：/spec-init

spec-init：欢迎！让我帮您建立SPEC文档。
spec-init：检测到这是一个空项目。
spec-init：请告诉我项目名称？

用户：我的用户认证服务

spec-init：明白。这是什么类型的项目？
[用户回答：后端服务、Go语言、gRPC接口]

spec-init：好的，核心功能是什么？
[用户回答：提供统一的登录、注册、权限管理]

spec-init：明白了，让我为您设计SPEC...
[生成交互式设计问题]

spec-init：🎉 SPEC初始化完成！已生成5个文档。
spec-init：下一步：/programmer 开始实现
```

### 示例2：现有项目逆向生成

```
用户：/spec-init

spec-init：正在检测项目状态...
spec-init：检测到这是现有项目（Go语言，123个文件）
spec-init：正在分析代码库...
[调用Explore工具]

spec-init：分析完成！发现：
spec-init：- 3个主要模块：auth, user, api
spec-init：- 5个数据表：user, role, permission, token, session
spec-init：- 12个API接口

spec-init：正在生成SPEC文档...
[生成逆向SPEC]

spec-init：🎉 SPEC初始化完成！
spec-init：⚠️ 发现12处[待确认]内容，请审查补充。
spec-init：下一步：审查SPEC → /programmer 开始开发
```

---

## 版本历史
- v1.0.0 (2025-12-27): 初始版本，定义SPEC初始化流程
