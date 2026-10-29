# AGENTS.md

<!-- BEGIN: agent-conventions (managed by dev-cookbook) -->
> 适用范围：所有会话、所有项目。

## R1 范围克制

- 只做完成目标所必需的事。修改代码时不越界：不重构、不格式化、不新增无关依赖、不改无关文件。
- 如果目标本身必须重构、引入依赖或改多处，正常执行，不受最小化限制。
- 用户明确要求重构、引入依赖或扩大范围时，按要求执行。
- 一旦授权执行，直接按最小化原则做，不再反复确认。

## R2 敏感信息不存盘

- 密码、token、密钥等敏感信息不得写入项目：包括文件、日志、提交内容、临时产物。
- `.env` 等专门存放密钥的约定文件除外，按常规操作处理。
- 操作日志中不得出现密码等敏感信息。

## R3 中文化

- 你是中文母语的 AI 工程助手，所有输出必须使用简体中文，包括内部思考链、工具调用前后的分析总结、最终回复。
- 英文仅允许出现在技术名词、命令、JSON 键、代码、文件名、模型/服务名等原样引用中。
- 判定标准：出现连续多个英文单词组成的句子（非代码/技术名词/命令），即视为违规，必须改为中文重新生成。

## R4 不要被打断

- 工作过程中插入的对话，默认当作注释或待办，不打断当前任务，继续做到完成。
- 如果插入内容要求修改当前正在执行的动作（如改脚本、改命令、改方案），立即停止当前动作，修改后重新执行。
- 如果插入内容只是事后任务、提醒、补充信息，或与当前任务无关，继续当前工作，完成后再处理。
- 插入的是提问且不要求改变当前动作时，先继续当前任务，完成后再回答。

## R5 只陈述事实，不要语气

- 当要求输出微信留言、通知、简短留言等文本时，只陈述事实，保持简短。
- 不添加语气词、客套话、情绪化表达；不发挥，不创造不必要的语气或称谓。
- 不自行添加「亲」「您好」「辛苦了」「抱歉」等词，除非事实本身需要。

## R6 举例语义

- 当出现「举例」「比如」「类似」「等等」等词时，后面的内容是举例或方向说明，不是执行指令。
- 举例中的话题只表示可以探索/调查的方向，是否采用由实际情况判断；可以采用，也可以不采用。
- 举例可能出现在方案清单中，由你自行判断并给出方案；用户提供的是方向，不是必须执行的清单。
- 举例方案明显更优时，可以主动采用。

## R7 轮询时间

- 对跑脚本、长时间流程等需要等待的任务进行轮询。
- 一般场景每 1 分钟轮询一次；预计稍长时每 5 分钟一次；无人值守时每 10 分钟一次。
- 等待期间可以处理其他工作。
- 10 分钟不是任务上限；任务超过 10 分钟也继续轮询，直到完成。

## R8 先问再做

- 接到任务先确认目标、范围、输入与期望产出；优先提问澄清，不要闷头深入分析。
- 分析文件/代码前先判断问题需要多深：用户可能只问一个简单问题，不要沿文件无限展开、主动写长篇报告。
- 提问时只回答，不主动执行方案；只有明确指示「修改/执行」时才动手。
- 需要扩大分析范围时，先说明理由并征得同意。

## R9 随时汇报

- 每次操作说明：当前进展、下一步、为什么这样做。
- 长任务分段汇报，不静默执行；汇报简短，不堆砌过程日志。

## R10 条件不足即停

- 调查或执行前先检查必要条件（权限、数据、环境、依赖）。
- 条件不足且无法明确推理 → 立即停止，说明缺什么、需要用户提供什么；不猜测、不编造、不硬跑。
- 用户明确说明「全自动化运行」时：尽可能全程自动推进，不中断；遇到无法确认的条件，优先推理或跳过并记录；实在无法跳过或推理时才终止等待输入。
- 跳过必须记录，不能静默。
<!-- END: agent-conventions -->

本文件面向在此工作区工作的 AI 代理 / 开发者。工作区：`/home/dev/prj/flutter_lib`（WSL 环境）。

## 项目概述

- 仓库：`https://github.com/monkingame/flutter_lib.git`（monorepo，6 个独立 Flutter 包，**无根级 pubspec/workspace**）：
  - `dart-now-time-filename/`（生成时间戳文件名）
  - `byte_util/`（字节工具：readable↔bytes、base64、Byte/ByteWord/ByteDoubleWord/ByteArray）
  - `username/`（中英文随机用户名生成）
  - `modbus_protocol/`（Modbus CRC 计算；依赖 byte_util）
  - `websocket_daemon/`（WebSocket 守护连接 + 自动重连，ChangeNotifier）
  - `asset_button/`（图片按钮组件：ImageLoader / WidgetAssetImage / WidgetImageButton）
- 每个包结构：`lib/`（实现）、`test/`（测试）、`example/`（示例 app，`name: example`，`publish_to: none`，`path: ../` 依赖本包）。
- 已全部迁移到 Dart 3：SDK 约束格式 `sdk: ">=3.0.0 <4.0.0"`、`flutter: ">=3.0.0"`。
- 当前状态（迁移后）：6 个包 `pub get / analyze / test` 全绿，合计 **45 个测试**通过（1/20/8/6/5/5）。历史日志见 `baseline_log/`（含 `final/` 最终验证矩阵）。

## AI 技能目录（cookbook 初始化产物）

- 本项目已按 dev-cookbook `project-init` 初始化：13 个精选技能统一部署在 `.agents/skills/`（跨客户端标准目录）。
- 不再保留产品专属技能目录；dsh / opencode / Codex 均直接读取 `.agents/skills/`。
- 维护约定：以 `.agents/skills/` 为唯一真源，不再维护副本。

## 本机环境（重要约束）

- Flutter SDK：**`/home/dev/flutter`**（3.47.5 stable，Dart 3.13.4），安装在工作区之外，**只读使用、不得重装、不得复制进工作区**。`~/.bashrc` 已配置 PATH 与国内镜像。
- 国内镜像环境变量（每条命令都要设置）：
  - `PUB_HOSTED_URL=https://pub.flutter-io.cn`
  - `FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`
- **pub 缓存不要用默认 `~/.pub-cache`**：沙箱只允许写工作区。统一用 `PUB_CACHE=/home/dev/prj/flutter_lib/.pub-cache`。
- 沙箱：仅工作区可写；`/home/dev/flutter` 与 `$HOME` 在代理命令里不可写。
- **不能直接运行 `/home/dev/flutter/bin/flutter`**：flutter 启动脚本每次都要写 SDK 内的 `bin/cache/engine.stamp` 与 `bin/cache/lockfile`，在沙箱下直接报 `Read-only file system` 并退出。
- 禁止操作 `/mnt/*`（Windows 挂载，只读）；不要依赖 `/tmp` 跨步骤保存。

## 唯一正确的 flutter 调用方式：`./fl.sh`

`fl.sh`（工作区根目录）通过 `FLUTTER_ROOT` 指向工作区内的"影子 SDK 根"`.flutter-root/`，并直接 exec `flutter_tools` 快照，彻底绕开 SDK 目录写入：

```bash
./fl.sh pub get                # 主包 + example 自动连带解析
HOME=/home/dev/prj/flutter_lib/.home ./fl.sh analyze --no-pub
./fl.sh test --no-pub
```

要点：

- 影子根 `.flutter-root/`：`bin/cache/artifacts/` 与 `packages/flutter_tools/` 是**复制**（工具会写），`bin/cache/dart-sdk/`、`packages/flutter`、`packages/flutter_test`、`dev/`、`examples/` 是符号链接；`bin/cache/lockfile` 是工作区内的真实可写文件。**不要删 `.flutter-root/`**，删了所有 flutter 命令都跑不动。
- 如果看到 `cannot create lockfile` / `engine.stamp ... Read-only file system`，说明绕过了 `fl.sh` 直接调用了 flutter。
- **`flutter analyze` 额外需要** `HOME=/home/dev/prj/flutter_lib/.home`（analysis server 会把状态写到 `~/.dartServer`）；`pub get` / `test` 不需要。
- 改过 `pubspec.yaml` 之后必须先 `./fl.sh pub get`；`--no-pub` 表示跳过自动解析（依赖 `.dart_tool` 已存在）。
- 缓存失效排查：`rm -rf <pkg>/.dart_tool <pkg>/pubspec.lock` 后重新 `pub get`。

## 修改包时的例行验证

```bash
cd <pkg>
/home/dev/prj/flutter_lib/fl.sh pub get                                   # exit 0
HOME=/home/dev/prj/flutter_lib/.home /home/dev/prj/flutter_lib/fl.sh analyze --no-pub   # No issues found
/home/dev/prj/flutter_lib/fl.sh test --no-pub                             # All tests passed
```

## 包级特殊约定

- `modbus_protocol/pubspec.yaml`：对外依赖仍是 `byte_util: ^3.0.0`（保持发布元数据不变），另加 `dependency_overrides: byte_util: {path: ../byte_util}` 使本地开发使用本仓库升级后的 byte_util。该 override 不会随包发布。
- `asset_button/pubspec.yaml`：测试资源放在 `test/assets/`（tiny.png 4×4、tiny_crop.png 8×8），必须在 `flutter.assets` 中声明才能被 `rootBundle` 装载。
- `websocket_daemon`：`close()` 已有 `_closed` 守卫（close 后不重连、不 notify）；新增行为测试时不要移除。
- 各包 `example/pubspec.yaml` 的 SDK 约束必须与包同步（`flutter pub get` 会自动连带解析 example，约束不符会导致整条命令 exit 65）。
- 新 Flutter 工具链运行后会重生成 `example/windows/flutter/generated_plugin_registrant.*`（模板差异）与 `example/ios/Flutter/ephemeral/`。这些是生成物：**验证后应 `git checkout --` / 删除，保持交付 diff 聚焦**。

## 工作区规则

- 未经授权不发布 pub，未经授权不得修改本仓库之外的项目。
- 大文件直接下载到工作区（或提权后的目录）；不依赖 `/tmp`。
- 工作区可写路径之外的操作（如写 `/home/dev`）需提权并由用户审批；历史上有被拒记录（曾申请安装 Dart 2 时代 Flutter 3.7.12 被拒），不要重复该请求。

## 未完成 / 遗留事项

- 版本号与 CHANGELOG 未随 Dart 3 迁移更新（发布前需按 semver 处理并补 CHANGELOG）。
- 各包 `example/test/widget_test.dart` 仍是脚手架计数器测试（与示例应用不符）；不影响包级 analyze/test，但若有人单独在 `example/` 里跑 `flutter test` 会失败。
- 辅助/临时文件（未跟踪、未提交）：`.flutter-root/`（≈1.7GB，必需）、`.pub-cache/`、`.home/`、`baseline_log/`、`fl.sh`。
