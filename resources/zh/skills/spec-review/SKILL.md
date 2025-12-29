# SPEC-REVIEW 技能规范 - SPEC一致性审查专家

**版本**: 2.0.0
**目的**: 审查SPEC定义与代码实现的一致性，发现偏差和遗漏
**职责**: SPEC-代码对齐检查、需求覆盖分析、架构符合性验证、契约文件审查、测试用例质量审查
**最后更新**: 2025-12-29

---

## 🎯 技能定位

**核心价值**：确保SPEC定义的需求、架构、数据模型、契约文件与代码实现完全一致

**适用场景**：
1. ✅ **开发完成后验证**：检查是否完整实现了SPEC定义的所有需求
2. ✅ **定期SPEC审计**：验证代码演进是否偏离了原设计
3. ✅ **PR审查前置检查**：在代码合并前验证SPEC符合性
4. ✅ **项目健康度检查**：评估SPEC与代码的同步程度
5. ✅ **产品级契约审查**：验证API/数据模型/配置定义的完整性和一致性
6. ✅ **测试质量审查**：验证测试用例覆盖SPEC需求的程度

---

## 🛠️ 执行流程

### 步骤0：审查范围检测

**检测当前状态**：
```bash
# 检查Git状态
git status
git branch
git log --oneline -5

# 检查是否有未提交的变更
git diff --name-only
git diff --cached --name-only

# 检查是否在PR中
[ -n "$PR_NUMBER" ] && echo "PR审查" || echo "分支审查"
```

**分类处理**：

| 场景 | 检测方法 | 处理流程 |
|------|---------|----------|
| **未提交变更** | `git status` 有修改 | 审查工作区变更 |
| **已提交未推送** | `git log` 有新提交 | 审查待推送提交 |
| **PR环境** | 环境变量有PR_NUMBER | 审查PR差异 |
| **无变更** | 无任何修改 | 提示无变更可审查 |

---

### 步骤1：SPEC文档加载

#### 1.1 读取所有SPEC文档

**核心SPEC文件**：
```
SPEC/01-REQUIREMENTS.md   → REQ-XXX 需求列表和验收标准
SPEC/02-ARCHITECTURE.md   → ARCH-XXX 架构决策和技术栈
SPEC/03-DATA-STRUCTURE.md → DATA-XXX 数据模型定义
SPEC/04-API-DESIGN.md     → API-XXX 接口规范
SPEC/05-UI-DESIGN.md      → UI-XXX UI设计（如前端）
```

**提取关键信息**：
- 所有REQ-XXX及其验收标准
- 所有ARCH-XXX及其技术决策
- 所有DATA-XXX及其表结构
- 所有API-XXX及其接口定义

#### 1.2 代码库分析

**调用Explore工具**：
```python
Task(
    subagent_type="Explore",
    prompt="""
分析代码库的当前实现状态，用于与SPEC对比。

扫描范围：
- 所有源代码文件（src/, lib/, app/, etc.）
- 配置文件（package.json, go.mod, requirements.txt, etc.）
- 数据库迁移文件或schema定义（如适用）
- API路由定义文件（如适用）

分析内容：
1. 实现的功能模块
2. 定义的数据表/模型
3. 暴露的API接口
4. 使用的库和技术栈
5. 文件结构和模块组织

输出格式：
- 功能清单（带文件路径）
- 数据模型清单（带字段列表）
- API接口清单（带端点和请求/响应格式）
- 技术栈清单
- 架构模式识别
"""
)
```

---

### 步骤2：SPEC-代码对齐检查

#### 2.1 需求覆盖分析（REQ-XXX vs 代码）

**检查项**：
```markdown
## 需求覆盖检查清单

### 完整性检查
- [ ] SPEC中定义的所有REQ-XXX是否都已实现？
- [ ] 每个REQ-XXX的验收标准是否满足？

### 偏差识别
- [ ] 代码实现了SPEC中没有的功能？
- [ ] 代码实现与SPEC定义有差异？

### 状态跟踪
| REQ-XXX | 需求描述 | SPEC状态 | 代码状态 | 符合性 |
|---------|---------|----------|----------|--------|
| REQ-AUTH-001 | 用户登录 | ✅ 已定义 | ✅ 已实现 | ✅ 一致 |
| REQ-AUTH-002 | Token刷新 | ✅ 已定义 | ❌ 未实现 | 🔴 缺失 |
| REQ-USER-001 | 用户资料 | ✅ 已定义 | ✅ 已实现 | ⚠️ 部分实现 |
```

**评分标准**：
| 符合性 | 说明 | 示例 |
|--------|------|------|
| ✅ 一致 | 代码完全符合SPEC定义 | 实现了所有验收标准 |
| ⚠️ 部分实现 | 代码只实现了部分功能 | 只实现了部分验收标准 |
| ❌ 未实现 | SPEC定义的功能未实现 | 代码中找不到相关实现 |
| ➕ 超出SPEC | 代码实现了SPEC外功能 | 代码有功能但SPEC无定义 |

#### 2.2 架构符合性检查（ARCH-XXX vs 代码）

**检查项**：
```markdown
## 架构符合性检查清单

### 技术栈一致性
- [ ] 编程语言是否符合ARCH-XXX定义？
- [ ] 框架选择是否符合ARCH-XXX定义？
- [ ] 数据库选择是否符合ARCH-XXX定义？
- [ ] 中间件选择是否符合ARCH-XXX定义？

### 模块划分一致性
- [ ] 代码模块划分是否符合ARCH-XXX设计？
- [ ] 模块职责是否与SPEC一致？
- [ ] 模块间依赖关系是否符合设计？

### 架构模式一致性
- [ ] 是否使用SPEC定义的架构模式（如MVC、微服务等）？
- [ ] 数据流是否符合SPEC定义？
- [ ] 事件流（如有）是否符合SPEC定义？
```

#### 2.3 数据模型一致性检查（DATA-XXX vs 代码）

**检查项**：
```markdown
## 数据模型一致性检查清单

### 表结构对比
| DATA-XXX | 表名 | SPEC定义字段 | 代码实现字段 | 符合性 |
|----------|------|-------------|-------------|--------|
| DATA-USER-001 | users | id, email, password_hash | id, email, password_hash | ✅ 一致 |
| DATA-USER-002 | profiles | user_id, bio, avatar | user_id, bio | ⚠️ 缺少avatar |

### 字段级别检查
- [ ] 所有必需字段是否存在？
- [ ] 字段类型是否一致？
- [ ] 字段约束（NOT NULL, UNIQUE等）是否一致？
- [ ] 索引定义是否符合SPEC？
- [ ] 关联关系（外键）是否符合SPEC？
```

#### 2.4 API接口一致性检查（API-XXX vs 代码）

**检查项**：
```markdown
## API接口一致性检查清单

### 端点对比
| API-XXX | 端点 | SPEC定义 | 代码实现 | 符合性 |
|---------|------|---------|---------|--------|
| API-AUTH-001 | POST /auth/login | ✅ 定义 | ✅ 实现 | ✅ 一致 |
| API-AUTH-002 | POST /auth/refresh | ✅ 定义 | ❌ 未实现 | 🔴 缺失 |

### 请求/响应格式对比
- [ ] 请求参数是否符合SPEC定义？
- [ ] 响应格式是否符合SPEC定义？
- [ ] 错误码是否符合API-XXX定义？
- [ ] 认证方式是否符合SPEC定义？
```

---

### 步骤3：产品级契约文件审查

#### 3.1 API契约完整性检查

**检查产品级API定义文件**：
```markdown
## API契约文件审查

### OpenAPI/Swagger规范检查
- [ ] 是否有完整的OpenAPI/Swagger定义文件？
- [ ] 所有API-XXX是否在OpenAPI中定义？
- [ ] 请求/响应schema是否完整？
- [ ] 错误码定义是否覆盖所有场景？
- [ ] 认证授权定义是否明确？

### GraphQL Schema检查（如适用）
- [ ] Schema文件是否与SPEC/04-API-DESIGN.md一致？
- [ ] 所有Query/Mutation/Subscription是否定义？
- [ ] 类型定义是否完整？
- [ ] Resolvers是否正确实现？
```

#### 3.2 数据模型契约检查

**检查数据库schema定义文件**：
```markdown
## 数据模型契约审查

### Prisma/TypeORM/Sequelize等ORM检查
- [ ] Schema文件是否与SPEC/03-DATA-STRUCTURE.md一致？
- [ ] 所有DATA-XXX表是否定义？
- [ ] 字段类型、约束、索引是否完整？
- [ ] 关联关系（外键）是否正确定义？

### Migration文件检查
- [ ] 数据库迁移文件是否与SPEC同步？
- [ ] 是否有未应用的迁移？
- [ ] 迁移是否可回滚？
- [ ] 索引定义是否在迁移中体现？
```

#### 3.3 配置文件契约检查

**检查环境变量和配置文件**：
```markdown
## 配置文件契约审查

### 环境变量定义检查
- [ ] .env.example 是否包含所有必需变量？
- [ ] 变量命名是否符合规范？
- [ ] 是否有敏感信息泄露风险？
- [ ] 默认值是否合理？

### 配置文件schema检查
- [ ] 配置文件是否有JSON Schema验证？
- [ ] 所有配置项是否在SPEC中定义？
- [ ] 环境差异配置是否正确？
```

---

### 步骤4：测试用例质量审查

#### 4.1 测试覆盖率分析

**检查测试用例是否覆盖SPEC需求**：
```markdown
## 测试覆盖率审查

### 需求级测试覆盖
| REQ-XXX | 需求描述 | 单元测试 | 集成测试 | E2E测试 | 覆盖率 |
|---------|---------|---------|---------|---------|--------|
| REQ-AUTH-001 | 用户登录 | ✅ | ✅ | ✅ | 100% |
| REQ-AUTH-002 | Token刷新 | ✅ | ❌ | ❌ | 33% |
| REQ-USER-001 | 用户资料 | ⚠️ | ✅ | ❌ | 66% |

**评分标准**：
- ✅ 完整覆盖：单元+集成+E2E都有
- ⚠️ 部分覆盖：只有单元测试
- ❌ 未覆盖：无测试
```

#### 4.2 测试用例质量检查

**检查测试用例的质量**：
```markdown
## 测试用例质量审查

### 单元测试质量
- [ ] 测试用例是否包含正常场景？
- [ ] 测试用例是否包含边界情况？
- [ ] 测试用例是否包含异常场景？
- [ ] Mock是否正确使用？
- [ ] 测试是否独立（无依赖）？

### 集成测试质量
- [ ] API接口测试是否覆盖所有端点？
- [ ] 数据库集成测试是否验证事务？
- [ ] 外部服务集成是否使用Test Double？

### E2E测试质量
- [ ] 关键用户流程是否覆盖？
- [ ] 测试数据是否真实？
- [ ] 测试环境是否与生产一致？
```

#### 4.3 验收标准验证

**检查测试是否验证SPEC中的验收标准**：
```markdown
## 验收标准测试覆盖

**REQ-AUTH-001 - 用户登录**
验收标准：
1. 支持邮箱和手机号登录 → ✅ 测试覆盖
2. 密码错误3次锁定账户 → ✅ 测试覆盖
3. 登录成功返回JWT Token → ❌ 缺少Token验证测试

**缺失的测试**：
- JWT Token格式验证
- Token过期处理
```

---

### 步骤5：偏差分析与汇总

#### 5.1 偏差分类

**按偏差类型分类**：

| 偏差类型 | 严重程度 | 说明 | 示例 |
|---------|---------|------|------|
| **🔴 严重** | 阻塞发布 | SPEC定义的功能未实现 | REQ-AUTH-002在SPEC中但代码没有 |
| **🟡 主要** | 影响质量 | 代码实现与SPEC定义不一致 | API响应格式不符合API-XXX |
| **🟢 次要** | 需关注 | 代码实现了SPEC外的功能 | 代码有功能但SPEC无定义 |

**按影响范围分类**：

| 影响范围 | 检查维度 | 示例 |
|---------|---------|------|
| **需求层面** | REQ-XXX覆盖 | 5个需求未实现，3个部分实现 |
| **架构层面** | ARCH-XXX符合 | 技术栈不一致，模块划分偏差 |
| **数据层面** | DATA-XXX一致 | 2个表缺少字段，1个索引缺失 |
| **接口层面** | API-XXX一致 | 3个接口未实现，响应格式偏差 |
| **契约层面** | 契约文件一致 | OpenAPI与SPEC不一致，Schema缺失 |
| **测试层面** | 测试覆盖质量 | 10个需求无测试，5个测试不完整 |

#### 5.2 生成审查报告

**报告格式**：
```markdown
## 📋 SPEC一致性审查报告

**审查范围**：
- 项目：cc-spec-lite
- 分支：main
- 提交：19baac1

**审查内容**：
- SPEC文档：5个（01/02/03/04/05）
- 需求ID：8个 REQ-XXX
- 架构ID：3个 ARCH-XXX
- 数据ID：5个 DATA-XXX
- 接口ID：6个 API-XXX
- 契约文件：OpenAPI, Prisma Schema
- 测试用例：单元/集成/E2E

**审查结果**：
- ✅ 一致：12项
- ⚠️ 部分实现：3项
- ❌ 未实现：2项
- ➕ 超出SPEC：1项

**总体评分**：78% (18/23项一致)
**契约文件一致性**：80% (OpenAPI完整，Schema需补充)
**测试覆盖率**：60% (部分需求无测试)

---

### 🔴 严重偏差（必须修复）

#### 1. [需求缺失] REQ-AUTH-002 Token刷新机制未实现
**SPEC定义**: `SPEC/01-REQUIREMENTS.md:REQ-AUTH-002`
**要求**: 实现JWT token刷新机制，包括refresh token存储和验证
**代码状态**: ❌ 未找到相关实现
**影响**: 用户需要频繁登录，体验差
**建议**:
1. 调用 /architect 补充详细设计（如需要）
2. 调用 /programmer 实现 REQ-AUTH-002

#### 2. [数据缺失] DATA-USER-003 profiles表缺少avatar字段
**SPEC定义**: `SPEC/03-DATA-STRUCTURE.md:DATA-USER-003`
**要求**: profiles表包含字段：user_id, bio, avatar, created_at
**代码实现**: 代码中只有 user_id, bio，缺少 avatar 和 created_at
**位置**: `src/models/user.py:15-20`
**影响**: 用户无法上传头像，功能不完整
**建议**:
1. 调用 /architect 更新 DATA-USER-003 设计（如需要）
2. 调用 /programmer 补充缺失字段

---

### 🟡 主要偏差（建议修复）

#### 1. [接口偏差] API-AUTH-001 响应格式不符合SPEC
**SPEC定义**: `SPEC/04-API-DESIGN.md:API-AUTH-001`
**要求**: 返回 `{token, expires_at, refresh_token}`
**代码实现**: `src/auth/handlers.py:45` 只返回 `{token}`
**影响**: 前端无法获取token过期时间和refresh token
**建议**: 修改返回格式以符合API-AUTH-001定义

#### 2. [架构偏差] ARCH-CACHE-001 Redis缓存未使用
**SPEC定义**: `SPEC/02-ARCHITECTURE.md:ARCH-CACHE-001`
**要求**: 使用Redis缓存用户session和权限数据
**代码实现**: 代码中未找到Redis相关配置和使用
**影响**: 性能可能不佳，数据库压力大
**建议**:
1. 如需调整架构：调用 /architect 更新 ARCH-CACHE-001
2. 如实现缓存：调用 /programmer 补充Redis集成

---

### 🟢 次要偏差（需关注）

#### 1. [超出SPEC] 代码实现了SPEC未定义的密码重置功能
**代码位置**: `src/auth/routes.py:80-120`
**功能**: POST /auth/reset-password
**SPEC状态**: SPEC中无对应REQ-XXX定义
**影响**: 功能无SPEC追溯，可能影响设计一致性
**建议**:
1. 调用 /architect 补充 REQ-AUTH-XXX 定义
2. 或删除该功能（如不需要）

#### 2. [契约文件缺失] OpenAPI定义不完整
**问题位置**: `openapi.yaml:50-100`
**SPEC定义**: API-AUTH-001 要求返回 refresh_token
**OpenAPI状态**: 响应schema中缺少 refresh_token 字段
**影响**: API文档与SPEC不一致，前端对接可能出错
**建议**: 更新 openapi.yaml 以匹配 API-XXX 定义

#### 3. [测试覆盖不足] REQ-USER-001 缺少集成测试
**需求**: REQ-USER-001 用户资料管理
**单元测试**: ✅ 已覆盖
**集成测试**: ❌ 缺失
**E2E测试**: ❌ 缺失
**影响**: 无法验证模块间交互是否正确
**建议**: 补充集成测试和E2E测试

---

## 📊 详细对比矩阵

### 需求覆盖矩阵

| REQ-XXX | 需求描述 | SPEC状态 | 代码状态 | 符合性 | 位置 |
|---------|---------|----------|----------|--------|------|
| REQ-AUTH-001 | 用户登录 | ✅ 已定义 | ✅ 已实现 | ✅ 一致 | src/auth/handlers.py:30 |
| REQ-AUTH-002 | Token刷新 | ✅ 已定义 | ❌ 未实现 | 🔴 缺失 | - |
| REQ-AUTH-003 | 密码重置 | ✅ 已定义 | ✅ 已实现 | ✅ 一致 | src/auth/handlers.py:80 |
| REQ-USER-001 | 用户资料 | ✅ 已定义 | ⚠️ 部分 | ⚠️ 缺字段 | src/models/user.py:15 |
| REQ-USER-002 | 资料更新 | ✅ 已定义 | ✅ 已实现 | ✅ 一致 | src/user/handlers.py:45 |

### 数据模型对比矩阵

| DATA-XXX | 表名 | SPEC字段 | 代码字段 | 符合性 | 差异 |
|----------|------|---------|---------|--------|------|
| DATA-USER-001 | users | id, email, password | id, email, password | ✅ 一致 | 无 |
| DATA-USER-002 | profiles | user_id, bio, avatar | user_id, bio | ⚠️ 缺字段 | 缺少avatar |
| DATA-USER-003 | sessions | user_id, token, expires | user_id, token | ⚠️ 缺字段 | 缺少expires |

### API接口对比矩阵

| API-XXX | 端点 | SPEC定义 | 代码实现 | 符合性 | 差异 |
|---------|------|---------|---------|--------|------|
| API-AUTH-001 | POST /auth/login | ✅ 定义 | ✅ 实现 | ✅ 一致 | 无 |
| API-AUTH-002 | POST /auth/refresh | ✅ 定义 | ❌ 未实现 | 🔴 缺失 | 未实现 |
| API-AUTH-003 | POST /auth/logout | ✅ 定义 | ✅ 实现 | ⚠️ 格式偏差 | 响应格式不符 |

### 契约文件对比矩阵

| 契约类型 | SPEC定义 | 文件状态 | 符合性 | 差异 |
|---------|---------|---------|--------|------|
| OpenAPI | 6个API-XXX | ✅ 存在 | ⚠️ 80%一致 | 缺少2个端点定义 |
| Prisma Schema | 5个DATA-XXX | ✅ 存在 | ✅ 100%一致 | 无 |
| .env.example | 8个配置项 | ⚠️ 部分存在 | ⚠️ 75%一致 | 缺少2个环境变量 |

### 测试覆盖矩阵

| REQ-XXX | 需求描述 | 单元测试 | 集成测试 | E2E测试 | 覆盖率 |
|---------|---------|---------|---------|---------|--------|
| REQ-AUTH-001 | 用户登录 | ✅ | ✅ | ✅ | 100% |
| REQ-AUTH-002 | Token刷新 | ✅ | ❌ | ❌ | 33% |
| REQ-USER-001 | 用户资料 | ✅ | ⚠️ | ❌ | 66% |
| REQ-ORDER-001 | 创建订单 | ⚠️ | ❌ | ❌ | 20% |

---

## ✅ 审查建议

### 立即行动
1. 实现缺失的 REQ-AUTH-002 (Token刷新)
2. 补充 DATA-USER-003 的缺失字段
3. 修复 API-AUTH-001 的响应格式
4. 更新 OpenAPI 定义以匹配 SPEC

### 短期改进
1. 实现 ARCH-CACHE-001 定义的Redis缓存
2. 补充 REQ-USER-001 的完整实现
3. 统一所有API接口的响应格式
4. 补充缺失的环境变量到 .env.example
5. 为关键需求补充集成测试

### 长期优化
1. 为超出SPEC的功能补充SPEC定义
2. 定期执行SPEC一致性审查
3. 建立SPEC-代码同步机制
4. 提升测试覆盖率到80%以上
5. 建立契约文件自动同步机制

### 后续操作
- 需要更新SPEC？→ 调用 /architect
- 需要实现功能？→ 调用 /programmer
- 需要补充测试？→ 调用 /programmer（测试类型：local）
- 需要重新审查？→ 再次调用 /spec-review
```

---

## 🚨 核心铁律

### 铁律1：SPEC是唯一真源
- ✅ 审查以SPEC为唯一标准
- ❌ 不以代码实现反推SPEC
- ⚠️ 代码与SPEC不一致 = 需要修复

### 铁律2：全面检查，无遗漏
- ✅ 检查所有REQ-XXX、ARCH-XXX、DATA-XXX、API-XXX
- ✅ 识别所有缺失、偏差、超出SPEC的部分
- ❌ 禁止选择性检查

### 铁律3：建设性反馈
- ✅ 明确指出偏差位置和类型
- ✅ 提供具体的修复建议（调用architect或programmer）
- ❌ 避免模糊的"不一致"描述

### 铁律4：数据驱动
- ✅ 基于实际代码分析，不凭猜测
- ✅ 使用Explore工具深入扫描
- ✅ 提供具体的文件路径和行号

---

## 🔧 技术实现

### 调用Explore工具

**时机**：步骤1.2（代码库分析）

**目的**：全面扫描代码库，提取实现信息

**扫描重点**：
- 功能模块识别（通过文件名、类名、函数名）
- 数据模型识别（通过ORM定义、schema文件、migration）
- API接口识别（通过路由定义、controller、handler）
- 技术栈识别（通过配置文件、依赖文件、import语句）

### 调用architect/programmer

**时机**：发现偏差需要修复时

**目的**：
- 调用 /architect：更新或补充SPEC定义
- 调用 /programmer：实现缺失的功能或修正偏差

---

## 📋 使用示例

### 示例1：完整项目审查

```
用户：/review

review：🔍 正在执行SPEC一致性审查...
review：
review：步骤1：加载SPEC文档...
review：  - 发现 8个 REQ-XXX
review：  - 发现 3个 ARCH-XXX
review：  - 发现 5个 DATA-XXX
review：  - 发现 6个 API-XXX
review：
review：步骤2：扫描代码库...
review：[调用Explore工具]
review：  - 识别 12个功能模块
review：  - 识别 5个数据模型
review：  - 识别 5个API接口
review：
review：步骤3：对比分析...
review：
review：📋 审查报告
review：================
review：✅ 一致：12项
review：⚠️ 部分实现：3项
review：❌ 未实现：2项
review：➕ 超出SPEC：1项
review：
review：总体评分：78%
review：
review：🔴 严重偏差（2个）：
review：1. REQ-AUTH-002 Token刷新未实现
review：2. DATA-USER-003 缺少avatar字段
review：
review：🟡 主要偏差（3个）：
review：[列出主要偏差]
review：
review：建议操作：
review：- 实现缺失功能 → /programmer
review：- 更新SPEC定义 → /architect
review：
用户：帮我修复 REQ-AUTH-002

review：好的，我将调用 /programmer 实现 Token刷新功能...
```

### 示例2：特定需求审查

```
用户：/review --req REQ-AUTH-001

review：正在审查 REQ-AUTH-001 (用户登录)...
review：
review：SPEC定义：
review：- 位置：SPEC/01-REQUIREMENTS.md:45-60
review：- 验收标准：[1] 支持email/password登录 [2] 返回JWT token [3] 失败有明确错误
review：
review：代码实现：
review：- 位置：src/auth/handlers.py:30-50
review：- 实现状态：✅ 已实现
review：
review：一致性检查：
review：✅ 验收标准[1]：满足（支持email/password登录）
review：✅ 验收标准[2]：满足（返回JWT token）
review：⚠️ 验收标准[3]：部分满足（错误信息不够明确）
review：
review：结论：⚠️ 部分一致（建议改进错误信息）
```

---

