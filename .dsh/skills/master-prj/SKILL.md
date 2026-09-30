---
name: master-prj
description: 技术学习一条龙 — 集学习、操作、坑点、参考手册于一体。无参数展示进度，/master-prj ? 显示用法。
---

# /master-prj — 技术学习一条龙

集 **学 → 做 → 记 → 查** 于一体的项目管理框架。四个域共享一条时间线，双向联动。

## 命令全集

```
/master-prj                       无参数 → 展示双线进度（learn + ops）
/master-prj ?                     显示本帮助
/master-prj learn                 学习模式（自动判意图：准备下一步 vs 记录存档）
/master-prj ops                   操作模式（自动判意图：准备下一步 vs 记录存档）
/master-prj pause                 暂停当前活动 → 自动识别 learn/ops → 写中断标记 → 触发 /checkpoint
/master-prj pitfall [描述]         记录坑点（查重 → 追加/更新 → 复发计数）
/master-prj ref [章节号|关键词]     搜索参考手册（docs/ref/*.md）
/master-prj init [项目名]          初始化新项目（创建目录骨架 + CLAUDE.md + 复制配套 skills）
```

`/checkpoint` 和 `/daily-report` 是独立通用命令，不属于 `/master-prj`，任何项目装上即用。

---

## `/master-prj ?` — 帮助

输出完整的命令参考（即本 SKILL.md 的摘要）：全部命令及其用途、四个域的说明、日志格式模板。供用户快速查阅，无需记住所有子命令。

## 四个域

| 域 | 命令 | 读写的文件 | 回答的问题 |
|------|------|------|------|
| **learn** | `/master-prj learn` | `docs/learn/learning-plan.md` + `learn-log.md` | 今天学了什么、理解程度、下一步 |
| **ops** | `/master-prj ops` | `ops/plan.md` + `ops-log.md` | 服务器上做了什么、什么结果、下一步 |
| **pitfall** | `/master-prj pitfall` | `docs/bugs-and-pitfalls.md` | 踩了什么坑、怎么防、复发次数 |
| **ref** | `/master-prj ref` | `docs/ref/*.md`（只读） | 这个概念/技术是什么意思 |

---

## 主入口 `/master-prj`（无参数）

1. 读取 `docs/learn/learn-log.md` 最后一条 → 提取学习进度
2. 读取 `ops/ops-log.md` 最后一条 → 提取操作进度
3. 读取 `docs/bugs-and-pitfalls.md` → 统计条目数和最近日期

展示格式：

```
📖 学习: Phase 1 环境搭建  [2/5]  ████░░░░░░  下一步: 1.3 vLLM 部署
🔧 操作: 步骤 1.1 已完成 ✅               下一步: 步骤 1.2
⚠️ 坑点: 12 条，最近 2026-07-06
```

若任一处于中断状态 → 提示 `/master-prj learn` 或 `/master-prj ops` 恢复。

---

## `/master-prj learn` 和 `/master-prj ops`

两者共享同一套**自动判意图**逻辑：

### 自动判意图

```
收到 /master-prj learn 或 /master-prj ops
  │
  ├─ 工作区干净（git status --porcelain 无输出）
  │    → 意图 = "准备下一步"
  │    → 回顾上次进度 → 展示下一步要做什么
  │
  ├─ 有未提交变更
  │    → 意图 = "记录存档"
  │    → 回顾进度 → 去重检查 → 收集信息 → 追加日志
  │    → 提醒用户用 /checkpoint 提交
  │
  └─ 用户显式说了关键词：
       "看日志"/"回顾"/"到哪了" → 意图 = 仅查看
       "开始第N步"/"继续"/"下一步" → 意图 = 强制执行新步骤
       "记录"/"存档"/"完成了" → 意图 = 强制执行存档
```

### 去重检查

读取对应日志文件（learn-log.md / ops-log.md）最后一条记录：

- **最新日志日期 ≠ 今天** → 新增一条独立日志
- **最新日志日期 = 今天** → 追加到今日已有条目末尾（用 `---` 分隔）

### learn 日志格式

```markdown
## YYYY-MM-DD

**学习内容**：
- 具体的知识点
- 完成的任务

**学到的关键概念**：
- 概念 1：简短解释
- 概念 2：简短解释

**理解程度**：熟练 / 理解 / 框架 / 入门

**遇到的问题**：
- 问题描述 → 解决过程

**下一步**：具体计划
```

### ops 日志格式

```markdown
## 步骤 X.Y：名称 — YYYY-MM-DD HH:MM

**目标**：这一步要达成什么
**服务器**：目标机器
**执行命令**：关键命令
**关键输出**：关键输出片段
**结果**：✅ / ⚠️ / ❌
**问题与解决**：问题 → 排查 → 方案
**当前状态**：服务/GPU/API 状态
**下一步**：步骤 X.Y — 名称
```

### learn ↔ ops 联动

`docs/learn/learning-plan.md` 中每个任务可标注对应的操作步骤：

```markdown
## Phase 1：环境搭建
- [ ] 1.1 Docker 基础概念          → ops:1.1
- [ ] 1.2 NVIDIA 驱动与 CUDA       → ops:1.2
```

当 `/master-prj learn` 检测到某 Phase 全部 `[x]` 时提示：

> 📋 Phase 1 学习完成。对应操作步骤：ops-1.1 ~ ops-1.2，用 `/master-prj ops` 开始。

当 `/master-prj ops` 检测到某操作步骤的前置学习未完成时提示：

> ⚠️ ops-1.2 的前置学习 learn-1.2 尚未完成。建议先 `/master-prj learn` 完成学习。

---

## `/master-prj pause`

1. 比较 `docs/learn/learn-log.md` 和 `ops/ops-log.md` 最后一条的时间戳
2. 时间更近的 = 当前活动域
3. 在对应日志末尾写入中断标记：`> ⏸️ 中断 — YYYY-MM-DD HH:MM`
4. 存档当前变更：
   - 检测本项目 `.claude/skills/checkpoint/` 是否存在
   - **存在** → 自动调用 `/checkpoint -y`（静默模式，不弹确认，直接 commit + push）
   - **不存在** → 提醒用户"本项目未安装 checkpoint skill，请手动 git add + commit + push"
5. 原理：pause 通常是赶时间或下班场景，必须稳妥保存，不能卡在确认提示上

---

## `/master-prj pitfall [描述]`

同独立 pitfall skill 的完整逻辑：

- 有描述 → 提取症状/根因/解法 → 查重 → 追加/更新 → 复发计数
- 无描述 → 扫描对话上下文有无 bug 讨论 → 有则记录 → 无则显示统计
- 统计格式：`当前共 N 条坑点，最近更新 YYYY-MM-DD`

条目存储在 `docs/bugs-and-pitfalls.md`。

---

## `/master-prj ref [章节号|关键词]`

1. 无参数 → 列出 `docs/ref/` 下全部章节索引
2. 数字（如 `3`）→ 读取对应编号章节
3. 关键词 → 在全部 `docs/ref/*.md` 中搜索标题和标签 → 展示匹配摘要 → 精确匹配则展示完整章节
4. `数字 关键词` → 在指定章节内定位到关键词所在小节

---

## `/master-prj init <项目名>`

1. 创建项目目录和完整骨架（见下方目录结构）
2. 从 `ai-agent/claudecode/skills/` 复制 checkpoints/daily-report/master-prj 到 `.claude/skills/`
3. 生成 CLAUDE.md（含 skill 注册表 + 项目概述占位）
4. 创建空的 `docs/learn/learning-plan.md`、`ops/plan.md` 模板
5. 创建空的 `docs/bugs-and-pitfalls.md` 模板

### init 生成的目录结构

```
<项目名>/
├── CLAUDE.md                          ← 自动生成
├── .claude/skills/
│   ├── master-prj/SKILL.md              ← 从模板复制
│   ├── checkpoint/SKILL.md            ← 通用（独立命令）
│   └── daily-report/SKILL.md          ← 通用（独立命令）
├── ops/                               ← 实操（计划/日志/原始日志）
│   ├── plan.md                        ← 操作计划模板
│   ├── ops-log.md                     ← 空
│   └── raw-logs/                      ← 原始日志
├── docs/
│   ├── learn/
│   │   ├── learning-plan.md           ← 学习计划模板
│   │   ├── learn-log.md               ← 空
│   │   └── reference.md               ← 空
│   ├── ref/                           ← 空目录
│   ├── survey/                        ← 站点头手册
│   ├── worklog/                       ← 日报目录
│   ├── cn-mirror.md                   ← 预留
│   └── bugs-and-pitfalls.md           ← 坑点库模板
├── workspace/
└── scripts/
```

---

## 设计原则

- **通用化**：不硬编码项目路径、用户名、分支名
- **不覆盖已有内容**：log 永远只追加，不做任何覆盖
- **去重优先**：同一天的日志合并，同一个 pitfall 追加而非新建
- **自动判意图**：用户不需要记住"现在是该记录还是该继续"——看 git 状态就知道
- **双向联动**：learn 完成提示 ops；ops 开始前检查 learn 前置
- **框架与内容分离**：/master-prj 只管调度和格式；`docs/`（学习/手册）与 `ops/`（实操）下的内容都是用户自己的内容
