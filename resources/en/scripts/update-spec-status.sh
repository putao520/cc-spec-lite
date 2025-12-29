#!/bin/bash

# update-spec-status.sh
# 功能: 自动更新SPEC文件中的需求状态
# 用法: ./update-spec-status.sh --req-ids "REQ-XXX REQ-YYY" --commit-hash "abc123" --issue "123"

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 参数解析
REQ_IDS=""
COMMIT_HASH=""
ISSUE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --req-ids)
      REQ_IDS="$2"
      shift 2
      ;;
    --commit-hash)
      COMMIT_HASH="$2"
      shift 2
      ;;
    --issue)
      ISSUE="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: $0 --req-ids <REQ_IDS> --commit-hash <HASH> --issue <ISSUE>"
      echo ""
      echo "参数:"
      echo "  --req-ids      需求ID列表（空格分隔）"
      echo "  --commit-hash  Git提交哈希值"
      echo "  --issue        GitHub Issue编号"
      echo ""
      echo "示例:"
      echo "  $0 -r 'REQ-AUTH-001 REQ-USER-002' -c 'a1b2c3d' -i '123'"
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
if [ -z "$REQ_IDS" ]; then
  echo -e "${RED}错误: 缺少 --req-ids 参数${NC}"
  exit 1
fi

if [ -z "$COMMIT_HASH" ]; then
  echo -e "${RED}错误: 缺少 --commit-hash 参数${NC}"
  exit 1
fi

# 检查SPEC目录是否存在
if [ ! -d "SPEC" ]; then
  echo -e "${RED}错误: 当前目录未找到SPEC文件夹${NC}"
  exit 1
fi

# 获取当前日期
CURRENT_DATE=$(date +%Y-%m-%d)

# 函数：更新SPEC文件中的需求状态
update_spec_status() {
  local req_id="$1"
  local spec_file=""

  # 根据REQ类型确定SPEC文件
  case $req_id in
    REQ-*)
      spec_file="SPEC/01-REQUIREMENTS.md"
      ;;
    ARCH-*)
      spec_file="SPEC/02-ARCHITECTURE.md"
      ;;
    DATA-*)
      spec_file="SPEC/03-DATA-STRUCTURE.md"
      ;;
    API-*)
      spec_file="SPEC/04-API-DESIGN.md"
      ;;
    *)
      echo -e "${YELLOW}⚠️  无法识别需求ID类型: $req_id${NC}"
      return 1
      ;;
  esac

  if [ ! -f "$spec_file" ]; then
    echo -e "${YELLOW}⚠️  SPEC文件不存在: $spec_file${NC}"
    return 1
  fi

  echo -e "${BLUE}📝 更新需求状态: $req_id${NC}"

  # 创建临时文件
  local temp_file=$(mktemp)

  # 处理需求状态更新
  local updated=false
  while IFS= read -r line; do
    # 检查是否包含需求ID
    if echo "$line" | grep -q "$req_id"; then
      # 检查是否已经是已完成状态
      if echo "$line" | grep -q "\[x\]"; then
        echo "$line" >> "$temp_file"
      else
        # 将 [ ] 替换为 [x]，并在行尾添加完成信息
        local updated_line=$(echo "$line" | sed 's/\[ \]/[x]/')
        updated_line="$updated_line - ✅ 已完成 ($CURRENT_DATE) [commit: $COMMIT_HASH]"
        if [ -n "$ISSUE" ]; then
          updated_line="$updated_line [Issue: #$ISSUE]"
        fi
        echo "$updated_line" >> "$temp_file"
        updated=true
      fi
    else
      echo "$line" >> "$temp_file"
    fi
  done < "$spec_file"

  # 如果找到了并更新了需求，替换原文件
  if [ "$updated" = true ]; then
    mv "$temp_file" "$spec_file"
    echo -e "${GREEN}✅ 已更新: $req_id${NC}"
  else
    rm -f "$temp_file"
    echo -e "${YELLOW}⚠️  未找到待更新的需求: $req_id${NC}"
  fi
}

# 函数：检查VERSION文件并更新版本号
update_version() {
  local version_file="SPEC/VERSION"

  if [ ! -f "$version_file" ]; then
    echo -e "${YELLOW}⚠️  VERSION文件不存在，跳过版本更新${NC}"
    return 0
  fi

  # 读取当前版本
  local current_version=$(cat "$version_file" | tr -d '\n')

  # 检查commit message类型
  local version_bump=""

  for req_id in $REQ_IDS; do
    case $req_id in
      REQ-*)
        # 新功能，增加minor版本
        version_bump="minor"
        break
        ;;
    esac
  done

  # 如果没有明确版本变更，不更新版本
  if [ -z "$version_bump" ]; then
    echo -e "${YELLOW}⚠️  无需版本升级${NC}"
    return 0
  fi

  # 解析版本号
  if [[ $current_version =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    local major=${BASH_REMATCH[1]}
    local minor=${BASH_REMATCH[2]}
    local patch=${BASH_REMATCH[3]}

    case $version_bump in
      major)
        ((major++))
        minor=0
        patch=0
        ;;
      minor)
        ((minor++))
        patch=0
        ;;
      patch)
        ((patch++))
        ;;
    esac

    local new_version="v${major}.${minor}.${patch}"

    # 更新版本文件
    echo "$new_version" > "$version_file"
    echo -e "${GREEN}✅ 版本已更新: $current_version → $new_version${NC}"

    # 创建Git标签
    git tag -a "$new_version" -m "Release $new_version" 2>/dev/null || {
      echo -e "${YELLOW}⚠️  无法创建Git标签（可能已存在）${NC}"
    }

    echo -e "${BLUE}📌 建议推送标签: git push origin $new_version${NC}"
  else
    echo -e "${YELLOW}⚠️  版本格式不正确: $current_version${NC}"
  fi
}

# 主处理流程
echo -e "${BLUE}🚀 开始更新SPEC状态...${NC}"

# 处理REQ_IDS：去掉括号
CLEAN_REQ_IDS=""
for req_id in $REQ_IDS; do
  # 去掉方括号
  clean_id=$(echo "$req_id" | sed 's/^\[//' | sed 's/\]$//')
  CLEAN_REQ_IDS="$CLEAN_REQ_IDS $clean_id"
done

# 更新每个需求的状态
for req_id in $CLEAN_REQ_IDS; do
  update_spec_status "$req_id"
done

# 更新版本号
update_version

echo -e "${GREEN}✅ SPEC状态更新完成${NC}"

# 显示更新摘要
echo ""
echo "--- 更新摘要 ---"
echo "需求ID: $REQ_IDS"
echo "提交哈希: $COMMIT_HASH"
if [ -n "$ISSUE" ]; then
  echo "Issue编号: $ISSUE"
fi
echo "更新日期: $CURRENT_DATE"
echo "------------------"