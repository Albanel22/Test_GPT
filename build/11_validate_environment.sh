#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 11 - Validate Environment"
echo "========================================"

echo ""

echo "Project : $PROJECT_ROOT"
echo "Device  : $DEVICE"
echo "Kernel  : $KERNEL_BRANCH"

echo ""

clang --version | head -1 || true

gcc --version | head -1 || true

git --version

echo ""

df -h .

echo ""

free -h || true

echo ""

echo "Environment OK"
