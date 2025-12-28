---
description: SPEC审查 - 验证SPEC完整性和代码一致性
argument-hint: [审查范围(全部/REQ-XXX)]
---

# SPEC审查命令

## 核心功能

**全面审查SPEC的完整性和代码实现一致性**

- 验证所有需求都有明确的验收标准
- 检查代码实现与SPEC的一致性
- 生成完整性报告

---

## 执行流程

### 阶段0：自动扫描

```bash
echo "=== SPEC 审查开始 ==="

# 1. 检查 SPEC/ 目录
if [ ! -d "SPEC" ]; then
    echo "❌ SPEC/ 目录不存在"
    echo "请先运行 /spec-init 初始化SPEC"
    exit 1
fi

# 2. 统计SPEC文件
req_count=$(grep -c "REQ-" SPEC/01-REQUIREMENTS.md 2>/dev/null || echo 0)
arch_count=$(grep -c "ARCH-" SPEC/02-ARCHITECTURE.md 2>/dev/null || echo 0)
data_count=$(grep -c "DATA-" SPEC/03-DATA-STRUCTURE.md 2>/dev/null || echo 0)
api_count=$(grep -c "API-" SPEC/04-API-DESIGN.md 2>/dev/null || echo 0)

echo "检测到："
echo "- 需求 (REQ-XXX): $req_count 个"
echo "- 架构 (ARCH-XXX): $arch_count 个"
echo "- 数据 (DATA-XXX): $data_count 个"
echo "- 接口 (API-XXX): $api_count 个"
```

---

### 阶段1：格式验证

```bash
# 运行格式验证
spec validate SPEC/ 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️  SPEC 格式验证失败"
    echo "请先修复格式问题"
    exit 1
fi

echo "✅ SPEC 格式验证通过"
```

**检查项：**

| 检查项 | 验证内容 | 失败处理 |
|-------|---------|---------|
| 文件完整性 | 6个核心文件存在 | 提示缺失文件 |
| VERSION格式 | v{major}.{minor}.{patch} | 提示格式错误 |
| ID格式 | REQ-XXX/ARCH-XXX/DATA-XXX/API-XXX | 提示ID格式错误 |
| 文档结构 | 标题层级、列表格式正确 | 提示结构问题 |

---

### 阶段2：需求完整性审查

**逐个检查每个REQ-XXX：**

#### 2.1 验收标准检查

```markdown
**审查项：每个需求是否有明确的验收标准**

遍历 01-REQUIREMENTS.md 中的所有 REQ-XXX：

**REQ-XXX - [需求名称]**
- ✅ 有验收标准
- ❌ 缺少验收标准 → [提示补充]

**缺少验收标准的示例：**
❌ "用户登录"（无验收标准）
✅ "用户登录"
   - 验收标准：
     - 支持邮箱和手机号登录
     - 密码错误3次锁定账户
     - 登录成功返回JWT Token
```

#### 2.2 优先级检查

```markdown
**审查项：每个需求是否有明确的优先级**

**REQ-XXX - [需求名称]**
- ✅ 有优先级标记（P0/P1/P2）
- ❌ 缺少优先级 → [提示补充]

**优先级定义：**
- P0: 核心功能，必须实现
- P1: 重要功能，应该实现
- P2: 次要功能，可以延后
```

#### 2.3 可追溯性检查

```markdown
**审查项：每个需求是否可以追溯到代码**

检查方式：
1. 搜索代码库中是否有对应的实现
2. 检查Git提交记录是否有引用

**REQ-XXX - [需求名称]**
- ✅ 代码已实现（src/xxx/yyy.ts:123）
- ⚠️  代码部分实现（缺少 ZZZ 功能）
- ❌ 代码未实现 → [提示是否需要实现]
```

---

### 阶段3：架构一致性审查

**检查 ARCH-XXX 与实际代码架构的一致性：**

#### 3.1 模块实现检查

```markdown
**审查项：架构模块是否已实现**

**ARCH-XXX - [模块名]**
- ✅ 代码目录存在（src/modules/xxx/）
- ✅ 模块接口完整（index.ts 导出所有API）
- ❌ 模块未找到 → [提示是否需要创建]
```

#### 3.2 技术栈一致性

```markdown
**审查项：实际使用的技术栈与SPEC是否一致**

**SPEC中定义：**
- 后端框架：NestJS
- 数据库：PostgreSQL
- ORM：Prisma

**实际检查：**
- ✅ package.json 包含 @nestjs/core
- ✅ package.json 包含 @prisma/client
- ❌ 未找到 PostgreSQL 相关配置 → [提示修正]
```

#### 3.3 依赖关系验证

```markdown
**审查项：模块间依赖关系是否与SPEC一致**

**ARCH-001** - 用户模块
- SPEC中依赖：认证模块
- 实际代码检查：
  - ✅ import { auth } from '../auth'
  - ❌ 未找到依赖 → [提示修正]
```

---

### 阶段4：数据模型审查

**检查 DATA-XXX 与数据库schema的一致性：**

#### 4.1 表结构检查

```markdown
**审查项：数据库表是否与SPEC一致**

**DATA-USER-001** - users 表
- SPEC定义：字段 id, email, password_hash, created_at
- 实际检查：
  - Prisma schema: ✅ 包含所有字段
  - 数据库表: ⚠️  缺少索引 idx_email
  - 建议：运行迁移添加索引
```

#### 4.2 关系完整性

```markdown
**审查项：外键关系是否正确建立**

**DATA-ORDER-001** - orders 表
- SPEC定义：关联到 users (user_id)
- 实际检查：
  - ✅ 外键约束存在
  - ✅ 级联删除配置正确
```

#### 4.3 索引验证

```markdown
**审查项：查询必需的索引是否存在**

**DATA-PRODUCT-001** - products 表
- SPEC定义：索引 idx_category, idx_price
- 实际检查：
  - ✅ idx_category 存在
  - ❌ idx_price 缺失 → [性能风险，提示添加]
```

---

### 阶段5：API一致性审查

**检查 API-XXX 与实际路由定义的一致性：**

#### 5.1 接口实现检查

```markdown
**审查项：API接口是否已实现**

**API-USER-001** - POST /api/users/register
- SPEC定义：创建用户
- 实际检查：
  - ✅ 路由已注册（src/routes/users.ts:15）
  - ✅ 请求参数符合SPEC
  - ❌ 响应格式不符 → SPEC要求 code/message，实际返回 status
```

#### 5.2 错误码覆盖

```markdown
**审查项：定义的错误码是否都有实现**

**API-ORDER-001** - GET /api/orders/:id
- SPEC定义错误码：
  - 404: 订单不存在
  - 403: 无权限访问
- 实际检查：
  - ✅ 404 已实现
  - ❌ 403 未实现 → [提示补充]
```

#### 5.3 认证授权检查

```markdown
**审查项：需要认证的接口是否都有保护**

**API-PAYMENT-001** - POST /api/payments
- SPEC要求：需要Bearer Token认证
- 实际检查：
  - ✅ 有 @UseGuards(AuthGuard) 装饰器
  - ✅ Token验证逻辑正确
```

---

### 阶段6：生成审查报告

```markdown
# SPEC 审查报告

生成时间: $(date)

## 📊 总体评分

| 维度 | 得分 | 状态 |
|------|------|------|
| 格式完整性 | 100% | ✅ |
| 需求完整性 | 85% | ⚠️  |
| 架构一致性 | 90% | ✅ |
| 数据一致性 | 75% | ⚠️  |
| API一致性 | 95% | ✅ |

**综合评分: 89%**

---

## ✅ 通过项

**格式验证:**
- ✅ 所有文件格式正确
- ✅ ID格式符合规范
- ✅ VERSION 格式正确

**架构一致性:**
- ✅ 所有 ARCH-XXX 模块已实现
- ✅ 技术栈与SPEC一致

**API一致性:**
- ✅ 95% 的API已实现
- ✅ 错误码定义完整

---

## ⚠️  警告项

**需求完整性:**
- ⚠️  REQ-USER-005 缺少验收标准
- ⚠️  REQ-ORDER-003 优先级未定义

**数据一致性:**
- ⚠️  DATA-PRODUCT-001 缺少 idx_price 索引
- ⚠️  DATA-ORDER-001 外键级联规则未实现

---

## ❌ 失败项

**需求实现不完整:**
- ❌ REQ-CHECKOUT-001 代码未实现
- ❌ REQ-PAYMENT-002 代码部分实现（缺少退款功能）

**建议:**
1. 补充缺失的验收标准
2. 实现未完成的需求
3. 添加缺失的数据库索引
4. 修复API响应格式不一致

---

## 📋 问题清单

| ID | 类型 | 严重性 | 描述 | 建议 |
|----|------|--------|------|------|
| 1 | 需求 | 中 | REQ-USER-005 缺少验收标准 | 补充验收标准 |
| 2 | 需求 | 高 | REQ-CHECKOUT-001 未实现 | 实现该功能 |
| 3 | 数据 | 中 | DATA-PRODUCT-001 缺少索引 | 添加 idx_price |
| 4 | API | 中 | API-USER-001 响应格式不符 | 修正为 code/message |

---

## 🎯 改进建议

1. **需求完整性**
   - 为所有需求补充验收标准
   - 明确所有需求的优先级
   - 实现所有未完成的需求

2. **数据一致性**
   - 运行数据库迁移添加缺失索引
   - 实现所有外键约束

3. **API一致性**
   - 修正响应格式不一致问题
   - 补充缺失的错误码处理

4. **文档更新**
   - 及时更新SPEC反映最新实现
   - 确保SPEC和代码保持同步
```

---

## 完成提示

```markdown
✅ SPEC 审查完成！

**审查结果:**
- 格式完整性: ✅ 100%
- 需求完整性: ⚠️  85%
- 架构一致性: ✅ 90%
- 数据一致性: ⚠️  75%
- API一致性: ✅ 95%

**综合评分: 89%**

**下一步:**
1. 📝 查看完整报告：已生成 SPEC-AUDIT-REPORT.md
2. 🔧 修复问题：使用 /architect 修正SPEC
3. 💻 完善实现：使用 /programmer 补充代码

**建议优先处理:**
1. 补充缺失的验收标准
2. 实现未完成的需求
3. 添加缺失的数据库索引
```

---

## 与其他命令的协作

```
/spec-audit
    ↓ (发现问题和差距)
/architect
    ↓ (修正SPEC)
/programmer
    ↓ (补充实现)
/spec-audit (再次审查，验证改进)
```

---

## 审查标准

### 通过标准（所有✅）

- 格式完整性 = 100%
- 需求完整性 ≥ 90%
- 架构一致性 ≥ 90%
- 数据一致性 ≥ 90%
- API一致性 ≥ 90%

### 优秀标准

- 所有维度 ≥ 95%
- 无任何警告或失败项
- 所有需求都已实现

---

## 核心原则

**cc-spec-lite 精简版**

- ✅ 只审查需求完整性
- ✅ 只检查代码与SPEC一致性
- ❌ 不管测试覆盖率
- ❌ 不管代码质量
- ❌ 不管交付标准

测试、质量、交付相关功能请使用完整版 cc-spec。
