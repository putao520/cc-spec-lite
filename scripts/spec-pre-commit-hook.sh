#!/bin/bash

# spec-pre-commit-hook.sh
# SPEC一致性验证 Pre-Commit 钩子
#
# 安装方法:
#   ln -sf ~/.claude/scripts/spec-pre-commit-hook.sh /path/to/project/.git/hooks/pre-commit
#
# 功能:
#   1. 检查敏感文件是否被提交
#   2. 检查代码变更是否关联SPEC ID
#   3. 验证SPEC文件格式完整性

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
SPEC_DIR="SPEC"
SPEC_ID_PATTERN='(REQ|ARCH|DATA|API)-[A-Z0-9]+-[0-9]+'
CODE_EXTENSIONS='\.go$|\.ts$|\.tsx$|\.js$|\.jsx$|\.py$|\.rs$|\.java$|\.kt$'
SENSITIVE_PATTERNS='\.env$|credentials|secret|password|\.pem$|\.key$'

# 统计
WARNINGS=0
ERRORS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  SPEC Pre-Commit Validation${NC}"
echo -e "${BLUE}========================================${NC}"

# ============================================================
# 检查1: 敏感文件检测
# ============================================================
check_sensitive_files() {
    echo -e "\n${BLUE}[1/3] 检查敏感文件...${NC}"

    local sensitive_files=$(git diff --cached --name-only | grep -iE "$SENSITIVE_PATTERNS" || true)

    if [ -n "$sensitive_files" ]; then
        echo -e "${RED}❌ 检测到敏感文件:${NC}"
        echo "$sensitive_files" | while read -r file; do
            echo -e "   ${RED}• $file${NC}"
        done
        echo -e "${YELLOW}   提示: 使用 git reset HEAD <file> 移除敏感文件${NC}"
        ((ERRORS++))
        return 1
    fi

    echo -e "${GREEN}✓ 无敏感文件${NC}"
    return 0
}

# ============================================================
# 检查2: 代码变更SPEC关联
# ============================================================
check_code_spec_association() {
    echo -e "\n${BLUE}[2/3] 检查代码变更SPEC关联...${NC}"

    local code_files=$(git diff --cached --name-only | grep -E "$CODE_EXTENSIONS" || true)

    if [ -z "$code_files" ]; then
        echo -e "${GREEN}✓ 无代码文件变更${NC}"
        return 0
    fi

    local untracked_files=""
    local tracked_count=0
    local untracked_count=0

    for file in $code_files; do
        # 跳过测试文件
        if echo "$file" | grep -qE '_test\.go$|\.test\.(ts|js)$|\.spec\.(ts|js)$|test_.*\.py$'; then
            continue
        fi

        # 检查文件内容是否包含SPEC ID引用
        local file_content=$(git diff --cached "$file" | grep '^+' | grep -v '^+++' || true)

        if echo "$file_content" | grep -qE "$SPEC_ID_PATTERN"; then
            ((tracked_count++))
        else
            untracked_files="$untracked_files\n   • $file"
            ((untracked_count++))
        fi
    done

    if [ $untracked_count -gt 0 ]; then
        echo -e "${YELLOW}⚠ 以下代码变更未在代码中引用SPEC ID:${NC}"
        echo -e "$untracked_files"
        echo -e "${YELLOW}   提示: 在注释中添加 // REQ-XXX 或 // ARCH-XXX 关联${NC}"
        echo -e "${YELLOW}   或在commit message中包含 [REQ-XXX]${NC}"
        ((WARNINGS++))
    fi

    if [ $tracked_count -gt 0 ]; then
        echo -e "${GREEN}✓ $tracked_count 个文件已关联SPEC ID${NC}"
    fi

    return 0
}

# ============================================================
# 检查3: SPEC文件格式验证
# ============================================================
check_spec_format() {
    echo -e "\n${BLUE}[3/3] 验证SPEC文件格式...${NC}"

    local spec_files=$(git diff --cached --name-only | grep -E "^$SPEC_DIR/.*\.md$" || true)

    if [ -z "$spec_files" ]; then
        echo -e "${GREEN}✓ 无SPEC文件变更${NC}"
        return 0
    fi

    local format_errors=0

    for spec_file in $spec_files; do
        # 跳过不存在的文件（可能是删除操作）
        if [ ! -f "$spec_file" ]; then
            continue
        fi

        local filename=$(basename "$spec_file")

        # 检查01-REQUIREMENTS.md格式
        if [ "$filename" = "01-REQUIREMENTS.md" ]; then
            if ! grep -q "^## " "$spec_file"; then
                echo -e "${RED}❌ $spec_file: 缺少章节标题 (## )${NC}"
                ((format_errors++))
            fi
            if ! grep -qE "^REQ-[A-Z]+-[0-9]+" "$spec_file"; then
                echo -e "${YELLOW}⚠ $spec_file: 未检测到REQ-XXX-NNN格式的需求ID${NC}"
                ((WARNINGS++))
            fi
        fi

        # 检查02-ARCHITECTURE.md格式
        if [ "$filename" = "02-ARCHITECTURE.md" ]; then
            if ! grep -q "^## " "$spec_file"; then
                echo -e "${RED}❌ $spec_file: 缺少章节标题 (## )${NC}"
                ((format_errors++))
            fi
        fi

        # 检查03-DATA-STRUCTURE.md格式
        if [ "$filename" = "03-DATA-STRUCTURE.md" ]; then
            if ! grep -qE "^DATA-[A-Z]+-[0-9]+" "$spec_file" && grep -q "表" "$spec_file"; then
                echo -e "${YELLOW}⚠ $spec_file: 建议为数据表定义添加DATA-XXX-NNN ID${NC}"
                ((WARNINGS++))
            fi
        fi

        # 检查04-API-DESIGN.md格式
        if [ "$filename" = "04-API-DESIGN.md" ]; then
            if ! grep -qE "^API-[A-Z]+-[0-9]+" "$spec_file" && grep -qE "(GET|POST|PUT|DELETE|PATCH)" "$spec_file"; then
                echo -e "${YELLOW}⚠ $spec_file: 建议为API端点添加API-XXX-NNN ID${NC}"
                ((WARNINGS++))
            fi
        fi

        # 通用检查：禁止TODO/FIXME在SPEC中
        if grep -qE "TODO|FIXME|TBD|待定|待补充" "$spec_file"; then
            echo -e "${YELLOW}⚠ $spec_file: 包含未完成标记 (TODO/FIXME/TBD)${NC}"
            ((WARNINGS++))
        fi
    done

    if [ $format_errors -gt 0 ]; then
        ((ERRORS++))
        return 1
    fi

    echo -e "${GREEN}✓ SPEC文件格式检查通过${NC}"
    return 0
}

# ============================================================
# 检查4: Commit Message预检（可选）
# ============================================================
check_commit_message_hint() {
    echo -e "\n${BLUE}[提示] Commit Message规范:${NC}"
    echo -e "   格式: <type>(<scope>): <description> [REQ-XXX]"
    echo -e "   示例: feat(auth): 实现JWT验证 [REQ-AUTH-001]"
    echo -e "   ${YELLOW}请使用 commit-and-close.sh 脚本提交以确保规范${NC}"
}

# ============================================================
# 主流程
# ============================================================
main() {
    # 检查是否在git仓库中
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}错误: 不在git仓库中${NC}"
        exit 1
    fi

    # 检查是否有staged changes
    if git diff --cached --quiet; then
        echo -e "${YELLOW}没有staged changes，跳过检查${NC}"
        exit 0
    fi

    # 执行检查
    check_sensitive_files || true
    check_code_spec_association || true
    check_spec_format || true
    check_commit_message_hint

    # 输出总结
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}  验证结果${NC}"
    echo -e "${BLUE}========================================${NC}"

    if [ $ERRORS -gt 0 ]; then
        echo -e "${RED}❌ 错误: $ERRORS | 警告: $WARNINGS${NC}"
        echo -e "${RED}提交被阻止，请修复上述错误${NC}"
        echo -e "\n${YELLOW}如需强制提交（不推荐），使用: git commit --no-verify${NC}"
        exit 1
    elif [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ 警告: $WARNINGS${NC}"
        echo -e "${GREEN}允许提交，但建议修复上述警告${NC}"
        exit 0
    else
        echo -e "${GREEN}✓ 所有检查通过${NC}"
        exit 0
    fi
}

# 运行主流程
main "$@"
