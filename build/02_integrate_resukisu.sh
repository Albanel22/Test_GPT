#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 02 - Install ReSuKiSU"
echo "========================================"

cd "${KERNEL_DIR}"

echo "[INFO] Installing ReSuKiSU..."

curl -LSs \
"https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" \
| bash

echo ""

echo "[OK] ReSuKiSU installed."
