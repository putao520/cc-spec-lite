#!/bin/bash
# ai-cli-runner.sh - AI CLI工具执行器
# 为AI CLI工具提供标准化的注入文本并直接执行，确保代码实现一致性

set -euo pipefail

SCRIPT_NAME="ai-cli-runner"
SCRIPT_VERSION="3.0.0"

# 显示使用说明
show_usage() {
    cat <<EOF
AI CLI Runner - AI CLI工具执行器 (极简版)

用法: $SCRIPT_NAME <task_type> <spec_ids> <task_description> [task_context] [ai_tool] [provider]

Arguments:
  task_type          任务类型 (frontend, database, big-data, game, blockchain, ml, embedded, graphics, multimedia, iot, deployment, devops)
  spec_ids           关联的SPEC ID，多个用逗号分隔 (如: REQ-AUTH-001,ARCH-AUTH-001,API-AUTH-001)
  task_description   任务描述
  task_context       (可选) 任务清单和背景信息
  ai_tool            (可选) AI代理选择器，默认: codex (可选: claude, codex, gemini, all, "agent1|agent2")
  provider           (可选) AI供应商，默认: auto (自动选择最佳路由，可选: glm, openrouter, anthropic)

Examples:
  # 单个需求ID (使用默认codex)
  $SCRIPT_NAME "frontend" "REQ-UI-005" "create React dashboard component"

  # 多个关联ID（需求+架构+API）使用指定AI
  $SCRIPT_NAME "backend" "REQ-AUTH-001,ARCH-AUTH-001,API-AUTH-001,API-AUTH-002" "implement JWT authentication" "" "claude"

  # 完整示例使用Gemini
  $SCRIPT_NAME "database" "REQ-USER-001,DATA-USER-001" "implement user data model and migrations" "" "gemini"

Task Types:
  frontend, database/db, big-data/bigdata, game/gaming, blockchain/web3,
  ml/ai/machine-learning, embedded/mcu, graphics/rendering, multimedia/audio/video,
  iot/sensor, deployment, debugger

AI Tools: claude, codex, gemini, all, "agent1|agent2" (默认: codex)
Providers: auto, glm, openrouter, anthropic, google 等 (默认: auto，自动选择最佳路由)

EOF
}

# 主要执行功能 - 合并标准生成和AI CLI执行
execute() {
    local task_type="$1"
    local spec_ids="$2"
    local task_description="$3"
    local task_context="${4:-}"  # 可选参数：任务背景信息
    local ai_tool="${5:-codex}"  # 可选参数：AI代理选择器，默认codex
    local provider="${6:-auto}"  # 可选参数：AI供应商，默认auto（自动选择最佳路由）

    echo "=== AI CLI Runner 执行任务 ==="
    echo "任务类型: $task_type"
    echo "关联SPEC ID: $spec_ids"
    echo "AI工具: $ai_tool"
    echo "AI供应商: $provider"
    echo "任务描述: $task_description"
    if [ -n "$task_context" ]; then
        echo "包含任务背景: 是"
    fi
    echo "执行时间: $(date)"
    echo ""

    # 生成注入文本到临时文件
    local injection_file=$(mktemp)
    echo "生成注入文本..."
    generate_injection "$task_type" "$spec_ids" "$task_context" > "$injection_file"

    echo "=== AI CLI注入文本 ==="
    cat "$injection_file"
    echo ""

    echo "=== 执行AI CLI命令 ==="
    # 执行AI CLI命令，注入标准文本
    # 始终使用 -p 参数传递供应商给 aiw
    aiw "$ai_tool" -p "$provider" "$task_description

$(cat "$injection_file")"

    local exit_code=$?

    # 清理临时文件
    rm -f "$injection_file"

    if [ $exit_code -eq 0 ]; then
        echo "✅ AI CLI任务执行完成"
    else
        echo "❌ AI CLI任务执行失败 (退出码: $exit_code)"
    fi

    return $exit_code
}

# 生成标准AI CLI注入文本
generate_injection() {
    local task_type="$1"
    local spec_ids="$2"
    local task_context="${3:-}"  # 可选参数：任务背景信息

    echo "=== AI CLI标准注入文本 ==="
    echo "任务类型: $task_type"
    echo "关联SPEC ID: $spec_ids"
    echo "生成时间: $(date)"
    echo ""

    # 根据是否有 SPEC ID 生成不同的注入文本
    if [ -n "$spec_ids" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════════════
  AI CLI 编码执行标准 - SPEC 严格遵循模式
═══════════════════════════════════════════════════════════

🚨【CRITICAL：SPEC 是唯一真源 SSOT，绝对权威无例外】🚨

⚠️ 重要提醒：
1. 任务描述可能不完整，SPEC 才是唯一真实需求来源
2. SPEC > 任务描述 > AI理解 > 用户口头要求
3. 任何与 SPEC 冲突的理解都必须以 SPEC 为准
4. 发现 SPEC 矛盾或缺失必须立即停止，报告澄清

🔴【强制执行流程 - 违反即失败】🔴

步骤1：🛑 立即停止编码，SPEC 权威性验证
- 完整读取 SPEC 目录下所有相关文档
- 找到每个 SPEC ID（REQ-XXX、ARCH-XXX、DATA-XXX、API-XXX）的详细要求
- 验证 SPEC 的功能、性能、约束、验收标准
- 确认任务描述与 SPEC 一致性，冲突时以 SPEC 为准

步骤2：✅ SPEC 完整性验证
- 确认每个 SPEC ID 的具体要求和约束条件
- 识别技术栈、架构模式、数据结构、接口规范
- 检查 SPEC 是否存在矛盾、缺失或歧义
- 发现问题必须停止，等待澄清，不允许自行决定

步骤3：🔄 融合原则执行（基于 SPEC 权威）

3a. SPEC 指导的深度分析：
- 全面扫描现有模块：通用模块、基础设施、领域模块、平台特定模块
- 基于 SPEC 要求精确评估匹配度：完全匹配、部分匹配、不匹配
- SPEC 功能完整性验证：现有实现是否满足 SPEC 的所有要求
- 智能复用决策：完全匹配符合 SPEC → 直接复用；否则销毁重建

3b. SPEC 驱动的彻底重写：
- 删除所有违反 SPEC 的旧代码，从零实现符合 SPEC 的新方案
- 禁止任何渐进式开发：增量添加、兼容代码、迁移改造
- 每个 SPEC ID 必须有明确的、完全符合 SPEC 的实现

3c. SPEC 绝对服从：
- 禁止任何形式的"我觉得这样更好"的偏离 SPEC 行为
- 禁止简化、扩展、选择性遵守 SPEC 要求
- 代码与 SPEC 冲突时，改代码不改 SPEC

步骤4：🔍 SPEC 对照验证
- 逐条检查你的实现是否完全符合 SPEC
- 每个 SPEC 对应的功能都必须 100% 实现
- 无 TODO、FIXME、stub 等占位符

步骤5：🔄 SPEC 对齐更新（代码完成后必做）
- 检查 SPEC 文档中的状态字段，将对应 REQ-XXX/ARCH-XXX 的状态更新为"已完成"
- 如果实现过程中发现 SPEC 有遗漏或不准确，主动更新 SPEC 内容
- 确保 SPEC 和代码的一致性：代码改了，SPEC 也要同步更新
- 记录实现过程中的重要决策到 SPEC/DOCS/ 中（如有架构决策）
- 验证 SPEC 版本号是否需要递增

🚫【绝对禁止的行为 - 任务失败标志】🚫

❌ 不读 SPEC 就开始编码
❌ 认为任务描述比 SPEC 更准确
❌ "我觉得用 X 比 Y 更好"而偏离 SPEC
❌ "SPEC 太复杂，我简化一下"
❌ "SPEC 没说，但我觉得应该加"
❌ 只实现部分 SPEC 要求
❌ 使用 SPEC 中没有规定的技术栈
❌ **代码完成后不更新 SPEC 状态（导致 SPEC 过期失效）**
❌ **发现 SPEC 错误不主动修正（放任 SPEC 与代码不一致）**

✅【必须做到的标准 - 成功标志】✅

✅ 编码前必须完整阅读相关 SPEC 文档
✅ 理解每个 SPEC ID 的具体要求和约束
✅ 代码实现与 SPEC 100% 一致
✅ 每个 SPEC 要求都有明确的代码对应
✅ 发现 SPEC 问题及时报告而不是自行决定
✅ **代码完成后主动更新 SPEC 状态和内容，确保 SPEC 与代码一致**

【核心理念】
- SPEC 是问题的唯一真源 (SSOT)
- 你的理解可能有误，但 SPEC 不会错
- 任务描述只是线索，SPEC 才是真相
- 宁可延迟实现，也不要实现错误的方案

记住：收到这个提示后，你的第一件事应该是去读 SPEC，而不是开始写代码！
EOF
    else
        cat <<'EOF'
═══════════════════════════════════════════════════════════
  AI CLI 编码执行标准 - 通用任务模式
═══════════════════════════════════════════════════════════

🔧【任务类型：无 SPEC ID 的通用任务】
适用场景：Bug 修复、小改动、技术债、重构等

🔴【执行要求】🔴

步骤1：📋 分析任务背景
- 理解任务描述和要解决的具体问题
- 查看相关的代码和文档
- 识别影响范围和依赖关系

步骤2：🔍 检查现有实现
- 分析相关代码的当前状态
- 查找问题的根本原因
- 理解现有的架构和设计模式

步骤3：🛠️ 融合原则实施（通用任务模式）

3a. 深度分析（复用评估）：
- 扫描相关代码区域，寻找完全匹配的现有实现
- 评估解决方案是否满足功能、性能、约束要求
- 识别需要销毁重建的部分（部分匹配或不匹配）

3b. 执行策略（通用软件开发）：
- **可复用**：现有实现完全满足要求，直接使用
- **需重建**：现有实现不满足要求，删除后从零实现
- **禁止**：渐进式修改、兼容性代码、增量扩展、保留旧逻辑

3c. 修复实施：
- 针对具体问题类型采用最佳实践
- 保持与现有代码架构和风格一致
- 确保修复不会引入新问题或技术债务

步骤4：✅ 验证
- 验证修复是否解决了原问题
- 检查是否影响其他功能
- 确保代码质量和可维护性

🚫【禁止行为】🚫

❌ 不理解问题就盲目修改代码
❌ 破坏现有架构和设计模式
❌ 引入不必要的复杂性
❌ 留下 TODO 或 FIXME 占位符

✅【质量要求】✅

✅ 完整理解问题再动手修改
✅ 保持代码风格和架构一致性
✅ 彻底解决问题，不留后遗症
✅ 编写清晰的注释说明修改原因
✅ 考虑边界情况和异常处理

💡【最佳实践】
- 先读懂现有代码，再做修改
- 优先选择最简单有效的解决方案
- 保持代码的可读性和可维护性
- 修改后确保没有破坏现有功能

记住：对于 Bug 修复，理解问题比快速修改更重要！
EOF
    fi

    # 注入融合原则（所有任务类型都需要）
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  智能复用与销毁重建原则 - AI开发核心方法论"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "🎯 核心理念：深度复用，彻底重写（通用软件开发）"
    echo ""
    echo "🔶 SPEC绝对权威（SSOT原则）："
    echo "- SPEC是唯一真实需求来源，所有决策必须以SPEC为准"
    echo "- SPEC > 任务描述 > AI理解 > 用户口头要求"
    echo "- 发现SPEC矛盾或缺失必须立即停止，报告澄清"
    echo ""
    echo "📋 第一阶段：SPEC指导的深度分析（复用决策）"
    echo "- 全面扫描现有模块：通用模块、基础设施、领域模块、平台特定模块"
    echo "- 基于SPEC要求精确评估匹配度：完全匹配、部分匹配、不匹配"
    echo "- SPEC功能完整性验证：现有实现是否满足SPEC的所有要求"
    echo "- 智能复用决策："
    echo "  ✅ 完全匹配符合SPEC → 直接复用，无需开发"
    echo "  ❌ 部分匹配/不匹配违反SPEC → 执行销毁重建"
    echo ""
    echo "🔥 第二阶段：SPEC驱动的彻底重写（销毁重建）"
    echo "- 删除所有违反SPEC的旧代码"
    echo "- 从零设计完全符合SPEC的新实现"
    echo "- 禁止渐进式开发行为："
    echo "  ❌ 保留旧实现，添加新功能（违反SPEC完整性）"
    echo "  ❌ 兼容性代码，支持旧接口（违反SPEC约束）"
    echo "  ❌ 迁移代码，逐步转换（引入技术债务）"
    echo "  ❌ 扩展现有实现，添加功能（偏离SPEC要求）"
    echo "  ❌ 修改现有代码，增加参数（破坏SPEC设计）"
    echo ""
    echo "💡 融合原则关键："
    echo "- 复用基于SPEC功能完整性，不是代码相似性"
    echo "- 部分匹配等于不匹配，必须销毁重建"
    echo "- 严禁任何偏离SPEC的渐进式思维"
    echo "- 每个SPEC ID必须有明确的、完全符合SPEC的实现"
    echo ""

    # 注入通用编程规范（所有任务类型都需要）
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  通用编程规范 - common.md"
    echo "═══════════════════════════════════════════════════════════"
    echo ""

    local common_standards="$HOME/.claude/roles/common.md"
    if [ -f "$common_standards" ]; then
        cat "$common_standards"
    else
        echo "⚠️  警告：未找到通用编程规范文件: $common_standards"
    fi

    # 注入领域特定规范（附加规范）
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  领域特定附加规范 - 任务类型: $task_type"
    echo "═══════════════════════════════════════════════════════════"
    echo ""

    case "$task_type" in
        "backend")
            echo "ℹ️  后端开发任务（通用）：使用通用编程规范（无领域特定规范）"
            ;;
        "system"|"os")
            echo "ℹ️  系统编程任务：使用通用编程规范（无领域特定规范）"
            ;;
        "frontend")
            local frontend_standards="$HOME/.claude/roles/frontend-standards.md"
            if [ -f "$frontend_standards" ]; then
                cat "$frontend_standards"
            else
                echo "⚠️  警告：未找到前端编程规范文件: $frontend_standards"
            fi
            ;;
        "database"|"db")
            local database_standards="$HOME/.claude/roles/database-standards.md"
            if [ -f "$database_standards" ]; then
                cat "$database_standards"
            else
                echo "⚠️  警告：未找到数据库编程规范文件: $database_standards"
            fi
            ;;
        "big-data"|"bigdata")
            local bigdata_standards="$HOME/.claude/roles/big-data-standards.md"
            if [ -f "$bigdata_standards" ]; then
                cat "$bigdata_standards"
            else
                echo "⚠️  警告：未找到大数据编程规范文件: $bigdata_standards"
            fi
            ;;
        "game"|"gaming")
            local game_standards="$HOME/.claude/roles/game.md"
            if [ -f "$game_standards" ]; then
                cat "$game_standards"
            else
                echo "⚠️  警告：未找到游戏开发规范文件: $game_standards"
            fi
            ;;
        "blockchain"|"web3")
            local blockchain_standards="$HOME/.claude/roles/blockchain.md"
            if [ -f "$blockchain_standards" ]; then
                cat "$blockchain_standards"
            else
                echo "⚠️  警告：未找到区块链编程规范文件: $blockchain_standards"
            fi
            ;;
        "ml"|"ai"|"machine-learning")
            local ml_standards="$HOME/.claude/roles/ml.md"
            if [ -f "$ml_standards" ]; then
                cat "$ml_standards"
            else
                echo "⚠️  警告：未找到机器学习编程规范文件: $ml_standards"
            fi
            ;;
        "embedded"|"mcu")
            local embedded_standards="$HOME/.claude/roles/embedded.md"
            if [ -f "$embedded_standards" ]; then
                cat "$embedded_standards"
            else
                echo "⚠️  警告：未找到嵌入式编程规范文件: $embedded_standards"
            fi
            ;;
        "graphics"|"rendering")
            local graphics_standards="$HOME/.claude/roles/graphics.md"
            if [ -f "$graphics_standards" ]; then
                cat "$graphics_standards"
            else
                echo "⚠️  警告：未找到图形编程规范文件: $graphics_standards"
            fi
            ;;
        "multimedia"|"audio"|"video")
            local multimedia_standards="$HOME/.claude/roles/multimedia.md"
            if [ -f "$multimedia_standards" ]; then
                cat "$multimedia_standards"
            else
                echo "⚠️  警告：未找到音视频编程规范文件: $multimedia_standards"
            fi
            ;;
        "iot"|"sensor")
            local iot_standards="$HOME/.claude/roles/iot.md"
            if [ -f "$iot_standards" ]; then
                cat "$iot_standards"
            else
                echo "⚠️  警告：未找到物联网编程规范文件: $iot_standards"
            fi
            ;;
        "deployment")
            local deployment_standards="$HOME/.claude/roles/deployment.md"
            if [ -f "$deployment_standards" ]; then
                cat "$deployment_standards"
            else
                echo "⚠️  警告：未找到部署编程规范文件"
                cat <<'EOF'
部署开发要求:
- 容器化配置
- 环境变量管理
- 健康检查机制
- 日志收集配置
- 监控和告警设置
- 自动化部署流程
- 回滚机制
EOF
            fi
            ;;
        "devops")
            local devops_standards="$HOME/.claude/roles/devops.md"
            if [ -f "$devops_standards" ]; then
                cat "$devops_standards"
            else
                echo "⚠️  警告：未找到DevOps编程规范文件"
                cat <<'EOF'
DevOps开发要求:
- CI/CD流水线设计
- 基础设施即代码
- 安全扫描集成
- 监控和日志系统
- 自动化部署
- 性能监控
- 故障恢复机制
EOF
            fi
            ;;
        "debugger")
            local debugger_standards="$HOME/.claude/roles/debugger.md"
            if [ -f "$debugger_standards" ]; then
                cat "$debugger_standards"
            else
                echo "⚠️  警告：未找到调试分析编程规范文件"
                cat <<'EOF'
调试分析要求:
- 数据驱动分析
- 问题重现优先
- 根因分析彻底
- 修复验证完整
- 预防措施到位
- 日志分析技术
EOF
            fi
            ;;
        *)
            # 未知角色仅使用通用规范，无附加规范
            echo "ℹ️  未识别的任务类型 '$task_type'，仅使用通用编码规范"
            ;;
    esac

    # 添加SPEC ID指导信息
    if [ -n "$spec_ids" ]; then
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo "  本次任务关联的 SPEC ID"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "📋 SPEC ID 清单: $spec_ids"
        echo ""
        echo "🔍 你必须在 SPEC 文件中找到这些 ID 对应的具体内容："
        echo "  • REQ-XXX → SPEC/01-REQUIREMENTS.md (功能需求和验收标准)"
        echo "  • ARCH-XXX → SPEC/02-ARCHITECTURE.md (架构决策和技术栈)"
        echo "  • DATA-XXX → SPEC/03-DATA-STRUCTURE.md (数据模型和表结构)"
        echo "  • API-XXX → SPEC/04-API-DESIGN.md (接口规范和错误码)"
        echo ""
        echo "⚠️  重要：编码前必须完整阅读这些 SPEC 文档！"
        echo "🚫 不要依赖任务描述，SPEC 才是真实需求来源！"
        echo ""
        echo "📍 项目信息："
        echo "  当前分支: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
        echo "  SPEC版本: v$(cat SPEC/VERSION 2>/dev/null || echo 'unknown')"
    fi

    # 添加任务背景信息
    if [ -n "$task_context" ]; then
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo "  任务背景和清单"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "以下是任务的背景信息和清单："
        echo ""
        echo "$task_context"
        echo ""
        echo "请基于以上背景执行开发任务，理解整体目标和当前进度。"
    fi
}

# 生成项目上下文
project_context() {
    echo "=== 项目上下文信息 ==="
    echo "生成时间: $(date)"
    echo ""

    # 基本信息
    echo "--- 基本信息 ---"
    echo "项目路径: $(pwd)"
    echo "当前分支: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
    echo "最后提交: $(git log -1 --oneline --date=short 2>/dev/null || echo 'no commits')"
    echo "提交哈希: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')"

    # SPEC信息
    echo ""
    echo "--- SPEC信息 ---"
    if [ -f "SPEC/VERSION" ]; then
        echo "SPEC版本: v$(cat SPEC/VERSION)"
    else
        echo "SPEC版本: 未找到"
    fi

    if [ -d "SPEC" ]; then
        echo "SPEC文件:"
        ls -la SPEC/ | grep -E '\.(md|json|yaml)$' | awk '{print "  " $9}'
    fi

    # 项目结构
    echo ""
    echo "--- 项目结构 ---"
    if [ -f "package.json" ]; then
        echo "Node.js项目: $(jq -r '.name' package.json 2>/dev/null || echo 'unknown')"
        echo "版本: $(jq -r '.version' package.json 2>/dev/null || echo 'unknown')"
    fi

    if [ -f "Cargo.toml" ]; then
        echo "Rust项目: $(grep '^name = ' Cargo.toml | cut -d'"' -f2)"
    fi

    if [ -f "go.mod" ]; then
        echo "Go项目: $(grep '^module ' go.mod | cut -d' ' -f2)"
    fi

    # 环境信息
    echo ""
    echo "--- 环境信息 ---"
    echo "Node.js版本: $(node --version 2>/dev/null || echo '未安装')"
    echo "Python版本: $(python --version 2>/dev/null || python3 --version 2>/dev/null || echo '未安装')"
    echo "Go版本: $(go version 2>/dev/null | cut -d' ' -f3 || echo '未安装')"
    echo "Docker版本: $(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1 || echo '未安装')"
}

# 生成编码标准
coding_standards() {
    echo "=== 编码标准 ==="
    echo "生成时间: $(date)"
    echo ""

    cat <<'EOF'
通用编码标准:

1. 命名规范
   - 变量和函数: camelCase
   - 类和组件: PascalCase
   - 常量: UPPER_SNAKE_CASE
   - 文件名: kebab-case

2. 代码结构
   - 单文件不超过300行
   - 函数不超过50行
   - 嵌套不超过3层
   - 圈复杂度不超过10

3. 注释规范
   - 公共API必须有JSDoc注释
   - 复杂逻辑必须有行内注释
   - TODO格式: TODO(#issue): description

4. 错误处理
   - 所有异步操作必须有错误处理
   - 用户输入必须验证
   - 外部API调用必须有超时和重试

5. 性能规范
   - 避免阻塞主线程
   - 大数据集使用分页或流式处理
   - 适当使用缓存
   - 避免内存泄漏
EOF
}

# 验证实现质量 (占位符实现)
validate_implementation() {
    echo "=== 实现质量验证 ==="
    echo "生成时间: $(date)"
    echo ""

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --component)
                local component="$2"
                echo "验证组件: $component"
                shift 2
                ;;
            *)
                echo "未知参数: $1"
                shift
                ;;
        esac
    done

    echo ""
    echo "✅ 基础验证完成"
    echo "建议执行以下验证:"
    echo "- 语法检查: eslint / tsc / rustc"
    echo "- 安全扫描: npm audit / cargo audit"
}

# 主程序
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi

    if [ $# -lt 3 ]; then
        echo "错误: 至少需要3个参数: <task_type> <spec_ids> <task_description>"
        echo "完整用法: $SCRIPT_NAME <task_type> <spec_ids> <task_description> [task_context] [ai_tool]"
        show_usage
        exit 1
    fi

    # 验证AI工具参数（如果提供）
    if [ $# -ge 5 ]; then
        local ai_tool="$5"
        case "$ai_tool" in
            "claude"|"codex"|"gemini"|"all")
                # 单个有效AI工具
                ;;
            *)
                # 检查是否为多AI工具格式 (如 "claude|gemini")
                if [[ "$ai_tool" == *"|"* ]]; then
                    # 简单验证格式：包含|且不为空
                    local tools="${ai_tool//|/ }"
                    for tool in $tools; do
                        case "$tool" in
                            "claude"|"codex"|"gemini") ;;
                            *)
                                echo "错误: 无效的AI工具 '$tool'，支持的工具有: claude, codex, gemini"
                                exit 1
                                ;;
                        esac
                    done
                else
                    echo "错误: 无效的AI工具 '$ai_tool'，支持的工具有: claude, codex, gemini, all, 或组合格式如 'claude|gemini'"
                    exit 1
                fi
                ;;
        esac
    fi

    # 直接执行AI CLI任务
    execute "$@"
}

# 执行主程序
main "$@"