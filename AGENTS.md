# AGENTS.md

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
> **判定标准**：若思考链或回复中出现连续多个英文单词组成的句子（非代码/技术名词/命令），即视为违反本铁律，必须改为中文重新生成。

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

- 本项目已按 dev-cookbook `project-init` 初始化：13 个精选技能部署在 `.claude/skills/`（Claude Code 生态，skill-sync / checkpoint 等工具链的默认位置）。
- 同时以逐字节副本置于 **`.dsh/skills/`**（DeepSeek Harness / dsh 识别并实时加载的项目级技能目录，rank 100；`.agents/skills/` 亦可被识别）。`/checkpoint`、`/skill-sync`、`/pitfall`、`/daily-report` 等在此环境直接可用。
- 维护约定：以 `.claude/skills/` 为操作真源（供 dev-cookbook 工具同步）；同步后执行 `cp -r .claude/skills/. .dsh/skills/` 保持两份一致。
- 不部署 `.opencode/command/`（opencode 专用，对本环境无效）。

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
