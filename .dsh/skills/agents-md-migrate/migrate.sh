#!/usr/bin/env bash
# =============================================================================
# agents-md-migrate / migrate.sh
# 指令真源迁移：CLAUDE.md → AGENTS.md（纯字节拷贝 + 全断言 + 失败自动回滚）
#
# 翻转后结构：
#   AGENTS.md  原 CLAUDE.md 全文（逐字节一致）
#   CLAUDE.md  单行 "@AGENTS.md"（Claude Code 官方 @import 语法）
#
# 作用域（硬性，不可逾越）：每个项目一份副本，各管各的——
#   安装态 <项目>/.claude/skills/agents-md-migrate/migrate.sh：
#     所属项目 = 副本位置向上 3 级；脚本只读写该项目根下的 CLAUDE.md / AGENTS.md。
#   父目录普查、跨项目、批量（--all）一律不支持；传入任何目标目录参数直接报错。
#   非安装态（库内模板）以当前 git 仓库为作用域，同样仅限单项目（仅供库内测试）。
#
# 用法（在所属项目内执行）：
#   bash migrate.sh scan                 只读检查本项目指令文件状态（不改任何文件）
#   bash migrate.sh migrate [--dry-run]  迁移本项目（--dry-run 只打印计划）
#
# 保障：一切变更全断言（md5 / 字节数 / diff）；任一断言失败自动回滚；
#       仅覆盖"不存在"或"旧桥接指针"的 AGENTS.md；非 git 项目拒绝执行。
# 退出码：0 成功；1 有失败 / 冲突；2 用法错误或越界
# =============================================================================
set -euo pipefail

IMPORT_CONTENT='@AGENTS.md'
BRIDGE_RE='统一维护在同目录的 \[CLAUDE\.md\]'          # 旧桥接指针特征（唯一可安全覆盖的 AGENTS.md 形态）
MAX_BRIDGE_BYTES=1024                                 # 桥接指针体积上限（防误判真源）

IMPORT_MD5=$(printf '%s\n' "$IMPORT_CONTENT" | md5sum | awk '{print $1}')   # 运行时动态计算，零硬编码
IMPORT_BYTES=$(printf '%s\n' "$IMPORT_CONTENT" | wc -c | tr -d ' ')

md5_of()   { md5sum "$1" | awk '{print $1}'; }
bytes_of() { wc -c < "$1" | tr -d ' '; }

# ── 作用域解析：锁定"本 skill 所属项目"，任何参数都改变不了 ──
resolve_root() {
  local script_dir top
  script_dir=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  case "$script_dir" in
    */.claude/skills/agents-md-migrate)
      ROOT=$(cd -P "$script_dir/../../.." && pwd)     # 安装态：项目根 = 副本向上 3 级
      ;;
    *)
      # 库内模板 / 非标准位置：以当前 git 仓库为作用域，同样仅限单项目
      top=$(git rev-parse --show-toplevel 2>/dev/null) || top=''
      [ -n "$top" ] || { echo "❌ 无法确定作用域：本副本不在项目的 .claude/skills/ 下，且当前目录不是 git 仓库（拒绝执行）" >&2; exit 2; }
      ROOT=$(cd -P "$top" && pwd)
      ;;
  esac
}

# ── 项目分类：MIGRATE / READY / CONFLICT / CONFLICT_SYMLINK / NONE ──
classify() {
  local d="$1"
  local c="$d/CLAUDE.md" a="$d/AGENTS.md"
  if [ -e "$c" ] && [ -L "$c" ]; then echo CONFLICT_SYMLINK; return 0; fi
  if [ ! -e "$c" ] && [ ! -e "$a" ]; then echo NONE; return 0; fi
  if [ ! -e "$c" ] && [ -f "$a" ]; then echo READY; return 0; fi          # AGENTS.md 已是真源
  if [ -f "$c" ] && [ "$(tr -d '[:space:]' < "$c")" = "$IMPORT_CONTENT" ]; then
    echo READY; return 0                                                  # 已迁移态
  fi
  if [ -f "$c" ]; then
    if [ ! -e "$a" ]; then echo MIGRATE; return 0; fi                     # 无 AGENTS.md → 可迁移
    if [ -f "$a" ] && [ "$(bytes_of "$a")" -lt "$MAX_BRIDGE_BYTES" ] \
       && grep -qE "$BRIDGE_RE" "$a"; then echo MIGRATE; return 0; fi     # 旧桥接 → 可覆盖
    echo CONFLICT; return 0                                               # 真实内容 → 拒动
  fi
  echo CONFLICT
  return 0
}

# ── 单项目迁移（作用域恒为 $ROOT，不接受目标参数） ──
do_migrate() {
  local dry="$1"
  local c="$ROOT/CLAUDE.md" a="$ROOT/AGENTS.md"
  local bak_a='' existed_a=no

  # 按分类提前分流
  case "$(classify "$ROOT")" in
    READY)  echo "⏭️  [本项目] 已就绪（AGENTS.md 已是真源），跳过"; return 0;;
    NONE)   echo "⏭️  [本项目] 无指令文件，跳过"; return 0;;
    CONFLICT|CONFLICT_SYMLINK)
      echo "⚠️  [本项目] CONFLICT（AGENTS.md 为真实内容，或 CLAUDE.md 为符号链接），拒绝执行" >&2
      return 1;;
  esac

  # ── 前置断言（回滚保障） ──
  git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1 \
    || { echo "❌ [本项目] 非 git 仓库（无回滚保障，拒绝）" >&2; return 1; }
  git -C "$ROOT" ls-files --error-unmatch CLAUDE.md >/dev/null 2>&1 \
    || { echo "❌ [本项目] CLAUDE.md 未被 git 跟踪（无回滚保障，拒绝）" >&2; return 1; }
  { git -C "$ROOT" diff --quiet -- CLAUDE.md AGENTS.md \
    && git -C "$ROOT" diff --cached --quiet -- CLAUDE.md AGENTS.md; } \
    || { echo "❌ [本项目] 两文件有未提交改动（先提交再迁移）" >&2; return 1; }

  if [ -e "$a" ]; then
    existed_a=yes
    bak_a=$(mktemp) || return 1
    cp -p "$a" "$bak_a" || { rm -f "$bak_a"; return 1; }
  fi

  # ── 动态基线（每次运行现算） ──
  local base_md5 base_bytes
  base_md5=$(md5_of "$c")
  base_bytes=$(bytes_of "$c")

  if [ "$dry" = yes ]; then
    echo "🔍 [dry-run] [本项目] CLAUDE.md ${base_bytes}B (${base_md5:0:8}…) → AGENTS.md；CLAUDE.md → '${IMPORT_CONTENT}' (${IMPORT_BYTES}B)"
    if [ "$existed_a" = yes ]; then rm -f "$bak_a"; fi
    return 0
  fi

  rollback() {
    echo "↩️  [本项目] $* — 执行回滚" >&2
    git -C "$ROOT" checkout -- CLAUDE.md 2>/dev/null || true
    if [ "$existed_a" = yes ]; then
      cp -p "$bak_a" "$a" 2>/dev/null || true
    else
      rm -f "$a" 2>/dev/null || true
    fi
    if [ -n "$bak_a" ]; then rm -f "$bak_a" 2>/dev/null || true; fi
  }

  # ── 步骤 1：纯字节拷贝 ──
  cp "$c" "$a" || { rollback "拷贝失败"; return 1; }
  if [ "$(md5_of "$a")" != "$base_md5" ]; then
    rollback "拷贝后 AGENTS.md md5 ≠ 基线（${base_md5:0:8}）"; return 1
  fi

  # ── 步骤 2：CLAUDE.md 覆写为单行 import ──
  printf '%s\n' "$IMPORT_CONTENT" > "$c" || { rollback "覆写失败"; return 1; }
  if [ "$(md5_of "$c")" != "$IMPORT_MD5" ]; then
    rollback "覆写后 CLAUDE.md md5 不符"; return 1
  fi
  if [ "$(bytes_of "$c")" -ne "$IMPORT_BYTES" ]; then
    rollback "覆写后 CLAUDE.md 字节数不符"; return 1
  fi

  # ── 步骤 3：终检（与 git HEAD 版逐字节比对） ──
  if ! diff -q "$a" <(git -C "$ROOT" show HEAD:CLAUDE.md) >/dev/null; then
    rollback "终检 diff 不符（AGENTS.md ≠ HEAD 版 CLAUDE.md）"; return 1
  fi

  if [ -n "$bak_a" ]; then rm -f "$bak_a" 2>/dev/null || true; fi
  echo "✅ [本项目] 迁移完成：AGENTS.md ${base_bytes}B md5=${base_md5}（≡ 原 CLAUDE.md）；CLAUDE.md ${IMPORT_BYTES}B '${IMPORT_CONTENT}'"
  return 0
}

# ── 只读检查（仅本项目） ──
cmd_scan() {
  [ $# -eq 0 ] || { echo "❌ scan 不接受任何参数（作用域固定为本项目：$ROOT）" >&2; exit 2; }
  echo "── 检查所属项目：$ROOT ──"
  case "$(classify "$ROOT")" in
    MIGRATE)          echo "✅ MIGRATE   本项目可迁移（CLAUDE.md $(bytes_of "$ROOT/CLAUDE.md")B，AGENTS.md 不存在或为旧桥接指针）";;
    READY)            echo "⏭️  READY     本项目已就绪（AGENTS.md 已是真源）";;
    CONFLICT)         echo "⚠️  CONFLICT  AGENTS.md 为真实内容，需人工决策";;
    CONFLICT_SYMLINK) echo "⚠️  CONFLICT  CLAUDE.md 为符号链接，需人工处理";;
    NONE)             echo "➖ NONE      本项目无指令文件";;
  esac
  return 0
}

# ── 迁移（仅本项目；--dry-run 外不接受任何参数） ──
cmd_migrate() {
  local dry=no x
  for x in "$@"; do
    case "$x" in
      --dry-run) dry=yes;;
      *) echo "❌ 不接受位置/未知参数：$x（作用域固定为本项目，不支持父目录 / --all / 批量）" >&2; exit 2;;
    esac
  done
  do_migrate "$dry"
}

# ── 入口 ──
resolve_root
cmd="${1:-}"
if [ $# -gt 0 ]; then shift; fi
case "$cmd" in
  scan)
    cmd_scan "$@";;
  migrate)
    cmd_migrate "$@";;
  *)
    cat <<EOF
agents-md-migrate — 指令真源迁移（CLAUDE.md → AGENTS.md）

作用域：本 skill 所属项目（当前解析为：$ROOT）
       只读写该项目根下的 CLAUDE.md / AGENTS.md；不支持父目录普查、跨项目、批量。

用法：
  bash migrate.sh scan                 只读检查本项目指令文件状态（不改任何文件）
  bash migrate.sh migrate [--dry-run]  迁移本项目（--dry-run 只打印计划）

说明：AGENTS.md ← 原 CLAUDE.md 全文（逐字节）；CLAUDE.md ← 单行 "@AGENTS.md"（11B）。
      全断言 + 失败自动 git 回滚；仅覆盖"不存在 / 旧桥接指针"的 AGENTS.md。
EOF
    exit 2;;
esac
