#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 08 - Collect Logs"
echo "========================================"

mkdir -p "${DEBUG_DIR}"

echo "[INFO] Saving environment..."

date > "${DEBUG_DIR}/date.txt"

uname -a > "${DEBUG_DIR}/uname.txt"

clang --version > "${DEBUG_DIR}/clang.txt" 2>/dev/null || true

gcc --version > "${DEBUG_DIR}/gcc.txt" 2>/dev/null || true

git --version > "${DEBUG_DIR}/git.txt"

echo "[INFO] Saving kernel information..."

if [ -d "${KERNEL_DIR}/.git" ]; then

    cd "${KERNEL_DIR}"

    git branch --show-current \
        > "${DEBUG_DIR}/kernel_branch.txt"

    git rev-parse HEAD \
        > "${DEBUG_DIR}/kernel_commit.txt"

    git log -5 --oneline \
        > "${DEBUG_DIR}/kernel_last5.txt"

fi

echo "[INFO] Searching rejects..."

find "${KERNEL_DIR}" -name "*.rej" \
    > "${DEBUG_DIR}/rejects.txt" || true

find "${KERNEL_DIR}" -name "*.orig" \
    > "${DEBUG_DIR}/orig.txt" || true

echo "[INFO] Build output..."

find "${BUILD_DIR}" \
    > "${DEBUG_DIR}/build_tree.txt"

echo ""
echo "========================================"
echo " Debug Ready"
echo "========================================"
