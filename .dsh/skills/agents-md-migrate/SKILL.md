---
name: agents-md-migrate
description: 指令真源迁移——把本项目的指令源从 CLAUDE.md 翻转为 AGENTS.md 真源（AGENTS.md=全文，CLAUDE.md=单行 @AGENTS.md 导入）。作用域硬性限定：每个项目一份副本、各管各的——只检查/迁移本 skill 所属项目自身的 AGENTS.md 与 CLAUDE.md；不支持父目录普查、跨项目、批量（无 --all）。纯脚本 + md5 断言 + 失败自动 git 回滚。依据：AGENTS.md=跨工具事实标准（Linux Foundation 治理，28+ 工具）；opencode V2 只读 AGENTS.md；Claude Code ≥v2.1.277 原生支持且官方推荐 @import 模式。触发：/agents-md-migrate、"指令文件升级"、"CLAUDE.md 换成 AGENTS.md"、"真源迁移/翻转"。
---

# agents-md-migrate — 指令真源迁移（CLAUDE.md → AGENTS.md）

## 作用域铁律（最高优先级）

**分发模型：每个项目一份副本，各管各的。**

- 本 skill 的**唯一作用对象**是它被复制进的那个项目，即 `.claude/skills/agents-md-migrate/` 所在项目的根。
- 只读 / 只写该项目根下的两个文件：`CLAUDE.md`、`AGENTS.md`。
- **明令禁止**（无例外）：
  - 扫描 / 检查 / 读取 / 修改父目录、兄弟项目或任何其他项目——**哪怕是"只读看看"也不允许**；
  - 批量迁移——脚本没有 `--all`，也不接受父目录 / 目标目录等任何位置参数；
  - 试图用 `cd` 或绝对路径把作用域指向别处——作用域由副本自身的安装位置决定，任何参数都改变不了。
- 脚本内置越界自检：副本位于 `<项目>/.claude/skills/agents-md-migrate/` 时，作用域锁定为该项目，传入任何目标路径直接报错退出（exit 2）。
- 需要迁移多个项目时：**分别进入每个项目、执行各自副本**，一次一个项目；绝不代跑、不顺带、不批量。

## 背景（为什么升级）

- **AGENTS.md 已是跨工具事实标准**：2025-08 由 OpenAI 等发起，2025-12 移交 Linux Foundation（Agentic AI Foundation）治理；60k+ 仓库、28+ 工具原生支持（Codex / Cursor / Copilot / Zed / DeepSeek dsh / 智谱 ZCode 等）。
- **opencode V2 只读 `AGENTS.md`**：不识别 `CLAUDE.md`。以 CLAUDE.md 为唯一指令源的项目，指令不会被机制加载（仅靠模型"自觉去读"的旧桥接，非 100%）。
- **Claude Code ≥ v2.1.277（2026-09-18）原生支持 `AGENTS.md`**，官方文档明确推荐"单一真源"模式：`CLAUDE.md` 写一行 `@AGENTS.md`（`@path` 导入语法，启动时展开，对任意版本兼容，且**不会重复加载**）。

**目标结构**（翻转真源：一份内容、两个入口、全部工具确定性加载）：

```
项目/
├── AGENTS.md   ← 真源：原 CLAUDE.md 全文（逐字节拷贝，零改写）
└── CLAUDE.md   ← 壳：单行 "@AGENTS.md"（11 字节）
```

## 执行方式（铁律 1：一切操作走脚本）

本 skill 目录内的 **`migrate.sh` 是唯一执行入口**。agent 读取本文件后，必须用 shell 工具执行该脚本；**禁止**用自然语言手工模拟迁移、禁止绕过断言手改文件、禁止在脚本失败后"人肉修复"——只报告并停下：

```bash
SK=".claude/skills/agents-md-migrate/migrate.sh"   # 在所属项目内执行

bash "$SK" scan                  # ① 只读检查本项目指令文件状态（不改任何文件）
bash "$SK" migrate [--dry-run]   # ② 迁移本项目（--dry-run 只打印计划）
```

脚本输出即执行证据；每一步 md5/字节断言失败会自动 git 回滚。**命令不接受任何目标目录参数**，传入即报错。

## 铁律

1. **作用域锁定**：只处理本 skill 所属项目；禁止普查父目录、跨项目、批量（见"作用域铁律"）
2. **一切操作走 `migrate.sh`**（唯一执行入口；禁止手工模拟）
3. **不覆盖真实内容**：`AGENTS.md` 仅在"不存在"或"旧桥接指针"（< 1KB 且匹配桥接文本）时可覆盖；其他内容一律 CONFLICT，停止并报告
4. **失败自动回滚**：断言失败 → 脚本自动恢复两文件到执行前；不得手工补修
5. **只动两文件**：仅 `CLAUDE.md` / `AGENTS.md`；不碰 `.claude/`、`.opencode/` 等其他任何文件
6. **迁移后必须验证**（见下节）

## 分类判定（scan 输出口径，仅针对本项目）

| 分类 | 条件 | 动作 |
|---|---|---|
| ✅ MIGRATE | 有 CLAUDE.md，且 AGENTS.md 不存在 / 是旧桥接指针 | 可迁移 |
| ⏭️ READY | AGENTS.md 已是真源（CLAUDE.md 不存在，或其内容已是 `@AGENTS.md`） | 跳过 |
| ⚠️ CONFLICT | AGENTS.md 有真实内容；或 CLAUDE.md 为符号链接 | 停止，人工决策 |
| ➖ NONE | 两者皆无 | 跳过 |

## 断言链（脚本自动，全部动态计算，零硬编码）

```
前置：git 仓库 / CLAUDE.md 已被 git 跟踪 / 两文件无未提交改动 / AGENTS.md 安全可覆盖
基线：BASE_MD5 = 运行时 md5sum(CLAUDE.md)          ← 每次现算，不写死
① 纯字节拷贝：cp CLAUDE.md AGENTS.md
   断言 md5(AGENTS.md) == BASE_MD5
② 覆写壳：    printf '@AGENTS.md\n' > CLAUDE.md
   断言 md5 == (printf '@AGENTS.md\n' | md5sum) 且字节数 == 11
③ 终检：      diff AGENTS.md <(git show HEAD:CLAUDE.md)   ← 与版本库逐字节零差异
   任一失败 → 自动回滚（git checkout CLAUDE.md + AGENTS.md 原文件备份恢复）
```

## 迁移后验证（人工，30 秒）

- **opencode**：新开会话，问一个只有指令文件里才有的内容（如"语言铁律的判定标准"）；能准确复述 = AGENTS.md 全文已机制注入
- **Claude Code**：`/memory` 看 Memory files 是否列出 CLAUDE.md（import 自动展开）；或直接提问核对

## 已知边界

- **非 git 仓库 / CLAUDE.md 未跟踪 / 两文件有未提交改动** → 拒绝执行（无回滚保障）
- **CLAUDE.md 为符号链接** → CONFLICT（人工处理）
- **AGENTS.md 为真实内容（非旧桥接）** → CONFLICT（本 skill 不合并、不覆盖）
- **多项目需求** → 逐个进入项目执行各自副本；本 skill 不提供、也不接受批量模式
- 旧桥接识别标准：文件 < 1KB 且含文本"统一维护在同目录的 [CLAUDE.md]"（历史过渡方案的指针格式，可直接覆盖）
- 库内模板（非 `.claude/skills/` 安装态）直接运行 → 以当前 git 仓库为作用域，仅供库内测试；正式使用请先安装/同步到目标项目
- 运行环境：Linux / WSL / Git Bash（依赖 `md5sum` 等 coreutils；macOS 需 GNU coreutils，未验证）

## 设计说明

- **为什么强制单项目作用域**：本 skill 的分发模型是"每个项目一份副本"；若允许父目录普查 / `--all` 批量，单项目会话里的 agent 会越过项目边界去检查甚至迁移兄弟项目（已实际发生越权），既违背模型又不可控。跨项目迁移属于独立的人工运维操作，不是本项目内部 skill 的职责——需要时应逐个进入项目执行。
- **为什么纯脚本**：字节级替换用确定性脚本执行（md5 作钢印、每步断言、失败回滚），比自然语言临场发挥精确；大模型只负责调用与汇报
- **为什么 `@AGENTS.md` 导入而不是符号链接**：Claude Code 的 Edit/Write 工具拒绝写 symlink；Windows 创建 symlink 需管理员权限，且 Git 检出可能退化为普通文本文件
- **为什么脚本内嵌 skill 目录**：`/skill-sync` 按整目录同步——脚本随 skill 一起进库、分发，保持自包含
- **与旧桥接方案的关系**：早期为兼容 opencode V2 曾采用"AGENTS.md 一句话指针 → 指向 CLAUDE.md 真源"的过渡方案；其前提"Claude Code 只读 CLAUDE.md"已于 2026-09-18 失效。本 skill 即新架构的正式替代——所有项目迁移完毕后，旧桥接产物（技能、command 入口、指针文件）应一并清理
