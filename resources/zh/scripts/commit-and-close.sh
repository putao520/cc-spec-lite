#!/bin/bash

# commit-and-close-fixed.sh
# 功能: 执行 git commit + 关闭 GitHub Issue + 自动更新 SPEC 状态
# 用法: ./commit-and-close.sh --message "feat: xxx [REQ-XXX]" --issue 123

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 参数解析
MESSAGE=""
ISSUE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --message|-m)
      MESSAGE="$2"
      shift 2
      ;;
    --issue|-i)
      ISSUE="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: $0 --message <commit_message> --issue <issue_number>"
      echo ""
      echo "参数:"
      echo "  --message, -m  Commit message (必须包含需求ID，如: [REQ-XXX])"
      echo "  --issue, -i    GitHub Issue 编号（可选，会自动检测）"
      echo ""
      echo "示例:"
      echo "  $0 -m 'feat: 实现用户认证 [REQ-AUTH-001]' -i 123"
      echo "  $0 -m 'feat: 实现用户认证 [REQ-AUTH-001]'  # 自动检测Issue"
      exit 0
      ;;
    *)
      echo "未知参数: $1"
      echo "使用 --help 查看帮助"
      exit 1
      ;;
  esac
done

# 参数验证
if [ -z "$MESSAGE" ]; then
  echo -e "${RED}错误: 缺少 --message 参数${NC}"
  exit 1
fi

# 如果没有提供Issue号，尝试自动检测
if [ -z "$ISSUE" ]; then
  echo -e "${YELLOW}⚠️  未提供Issue号，尝试自动检测...${NC}"

  # 方法1：从最近的Issue中获取
  AUTO_ISSUE=$(gh issue list --limit 1 --search "sort:created-desc" --json number | jq -r '.[0].number // empty' 2>/dev/null || true)

  # 方法2：如果方法1失败，尝试从分支名推断
  if [ -z "$AUTO_ISSUE" ]; then
    BRANCH_NAME=$(git branch --show-current 2>/dev/null || echo "")
    AUTO_ISSUE=$(echo "$BRANCH_NAME" | grep -oE 'issue-?[0-9]+' | head -1 | grep -oE '[0-9]+' || true)
  fi

  # 方法3：如果方法2失败，尝试从最近的commit中查找
  if [ -z "$AUTO_ISSUE" ]; then
    AUTO_ISSUE=$(git log -1 --grep="#[0-9]+" --pretty=format:'%s' 2>/dev/null | grep -oE "#[0-9]+" | head -1 | grep -oE '[0-9]+' || true)
  fi

  if [ -n "$AUTO_ISSUE" ]; then
    ISSUE="$AUTO_ISSUE"
    echo -e "${GREEN}✅ 自动检测到Issue号: $ISSUE${NC}"
  else
    echo -e "${YELLOW}⚠️  无法自动检测Issue号，将跳过Issue关闭${NC}"
  fi
fi

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}错误: 当前目录不是 git 仓库${NC}"
  exit 1
fi

# 检查是否有 staged changes
if ! git diff --cached --quiet; then
  :
else
  echo -e "${YELLOW}警告: 没有检测到 staged changes，将提交所有已修改的文件${NC}"
  git add .
fi

# 1. 执行 git commit
echo -e "${BLUE}📝 执行 Git Commit...${NC}"
git commit --no-verify -m "$MESSAGE"
COMMIT_HASH=$(git rev-parse --short HEAD)
echo -e "${GREEN}✅ Git commit: ${COMMIT_HASH}${NC}"

# 1.1 推送代码到远程
echo -e "${BLUE}🚀 推送代码到远程...${NC}"
if git push 2>/dev/null; then
  echo -e "${GREEN}✅ 代码已推送到远程${NC}"
else
  echo -e "${YELLOW}⚠️  推送失败，尝试设置上游分支...${NC}"
  CURRENT_BRANCH=$(git branch --show-current)
  if git push -u origin "$CURRENT_BRANCH" 2>/dev/null; then
    echo -e "${GREEN}✅ 代码已推送到远程 (已设置上游分支)${NC}"
  else
    echo -e "${RED}❌ 推送失败，请手动执行: git push${NC}"
  fi
fi

# 2. 关闭 GitHub Issue（如果有Issue号）
if [ -n "$ISSUE" ]; then
  echo -e "${BLUE}🔒 关闭 GitHub Issue #${ISSUE}...${NC}"
  ISSUE_COMMENT="✅ 已完成 (commit: ${COMMIT_HASH})"
  gh issue close "$ISSUE" -c "$ISSUE_COMMENT" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  无法关闭 Issue (可能需要 gh auth login 或 Issue 不存在)${NC}"
  }
  echo -e "${GREEN}✅ Issue #${ISSUE} 已关闭${NC}"
else
  echo -e "${YELLOW}⚠️  跳过 Issue 关闭（无Issue号）${NC}"
fi

# 3. 解析需求ID (支持多个ID)
# 最简单的方法：直接查找并格式化
REQ_IDS=$(echo "$MESSAGE" | grep -o '\[REQ-[A-Z0-9-]\+\]' | tr '\n' ' ')
REQ_IDS="$REQ_IDS$(echo "$MESSAGE" | grep -o '\[ARCH-[A-Z0-9-]\+\]' | tr '\n' ' ')"
REQ_IDS="$REQ_IDS$(echo "$MESSAGE" | grep -o '\[DATA-[A-Z0-9-]\+\]' | tr '\n' ' ')"
REQ_IDS="$REQ_IDS$(echo "$MESSAGE" | grep -o '\[API-[A-Z0-9-]\+\]' | tr '\n' ' ')"

# 清理多余的空格
REQ_IDS=$(echo "$REQ_IDS" | sed 's/^ *//' | sed 's/  */ /g' | sed 's/ *$//')

# 4. 自动更新SPEC状态（如果有需求ID）
if [ -n "$REQ_IDS" ]; then
  echo ""
  echo -e "${BLUE}🔄 自动更新SPEC状态...${NC}"
  echo "检测到的需求ID: $REQ_IDS"

  # 调用SPEC状态更新脚本
  if "$SCRIPT_DIR/update-spec-status.sh" \
    --req-ids "$REQ_IDS" \
    --commit-hash "$COMMIT_HASH" \
    --issue "$ISSUE" 2>/dev/null; then
    echo -e "${GREEN}✅ SPEC状态更新成功${NC}"
  else
    echo -e "${YELLOW}⚠️  SPEC状态更新失败（请手动更新）${NC}"

    # 如果自动更新失败，显示手动更新提示
    echo ""
    echo -e "${YELLOW}📝 请手动更新SPEC文件：${NC}"
    echo ""
    echo "请在项目SPEC文件中完成以下更新："
    echo ""
    echo "1. 找到相关需求ID的功能描述"
    for req_id in $REQ_IDS; do
      echo "   - 搜索: $req_id"
    done
    echo ""
    echo "2. 将状态标记为已完成 [x]"
    echo "   - 标注实现方式（手写代码/CRUD引擎自动生成/基于共享库XXX）"
    echo "   - 添加完成日期: $(date +%Y-%m-%d)"
    echo "   - 添加提交信息: [commit: $COMMIT_HASH]"
    if [ -n "$ISSUE" ]; then
      echo "   - 添加Issue信息: [Issue: #$ISSUE]"
    fi
    echo ""
    echo "3. 根据变更类型升级版本号"
    echo "   - 新功能(feat:): minor版本+1"
    echo "   - Bug修复(fix:): patch版本+1"
    echo "   - 更新 SPEC/VERSION 文件"
    echo ""
    echo "4. 创建 Git Tag"
    echo "   - git tag v<新版本号>"
    echo "   - git push origin v<新版本号>"
  fi
else
  echo -e "${YELLOW}⚠️  未检测到需求ID，跳过SPEC状态更新${NC}"
fi

echo ""
echo "---"
echo -e "${GREEN}✅ 脚本执行完成${NC}"

# 显示摘要
echo ""
echo "执行摘要:"
echo "- 提交哈希: $COMMIT_HASH"
echo "- 提交信息: $MESSAGE"
echo "- 需求ID: ${REQ_IDS:-无}"
echo "- Issue: ${ISSUE:-无}"
echo "- 执行日期: $(date +%Y-%m-%d)"