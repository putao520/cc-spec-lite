---
description: SPEC审查 - 验证SPEC完整性和代码一致性
argument-hint: [审查范围(全部/REQ-XXX)]
---

# SPEC审查命令

## 核心职责

**SPEC审查的薄入口，检测项目状态并调用 /spec-review 技能**

- ❌ **不做**具体的审查逻辑
- ❌ **不做**代码分析
- ✅ **只做**项目状态检测
- ✅ **只做**收集审查参数
- ✅ **只做**调用 /spec-review 技能

---

## 执行流程

### 阶段0：项目状态检测（自动）

```bash
echo "=== SPEC 审查启动 ==="

# 1. 检查 SPEC/ 目录
if [ ! -d "SPEC" ]; then
    echo "❌ SPEC/ 目录不存在"
    echo "请先运行 /spec-init 初始化SPEC"
    exit 1
fi

# 2. 检查 spec 命令是否可用
if ! command -v spec &> /dev/null; then
    echo "⚠️  spec CLI 未安装"
    echo "尝试使用内置审查逻辑..."
fi

# 3. 统计SPEC文件
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

### 阶段1：收集审查参数

**如果用户提供了参数**：
```bash
# 示例：/spec-audit REQ-AUTH-001
SCOPE="$1"  # REQ-AUTH-001
```

**如果用户没有提供参数**：
```bash
# 默认：全面审查
SCOPE="full"
```

---

### 阶段2：调用 /spec-review 技能

**传递给技能的参数**：
```markdown
# SPEC审查请求

**审查范围**: $SCOPE
**项目路径**: $(pwd)
**SPEC统计**:
- 需求: $req_count 个
- 架构: $arch_count 个
- 数据: $data_count 个
- 接口: $api_count 个

**审查维度**:
1. ✅ 格式完整性
2. ✅ 需求完整性（验收标准）
3. ✅ 架构一致性
4. ✅ 数据模型一致性
5. ✅ API接口一致性
6. ✅ CLAUDE.md 合规性
7. ✅ 产品级契约文件审查
8. ✅ 测试用例质量审查

请执行完整审查并生成报告。
```

---

### 阶段3：展示审查结果

**接收 /spec-review 技能的输出**：
```markdown
✅ SPEC 审查完成！

**审查结果:**
- 格式完整性: ✅ 100%
- 需求完整性: ⚠️ 85%
- 架构一致性: ✅ 90%
- 数据一致性: ⚠️ 75%
- API一致性: ✅ 95%
- CLAUDE.md合规性: ✅ 100%
- 契约文件一致性: ⚠️ 80%
- 测试用例覆盖: ⚠️ 60%

**综合评分: 85%**

**详细报告:** 已生成 /tmp/claude-reports/SPEC-AUDIT-REPORT.md

**下一步:**
1. 🔧 修复问题：使用 /architect 修正SPEC
2. 💻 完善实现：使用 /programmer 补充代码
3. 🧋 重新审查：再次使用 /spec-audit
```

---

## 完成提示

```markdown
✅ SPEC 审查完成！

**审查维度:**
- ✅ 格式完整性
- ✅ 需求完整性
- ✅ 架构一致性
- ✅ 数据一致性
- ✅ API一致性
- ✅ CLAUDE.md合规性
- ✅ 产品级契约文件审查
- ✅ 测试用例质量审查

**下一步:**
1. 📝 查看完整报告
2. 🔧 使用 /architect 修正SPEC
3. 💻 使用 /programmer 补充代码
```

---

## 与技能的协作

```
/spec-audit (命令)
    ↓ (检测项目状态)
    ↓ (收集审查参数)
    ↓
/spec-review (技能)
    ↓ (执行核心审查逻辑)
    ↓ (生成详细报告)
    ↓
返回给 /spec-audit (展示结果)
```

---

## 禁止操作

- ❌ **禁止实现具体的审查逻辑** - 交给 /spec-review 技能
- ❌ **禁止重复代码** - 所有审查都在技能中
- ❌ **禁止生成报告** - 报告由技能生成
- ✅ **只做薄入口** - 检测状态 + 调用技能 + 展示结果

---

## 核心原则

**spec-audit = 薄入口层**

- 检测项目状态
- 收集审查参数
- 调用 /spec-review 技能
- 展示审查结果

所有具体的审查逻辑都在 /spec-review 技能中实现。
