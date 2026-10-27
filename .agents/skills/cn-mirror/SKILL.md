---
name: cn-mirror
description: 国内镜像配置记录。将项目用到的国内镜像写入 docs/cn-mirror.md 并在 CLAUDE.md 建立引用，保证安装下载前自动优先国内源。自动去重更新，标记失效镜像。
---

# 国内镜像配置记录

把"这个项目要用哪些国内镜像、怎么配"固化成项目文件，让 Claude 每次会话都能读到。**任何下载/安装/获取资源时，默认优先走镜像**——加速下载，避免直连被墙。

**铁律：任何下载、安装、获取资源（pip/npm/apt/docker pull/huggingface 模型等），默认优先使用国内镜像源。**
除非用户明确要求用官方源，或镜像不可用。

## 调用时机

- 项目首次配置国内镜像，或进入新的环境搭建阶段
- 对话中出现下载/安装命令，项目还没有对应生态的镜像记录
- 下载超时、反复失败，疑似镜像问题
- 用户报告某镜像站失效或换新地址

## 入口

```
CLAUDE.md 已有「国内镜像配置」章节？
  ├─ 否 → 【初始化】新增 CLAUDE.md 引用章节 + 创建 docs/cn-mirror.md
  └─ 是 → 按参数操作 docs/cn-mirror.md（列出/新增/更新/探活）
```

## 调用方式

```
/cn-mirror                无参：首次→初始化双文件；已有→列出镜像
/cn-mirror add [生态]      添加/更新指定生态的镜像（从 references/mirror-index.md 取数据）
/cn-mirror ls             列出 docs/cn-mirror.md 中已有镜像记录
/cn-mirror check [生态]    联网探活验证镜像可用性（需用户同意）
/cn-mirror ?               显示帮助
```

## 步骤

### 步骤 1: 读取现状

读 CLAUDE.md，搜索是否已有「国内镜像配置」章节（及其变体：`国内镜像` / `镜像配置` / `国内源` / `镜像加速`）：

- **有** → 标记"已初始化"，**不修改 CLAUDE.md**，跳到步骤 3
- **无** → 标记"首次"，继续步骤 2

### 步骤 2: 写入 CLAUDE.md 引用章节（仅首次）

在 CLAUDE.md 中追加以下内容：

```markdown
## 国内镜像配置

> 由 `/cn-mirror` 维护，详细记录见 [docs/cn-mirror.md](docs/cn-mirror.md)。

**规则：任何下载、安装、获取资源（pip/npm/apt/docker pull/huggingface 模型等），默认优先使用国内镜像源。**
- 先从 [docs/cn-mirror.md](docs/cn-mirror.md) 查找对应生态的镜像地址
- 镜像不可用或用户明确要求官方源时，才走官方
- 目的：加速下载，避免直连被墙
```

插入位置：
- 存在 `## 常用命令` → 插在其前一行
- 不存在 → 追加到文件末尾
- CLAUDE.md 不存在 → 创建并写入

### 步骤 3: 读取模板索引

读取 `references/mirror-index.md`（本 skill 自带，模板分发时已包含）。获取所有生态条目及当前状态（✅/⚠️/❌）。

如果文件缺失，报告错误并建议重新从模板拷贝本 skill。

### 步骤 4: 操作 docs/cn-mirror.md

`docs/cn-mirror.md` 不存在？
- **是（首次）→ 创建**。询问项目实际用到哪些生态（列出索引中的全部生态，用户多选，默认全选），将所选生态写入

`docs/cn-mirror.md` 已存在？
- **无参** → 列出已有镜像记录摘要（生态、镜像 URL、状态）
- **`/cn-mirror add 生态名`** → 从索引读取该生态数据，在 `docs/cn-mirror.md` 中：
  - 该生态已有记录 → 更新 URL/状态/备注（按生态 key 匹配，不重复追加）
  - 该生态无记录 → 在文件末尾追加新条目
- **`/cn-mirror ls`** → 显示全部已有记录
- **`/cn-mirror check [生态]`** → 步骤 5

### 步骤 5: 探活（check）

**仅在用户明确调用 `/cn-mirror check [生态]` 时执行。**

征得用户同意后，对该生态的镜像 URL 逐个 `curl -sI --connect-timeout 5 --max-time 10` 试探：

- 返回 2xx/3xx → 保持 ✅
- 超时/连接拒绝 → 标 ⚠️ + 日期
- 累计 3 次以上 ⚠️ 或用户确认 → 标 ❌ + 日期

结果回写 `docs/cn-mirror.md` 中该生态的状态行。

### 步骤 6: 报告

输出操作结果：新增 X 条 / 更新 Y 条 / 未动 Z 条，并展示当前所有镜像记录摘要表格。

## 原则

- **镜像优先**：CLAUDE.md 中的行为规则确保 Claude 每次会话自动走镜像
- **双文件分离**：CLAUDE.md 只放规则+引用指针，实际数据在 `docs/cn-mirror.md`，避免 CLAUDE.md 膨胀
- **按生态 key 合并更新**：绝不盲追加，同一生态已有记录则原地更新
- **失效镜像不留坑**：❌ 镜像不写 URL，只写替代方案
- **不主动联网**：check 模式必须经用户明确同意；单次失败 ≠ 失效（记 ⚠️ 不记 ❌）
- **所有文件操作限制在项目目录内**
- **索引是权威**：`references/mirror-index.md` 是知识来源，CLAUDE.md 和 `docs/cn-mirror.md` 是其项目子集/副本
