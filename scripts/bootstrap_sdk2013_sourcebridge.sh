#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_DIR="${ROOT_DIR}/third_party/source-sdk-2013"

if [[ ! -d "${SDK_DIR}" ]]; then
  git clone https://github.com/ValveSoftware/source-sdk-2013.git "${SDK_DIR}"
fi

mkdir -p "${SDK_DIR}/sp/src/game/client/sourcebridge"
cp -f "${ROOT_DIR}/sdk2013_overlay/game/client/sourcebridge/SourceBridgeMainMenuPanel.h" "${SDK_DIR}/sp/src/game/client/sourcebridge/"
cp -f "${ROOT_DIR}/sdk2013_overlay/game/client/sourcebridge/SourceBridgeMainMenuPanel.cpp" "${SDK_DIR}/sp/src/game/client/sourcebridge/"

mkdir -p "${SDK_DIR}/sp/game/mod_hl2/resource/ui"
cp -f "${ROOT_DIR}/sdk2013_overlay/game/client/sourcebridge/SourceBridgeMainMenuPanel.res" "${SDK_DIR}/sp/game/mod_hl2/resource/ui/"

echo "SourceBridge base files copied into ${SDK_DIR}"
