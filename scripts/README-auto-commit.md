# 自动提交流程说明

## 概述

这套自动化系统实现了从代码验证到提交的完整闭环流程，确保开发完成后能够自动执行：

1. 代码提交
2. GitHub Issue关闭
3. SPEC状态更新
4. 版本号升级
5. Git标签创建

## 跨平台支持

所有脚本都提供 Bash 和 PowerShell 两个版本：

| Bash (Linux/macOS/Git Bash) | PowerShell (Windows) |
|-----------------------------|----------------------|
| `commit-and-close.sh` | `commit-and-close.ps1` |
| `update-spec-status.sh` | `update-spec-status.ps1` |
| `ai-cli-runner.sh` | `ai-cli-runner.ps1` |
| `spec-pre-commit-hook.sh` | `spec-pre-commit-hook.ps1` |

## 核心组件

### 1. commit-and-close.sh / .ps1 (主脚本)

**位置**: `~/.claude/scripts/commit-and-close.sh` (或 `.ps1`)

**功能**:
- 执行Git提交
- 自动检测或使用指定的Issue号
- 关闭GitHub Issue
- 解析需求ID
- 自动调用SPEC状态更新脚本

**新特性**:
- **智能Issue检测**: 如果没有提供Issue号，会自动从多个源检测：
  - 最近的GitHub Issue
  - 当前分支名（如 `issue-123`）
  - 最近的commit信息

### 2. update-spec-status.sh / .ps1 (SPEC更新脚本)

**位置**: `~/.claude/scripts/update-spec-status.sh` (或 `.ps1`)

**功能**:
- 自动更新SPEC文件中的需求状态
- 自动升级版本号
- 自动创建Git标签

**版本升级规则**:
- 新功能 (REQ-XXX): minor版本 +1
- Bug修复: patch版本 +1
- 架构变更: major版本 +1

## 使用方式

### 基本用法 (Bash)

```bash
# 基本用法（手动指定Issue）
~/.claude/scripts/commit-and-close.sh \
  --message "feat: 实现用户认证 [REQ-AUTH-001]" \
  --issue 123

# 智能用法（自动检测Issue）
~/.claude/scripts/commit-and-close.sh \
  --message "feat: 实现用户认证 [REQ-AUTH-001]"
```

### 基本用法 (PowerShell)

```powershell
# 基本用法（手动指定Issue）
~\.claude\scripts\commit-and-close.ps1 `
  -Message "feat: implement user auth [REQ-AUTH-001]" `
  -Issue 123

# 智能用法（自动检测Issue）
~\.claude\scripts\commit-and-close.ps1 `
  -Message "feat: implement user auth [REQ-AUTH-001]"
```

### 支持的参数

| 参数 | 必需 | 说明 |
|------|------|------|
| `--message` 或 `-m` | ✅ | 提交信息（必须包含需求ID，如 `[REQ-AUTH-001]`） |
| `--issue` 或 `-i` | ❌ | GitHub Issue编号（可自动检测） |

### 需求ID格式

脚本支持以下需求ID格式：
- `REQ-*`: 功能需求
- `ARCH-*`: 架构需求
- `DATA-*`: 数据结构需求
- `API-*`: API设计需求

## 工作流程

### 自动提交流程

1. **开发验证**: programmer技能验证代码通过
2. **触发提交**: 自动调用 `commit-and-close.sh`
3. **Git提交**: 执行 `git commit`
4. **Issue处理**: 自动关闭相关GitHub Issue
5. **需求解析**: 从提交信息中提取需求ID
6. **SPEC更新**: 调用 `update-spec-status.sh`
7. **状态更新**: 将需求标记为已完成
8. **版本升级**: 根据功能类型升级版本号
9. **标签创建**: 创建对应的Git标签
10. **完成报告**: 向主会话报告完成结果

### SPEC状态更新详情

脚本会在SPEC文件中查找对应的需求ID，并将其状态从：

```markdown
- [ ] REQ-AUTH-001: 用户登录功能
```

更新为：

```markdown
- [x] REQ-AUTH-001: 用户登录功能 - ✅ 已完成 (2024-XX-XX) [commit: abc123] [Issue: #123]
```

## 错误处理

### 常见错误及解决方案

1. **GitHub认证失败**
   ```
   ⚠️  无法关闭 Issue (可能需要 gh auth login 或 Issue 不存在)
   ```
   **解决**: 运行 `gh auth login` 进行GitHub CLI认证

2. **无法检测Issue号**
   ```
   ⚠️  无法自动检测Issue号，将跳过Issue关闭
   ```
   **解决**: 手动指定 `--issue` 参数

3. **SPEC文件不存在**
   ```
   错误: 当前目录未找到SPEC文件夹
   ```
   **解决**: 确保在正确的项目根目录执行

4. **版本格式错误**
   ```
   ⚠️  版本格式不正确: xxx
   ```
   **解决**: 确保 `SPEC/VERSION` 文件格式为 `v{major}.{minor}.{patch}`

## 技能集成

### programmer技能集成

programmer技能的步骤8已完全自动化：

1. **验证通过**: 代码审查通过
2. **自动执行**: 调用增强版 `commit-and-close.sh`
3. **结果报告**: 返回完成状态给主会话

### 主会话职责变更

主会话不再需要：
- ❌ 检测"代码审查通过"触发词
- ❌ 手动执行提交脚本
- ❌ 更新SPEC状态

主会话现在只需要：
- ✅ 接收programmer的完成报告
- ✅ 记录状态，无需额外操作

## 高级配置

### 自定义版本升级规则

可以修改 `update-spec-status.sh` 中的 `update_version()` 函数来自定义版本升级逻辑。

### 扩展需求ID类型

在 `update-spec-status.sh` 的 `case $req_id in` 语句中添加新的需求ID类型支持。

### 集成其他工具

可以在脚本中集成：
- CI/CD流水线触发
- 通知服务（Slack、邮件等）
- 代码质量检查工具

## 故障排除

### 调试模式

设置环境变量启用调试输出：

```bash
export DEBUG=1
~/.claude/scripts/commit-and-close.sh -m "test message" -i 123
```

### 手动回滚

如果自动提交出现问题，可以手动回滚：

```bash
# 回滚最后一次提交
git reset --hard HEAD~1

# 删除不需要的标签
git tag -d v1.1.0

# 手动恢复SPEC状态
# 编辑SPEC文件，将 [x] 改回 [ ]
```