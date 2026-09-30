#!/usr/bin/env bash
# Wrapper for the flutter tool: invokes the prebuilt flutter_tools snapshot with a
# workspace-local shadow FLUTTER_ROOT so the tool never needs to write into the
# real SDK at /home/dev/flutter (which the sandbox keeps read-only).
# Usage: ./fl.sh <flutter args...>
set -euo pipefail
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PUB_CACHE=/home/dev/prj/flutter_lib/.pub-cache
export FLUTTER_ROOT=/home/dev/prj/flutter_lib/.flutter-root
exec /home/dev/flutter/bin/cache/dart-sdk/bin/dart \
  /home/dev/flutter/bin/cache/flutter_tools.snapshot \
  --suppress-analytics --no-version-check "$@"
