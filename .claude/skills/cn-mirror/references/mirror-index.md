# 国内镜像索引

> `/cn-mirror` 的内部知识库（唯一权威）。
> 状态：✅ 正常 / ⚠️ 不稳定 / ❌ 失效。
> 最后验证: 2026-09-10（Docker Hub / Docker CE / NVIDIA Container Toolkit 实测）；Flutter SDK / pub.dev / GitHub 条目为 2026-09 项目实践汇总

---

## pip / PyPI

- **官方源**: https://pypi.org/simple/
- **国内镜像**: https://mirrors.aliyun.com/pypi/simple/（首选）| https://pypi.tuna.tsinghua.edu.cn/simple/（备选）
- **状态**: ✅
- **配置**: `pip config set global.index-url <url>`；CI/脚本用 `export PIP_INDEX_URL=<url>`
- **uv 注意**: uv 不读 pip 配置，用环境变量 `export UV_DEFAULT_INDEX=https://mirrors.aliyun.com/pypi/simple/`
- **备注**: 安装前必配，不配镜像 pip 下载极慢（实测教训）

---

## HuggingFace 模型

- **官方源**: https://huggingface.co
- **国内镜像**: https://hf-mirror.com
- **状态**: ⚠️（大文件经 Xet 桥 `cas-bridge.xethub.hf.co` 传输不稳，401/断连复发）
- **配置**: `export HF_ENDPOINT=https://hf-mirror.com`
- **备注**: 国产模型（Qwen/DeepSeek/GLM）优先 ModelScope，比 hf-mirror 快且稳（实测 30min vs 8h）

---

## ModelScope（国产模型替代源）

- **官方源**: 无（国内原生服务，阿里 CDN）
- **国内镜像**: https://modelscope.cn
- **状态**: ✅
- **配置**: `pip install modelscope` → `modelscope download --model <id> --local_dir <dir>`
- **备注**: Qwen/DeepSeek/GLM/PaddleOCR 下载首选；需 CLI 或 SDK，不能像 HF 一样替换环境变量就走

---

## Docker Hub 镜像

- **官方源**: registry-1.docker.io（**直连被墙：2026-09-10 实测 TIMEOUT**）
- **国内镜像**:
  - https://docker.m.daocloud.io（首选，**2026-09-10 实测真实可用**：pull 大镜像（lmsysorg/sglang:dev，~14GB）稳定下载）
  - https://docker.1ms.run（备选，2026-09-10 探活 401 正常）
  - https://dockerproxy.net | https://proxy.vvvv.ee | https://dockerproxy.link（旧候选，未复验）
- **状态**: ✅（2026-09-10 实测；注意 DaoCloud 新域名 `docker.m.daocloud.io` 已复活，与 2026-07 记录的"DaoCloud 死亡"不同）
- **配置**:
  - Docker：daemon.json 中设置 `"registry-mirrors": ["<url>"]`，Docker Desktop 在 Settings → Docker Engine 中配置；配后 `systemctl restart docker` + `docker info | grep -A2 "Registry Mirrors"` 验证
  - Podman：`/etc/containers/registries.conf`：
    ```toml
    [[registry]]
    location = "docker.io"
    [[registry.mirror]]
    location = "docker.m.daocloud.io"
    ```
- **备注**: 透明代理模式不改变镜像名，与 pip 的 index-url 不同；多个镜像同时配以增加成功率；若全部不可用则走内网 `docker save`/`scp`/`docker load`。**首次 pull 慢/卡时可 kill 后重试（docker 会自动换 CDN 节点）**

---

## quay.io 容器镜像

- **官方源**: https://quay.io
- **国内镜像**: https://quay.m.daocloud.io（DaoCloud，首选）| https://quay.nju.edu.cn（南京大学，备选）
- **状态**: ✅（2026-08-13 调研复核：DaoCloud public-image-mirror 官方支持 quay.io mirror；南大镜像站有效）
- **配置**: podman `/etc/containers/registries.conf`：
  ```toml
  [[registry]]
  location = "quay.io"
  [[registry.mirror]]
  location = "quay.m.daocloud.io"
  ```
- **备注**: quay.io 来源镜像（Ceph、Prometheus、Grafana 等官方镜像）适用；测速 `podman pull quay.io/ceph/ceph:v20.2.3`

---

## Docker CE APT 源

- **官方源**: https://download.docker.com
- **国内镜像**: https://mirrors.aliyun.com/docker-ce/linux/ubuntu
- **状态**: ✅（2026-09-10 实测安装 docker-ce 5:29.8.0 成功）
- **配置**: 写入 `/etc/apt/sources.list.d/docker.list`（deb 行 + GPG key）
- **备注**: Docker 官方站被墙，安装 Docker 必换此源。**坑（2026-09-10 实测）**：apt 的 https method 可能连到异常 CDN 节点后无响应卡死（15min+，`WCHAN=do_select`、连接 ESTAB 无数据）；处置 = kill 后重试（自动换节点），或给 apt 加 `-o Acquire::https::Timeout=20 -o Acquire::Retries=3`

---

## NVIDIA Container Toolkit（docker --gpus 前置）

- **官方源**: https://nvidia.github.io/libnvidia-container
- **国内镜像**: https://mirrors.ustc.edu.cn/libnvidia-container/（中科大，**2026-09-10 实测安装 nvidia-container-toolkit 1.20.0 成功**；清华同路径 404 不可用）
- **状态**: ✅
- **配置**（中科大）:
  ```bash
  curl -fsSL https://mirrors.ustc.edu.cn/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://mirrors.ustc.edu.cn/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed -e 's#nvidia.github.io/libnvidia-container#mirrors.ustc.edu.cn/libnvidia-container#g' \
        -e 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    > /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt-get update && apt-get install -y nvidia-container-toolkit
  ```
- **备注**: 镜像 list 文件内 URL 仍指向官方域名，**必须 sed 重写**；装后需 `nvidia-ctk runtime configure --runtime=docker && systemctl restart docker`（重启 docker 会打断进行中的 pull，先完成 pull 再配）

---

## Ubuntu APT 源

- **官方源**: https://archive.ubuntu.com
- **国内镜像**: https://mirrors.aliyun.com/ubuntu/（首选）| https://mirrors.tuna.tsinghua.edu.cn/ubuntu/（备选）
- **状态**: ✅
- **配置**: 24.04 用 deb822 格式 `/etc/apt/sources.list.d/ubuntu.sources`（不是 `sources.list`）；新旧格式只留一种，否则 `apt update` 无源可用
- **备注**: 换源细节见项目运维手册相关章节

---

## npm

- **官方源**: https://registry.npmjs.org
- **国内镜像**: https://registry.npmmirror.com
- **状态**: ✅
- **配置**: `npm config set registry https://registry.npmmirror.com`
- **备注**: 也可用 `.npmrc` 文件写入 `registry=https://registry.npmmirror.com`

---

## Rust crates

- **官方源**: https://crates.io（sparse index）
- **国内镜像**: https://rsproxy.cn（字节，首选）| https://mirrors.tuna.tsinghua.edu.cn/crates.io-index（清华，备选）
- **状态**: ✅
- **配置**: `~/.cargo/config.toml`：
  ```toml
  [source.crates-io]
  replace-with = "rsproxy-sparse"

  [source.rsproxy-sparse]
  registry = "sparse+https://rsproxy.cn/index/"
  ```
- **备注**: 必须用 sparse 协议，配错 index 协议会回退直连 crates.io

---

## Flutter SDK（storage.googleapis.com）

- **官方源**: https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/
- **国内镜像**: https://storage.flutter-io.cn（Flutter 中国社区镜像，对应 storage.googleapis.com）
- **状态**: ✅
- **配置**（两种方式）:
  - 下载 tarball 时直改 URL 前缀：`https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_<ver>-stable.tar.xz`
  - 或 `export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`
- **备注**: SDK 获取有 git clone（GitHub）或 tarball（storage）两条路；git clone 走下方 GitHub 镜像

---

## pub.dev（Dart/Flutter 依赖包）

- **官方源**: https://pub.dev
- **国内镜像**: https://pub.flutter-io.cn
- **状态**: ✅
- **配置**: `export PUB_HOSTED_URL=https://pub.flutter-io.cn` + `export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`（写入 `~/.bashrc` 或 `/etc/environment` 持久化）
- **备注**: `flutter pub get` 慢/超时先查此镜像；`flutter create` 后首次 pub get 必走

---

## GitHub（git clone 加速）

- **官方源**: https://github.com
- **国内镜像**: https://ghproxy.com / https://gh-proxy.com / https://mirror.ghproxy.com（代理类，前缀拼在 git URL 前）｜ gitclone.com（仅 clone）
- **状态**: ⚠️（代理类镜像时好时坏，需实测）
- **配置**: `git clone https://gh-proxy.com/https://github.com/<org>/<repo>.git`
- **备注**: 仅用于 git clone / 文件下载加速；如代理失效，检查是否有新的活跃域名
