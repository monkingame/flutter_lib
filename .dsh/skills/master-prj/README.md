# master-prj — 技术学习一条龙

集 **学 → 做 → 记 → 查** 于一体。四个域（learn / ops / pitfall / ref）共享一条时间线，双向联动。

## 状态

🟢 **已决策** — 6 个设计问题已全部定案，可直接部署到新项目。

## 设计决策

### ① ops 路径：可配置 ✅

**决定**：默认 `ops/log.md`，允许在 CLAUDE.md 中覆盖。

```markdown
## 项目配置（CLAUDE.md 示例）
- ops_log: deploy/ops-log.md    ← 可覆盖默认路径
```

### ② ref 参考手册：空目录 ✅

**决定**：`/master-prj init` 时 `docs/ref/` 创建为空。用户学到什么写什么，不给空骨架的错觉。

### ③ 框架分发方式：模板复制 ✅

**决定**：dev-cookbook `ai-agent/claudecode/skills/master-prj/` 作为模板，通过 `copy-skills` 脚本复制到目标项目。复制后人工校准本地化适配。自用为主，不需要独立 repo。

### ④ learn↔ops 联动：内联标签 ✅

**决定**：在学习计划条目后直接标注，一行写完，不额外维护映射表。

```markdown
- [ ] 1.1 Docker 基础概念          → ops:1.1
```

### ⑤ practice 模式：不加 ✅

**决定**：暂不加 `/master-prj practice`。练习代码通过 `/checkpoint` 提交即可，保持框架精简。

### ⑥ 与独立 skill 的关系 ✅

**决定**：
- `pitfall`、`checkpoint` → **保持独立，绝对不动**（通用工具，任何项目适用）
- `learn-log`、`pause-learn` → **先保留**作为历史参考，以后可能放入 deprecated
- `daily-report` → 保持独立
- `/master-prj learn` 目前对 learn-log 已有逻辑覆盖不够（缺少防污染红线、阶段 0 信息收集等），后续需补强

## 目标场景

master-prj 为 **master-xxx** 类项目设计：初次接触某项技术时，创建一个学习项目进行结构化深入掌握。这类项目的特点：

- 个人自用，单仓库，不需要分支隔离
- 以"学一个做一个"的节奏推进
- 需要快速开始，不需要过多配置

参考项目：`D:\prj\master-vllm`（vLLM 技术学习）、`D:\prj\smart-community`（复杂项目，催生了 learn-log 的分支隔离机制，但对 master-prj 目标场景过于臃肿）

## 设计参考

| 项目 | 经验来源 |
|------|------|
| **master-vllm** | learn-log + ops-log + pause-learn + pitfall 四个 skill 各自独立暴露出 80% 逻辑重复；learn 和 ops 割裂 |
| **dev-cookbook** | faq 的"无参数=列表，有参数=搜索"模式复用为 `/master-prj ref`；checkpoint 的通用化版本是典范 |

## 文件

| 文件 | 说明 |
|------|------|
| `SKILL.md` | `/master-prj` 命令的完整定义 |
| `README.md` | 本文件 — 设计决策记录 |
