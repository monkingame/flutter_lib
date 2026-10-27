#!/usr/bin/env python3
# =============================================================================
# agents-md-lang-rule / inject.py
# 给指定项目的 AGENTS.md 注入「语言铁律」规则块（中文母语输出规范）
#
# 用法：
#   python3 inject.py <目标项目根目录> [--dry-run]
#
# 行为：
#   · <目标>/AGENTS.md 不存在 → 报错（提示先运行 agents-md-migrate）
#   · 已含「语言铁律」→ 跳过（幂等，零改动）
#   · 插入位置：H1 标题（及其后空行）之后；无 H1 则置于文件最前
#   · 规则块内容为本脚本内嵌真源；块外原文逐字节零改动（含 CRLF / 无末尾换行等原始形态）
#   · 写入前自动备份 + 多重断言；失败自动回滚
#
# 退出码：0 成功 / 已存在跳过；1 失败；2 用法错误
# =============================================================================
from __future__ import annotations

import argparse
import hashlib
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

# ── 规则块内容真源（13 行；不含末尾换行）────────────────────────────────
BLOCK = """\
> ## ⚠️ 语言铁律（最高优先级，适用于每一次会话、每一个回合，无例外）
>
> 你是一位**中文母语**的 AI 工程助手。你的一切输出——包括：
> - **内部思考链（reasoning / Thought 块）**
> - 工具调用前的分析、调用后的总结
> - 最终回复
>
> 都必须使用**简体中文**。英文仅允许出现在：技术名词、命令、JSON 键、代码、文件名、模型/服务名等**原样引用**中。
>
> **正例**（合规）：思考链为「先检查数据库连接配置，再确认超时参数」，回复为中文说明。
> **反例**（违规）：思考链出现整段英文，如 "I need to check the connection timeout…"。
>
> **判定标准**：若思考链或回复中出现连续多个英文单词组成的句子（非代码/技术名词/命令），即视为违反本铁律，必须改为中文重新生成。"""

MARK = "语言铁律"          # 幂等查重词（规则块标题独有）
BLOCK_LINES = BLOCK.split("\n")


def md5b(data: bytes) -> str:
    return hashlib.md5(data).hexdigest()


def split_lines_ke(text: str) -> list[str]:
    """按 \\n 切行并保留行尾（仅 \\n；\\r 留在行内，保持原始字节形态）。"""
    parts = text.split("\n")
    lines: list[str] = []
    for i, p in enumerate(parts):
        if i < len(parts) - 1:
            lines.append(p + "\n")
        elif p:                       # 末尾无换行的最后一行
            lines.append(p)
    return lines


def inject(project_root: Path, dry_run: bool) -> int:
    agents = project_root / "AGENTS.md"

    if not project_root.is_dir():
        print(f"❌ 目标目录不存在或不是目录：{project_root}", file=sys.stderr)
        return 1
    if agents.is_symlink():
        print(f"⚠️  {agents} 是符号链接，拒绝处理（请人工处理）", file=sys.stderr)
        return 1
    if not agents.is_file():
        print(
            f"❌ 未找到 {agents}\n"
            f"   （该项目的指令真源尚不是 AGENTS.md；可先运行 agents-md-migrate 完成迁移）",
            file=sys.stderr,
        )
        return 1

    raw = agents.read_bytes()
    text = raw.decode("utf-8", errors="surrogateescape")

    # ── 幂等查重 ──
    if MARK in text:
        print(f"⏭️  [已存在] {agents} 已含「{MARK}」，跳过（未改动任何文件）")
        return 0

    # ── 行尾风格（跟随原文） ──
    crlf = b"\r\n" in raw
    eol = "\r\n" if crlf else "\n"
    eol_b = eol.encode()

    # ── 插入点判定：H1 之后 / 文件最前 ──
    lines = split_lines_ke(text)
    l1 = lines[0].rstrip("\r\n") if lines else ""
    is_h1 = bool(re.match(r"#[ \t]", l1)) and not l1.startswith("##")

    rest = list(lines)
    head: list[str] = []
    sep_before = False
    if is_h1:
        head.append(rest.pop(0))
        if rest and rest[0].rstrip("\r\n") == "":
            head.append(rest.pop(0))        # 消耗 H1 后的空行
        else:
            sep_before = True               # H1 后无空行 → 注入时补一个
    # 无 H1：head 为空，块置于文件最前

    head_b = "".join(head).encode("utf-8", errors="surrogateescape")
    rest_b = "".join(rest).encode("utf-8", errors="surrogateescape")

    # ── 构造新内容（纯字节拼接） ──
    block_b = b"".join(line.encode("utf-8") + eol_b for line in BLOCK_LINES)
    inserted_b = (eol_b if sep_before else b"") + block_b + eol_b
    new_b = head_b + inserted_b + rest_b

    # ── 断言链（写入前） ──
    if head_b + rest_b != raw:
        print("❌ 内部断言失败：切片重组 ≠ 原文件（未写入，终止）", file=sys.stderr)
        return 1
    if len(new_b) != len(raw) + len(inserted_b):
        print("❌ 内部断言失败：字节数等式不成立（未写入，终止）", file=sys.stderr)
        return 1
    if new_b.replace(inserted_b, b"", 1) != raw:
        print("❌ 内部断言失败：剥离插入块后未能逐字节还原原文（未写入，终止）", file=sys.stderr)
        return 1

    where = "H1 标题之后" if is_h1 else "文件最前"
    added = len(inserted_b)

    # ── dry-run：只打印计划 ──
    if dry_run:
        print(f"🔍 [dry-run] {agents}")
        print(f"    插入点：{where}；行尾：{'CRLF' if crlf else 'LF'}")
        print(f"    字节：{len(raw)} → {len(new_b)}（+{added}）")
        return 0

    # ── 备份 + 写入（同目录临时文件 → 原子替换；失败自动回滚） ──
    bak_path: str | None = None
    try:
        fd, bak_path = tempfile.mkstemp(prefix="agents-md-lang-rule.bak.")
        os.close(fd)
        shutil.copy2(agents, bak_path)
        if md5b(Path(bak_path).read_bytes()) != md5b(raw):
            print("❌ 备份校验失败（md5 不一致，未写入，终止）", file=sys.stderr)
            return 1

        tmp = tempfile.NamedTemporaryFile(
            prefix=".AGENTS.md.lang-rule.", dir=project_root, delete=False
        )
        tmp_path = Path(tmp.name)
        try:
            tmp.write(new_b)
            tmp.flush()
            os.fsync(tmp.fileno())
        finally:
            tmp.close()

        if tmp_path.read_bytes() != new_b:
            print("❌ 临时文件写入校验失败（原文件未动，终止）", file=sys.stderr)
            tmp_path.unlink(missing_ok=True)
            return 1

        new_md5 = md5b(new_b)
        os.replace(tmp_path, agents)                       # 原子替换

        if md5b(agents.read_bytes()) != new_md5:
            shutil.copy2(bak_path, agents)                 # 回滚
            print("❌ 写入后校验失败，已回滚原文件", file=sys.stderr)
            return 1
    except OSError as exc:
        print(f"❌ 写入失败：{exc}", file=sys.stderr)
        try:
            shutil.copy2(bak_path, agents)                 # 尽力回滚
            print("↩️  已回滚原文件", file=sys.stderr)
        except OSError:
            pass
        return 1
    finally:
        if bak_path:
            try:
                os.unlink(bak_path)
            except OSError:
                pass

    print(f"✅ 已注入「{MARK}」：{agents}")
    print(f"    插入点：{where}；行尾：{'CRLF' if crlf else 'LF'}")
    print(f"    字节：{len(raw)} → {len(new_b)}（+{added}）；新 md5={md5b(new_b)}")
    return 0


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(
        prog="inject.py",
        description="给指定项目的 AGENTS.md 注入「语言铁律」规则块（幂等；内容真源内嵌）",
    )
    ap.add_argument("project", help="目标项目根目录（其下需存在 AGENTS.md）")
    ap.add_argument("--dry-run", action="store_true", help="只打印计划，不写入任何文件")
    args = ap.parse_args(argv)

    try:
        root = Path(args.project).expanduser().resolve(strict=True)
    except OSError:
        print(f"❌ 目标目录不存在：{args.project}", file=sys.stderr)
        return 1

    return inject(root, args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
