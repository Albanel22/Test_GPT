#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 13 - Cleanup"
echo "========================================"

rm -rf "${BUILD_DIR}" || true

mkdir -p "${BUILD_DIR}"

find "${DEBUG_DIR}" -type f -delete 2>/dev/null || true

if [ -d "${KERNEL_DIR}/.git" ]; then

cd "${KERNEL_DIR}"

git reset --hard

git clean -fd

fi

echo "Cleanup completed."
