# 功能需求 - cc-spec-lite

**Version**: 1.0.0
**Last Updated**: 2025-12-29

---

## 核心功能需求

### REQ-CORE-001: SPEC 格式定义和管理
**优先级**: P0
**状态**: 已完成

- [x] 定义标准 SPEC 格式（01-06 核心文件）
- [x] 支持 REQ/ARCH/DATA/API/UI-ID 分配
- [x] Git hooks 集成（自动检查 SPEC 引用）
- [x] `spec` CLI 工具实现

**验收标准**:
- ✅ SPEC 文件包含 6 个核心文档
- ✅ ID 格式唯一性验证
- ✅ Git hooks 自动安装和执行

### REQ-CORE-002: 双语支持（i18n）
**优先级**: P0
**状态**: 进行中

- [x] 文档双语结构（zh/ 和 en/）
- [x] 安装脚本语言选择
- [ ] CLI 输出双语支持
- [ ] 技能文件双语维护铁律

**验收标准**:
- ✅ zh/ 和 en/ 文件完全对应
- ✅ 安装时语言选择功能
- ⏳ CLI 输出根据系统语言切换
- ⏳ 每次更新中文必须同步英文

### REQ-CORE-003: 命令系统
**优先级**: P1
**状态**: 部分完成

**已实现命令**:
- [x] `/spec-init` - 交互式 SPEC 初始化
- [x] `/spec-audit` - SPEC 完整性审计
- [x] `/spec-migrator` - 旧格式迁移

**待实现命令**:
- [x] `/spec` - SPEC 需求描述态（主动进入 SPEC 完善 → 触发程序员执行）
- [ ] `spec status` - 显示状态概览
- [ ] `spec validate` - 验证 SPEC 格式
- [ ] `spec install` - 安装 Git hooks

**验收标准**:
- ✅ 现有命令功能完整
- ⏳ 所有命令在 CLI 工具中实现
- ⏳ 命令输出支持双语

---

## 工具需求

### REQ-TOOL-001: spec CLI 工具
**优先级**: P0
**状态**: 已完成基础功能

- [x] `spec init` - 初始化 SPEC 目录
- [x] `spec new` - 创建新 SPEC 条目
- [x] `spec validate` - 验证 SPEC 格式
- [x] `spec status` - 显示状态概览
- [x] Git hooks 自动集成

**验收标准**:
- ✅ 所有命令正常工作
- ✅ 错误提示清晰
- ⏳ 双语输出

### REQ-TOOL-002: 安装脚本
**优先级**: P0
**状态**: 已完成

- [x] 语言选择（zh/en）
- [x] 文件复制到 `~/.claude/`
- [x] 权限设置（644）
- [x] Git hooks 安装

**验收标准**:
- ✅ 安装流程顺畅
- ✅ 支持重新安装

### REQ-CONFIG-001: AI CLI 优先级配置系统
**优先级**: P0
**状态**: ✅ 已实现 (2025-12-30) [commit: 316bbd7] [Issue: #1]

- [x] 配置文件模板设计
- [x] 安装时交互式配置界面
- [x] 供应商动态读取（~/.aiw/providers.json）
- [x] 配置文件生成（~/.claude/config/aiw-priority.yaml）
- [x] ai-cli-runner.sh 配置读取

**功能描述**:
- 安装时引导用户选择 AI CLI 优先级顺序
- 为每个 CLI 配置供应商（从 ~/.aiw/providers.json 动态读取）
- 生成配置文件到 ~/.claude/config/aiw-priority.yaml
- 脚本读取配置并按优先级依次尝试

**验收标准**:
- ✅ 安装时英文交互式界面（两步选择）
- ✅ 动态读取可用供应商列表
- ✅ 配置文件正确生成
- ✅ 脚本支持配置读取和 fallback
- ✅ 默认配置：codex+auto → gemini+auto → claude+official

---

## 维护需求

### REQ-MAINT-001: 文档同步
**优先级**: P0
**状态**: 进行中

- [x] 初始双语翻译（21 个文件）
- [ ] 建立同步检查机制
- [ ] CI 自动检查双语一致性

**验收标准**:
- ✅ zh/ 和 en/ 文件 1:1 对应
- ⏳ 自动检测遗漏翻译
- ⏳ 提交前双语验证

### REQ-MAINT-002: 版本管理
**优先级**: P1
**状态**: 待实现

- [ ] VERSION 文件管理
- [ ] Changelog 自动生成
- [ ] 发布流程自动化

---

## 待讨论需求

### REQ-FUTURE-001: Web UI
**优先级**: P2
**状态**: 待讨论

- SPEC 可视化编辑器
- 需求追踪看板
- 版本对比

### REQ-FUTURE-002: 插件系统
**优先级**: P2
**状态**: 待讨论

- 自定义命令扩展
- 第三方技能集成
- 模板市场
