#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 01 - Clone Kernel"
echo "========================================"
echo ""

#
# Clone or update kernel
#
if [ ! -d "${KERNEL_DIR}/.git" ]; then

    echo "[INFO] Cloning kernel..."

    git clone \
        --depth=1 \
        --branch "${KERNEL_BRANCH}" \
        "${KERNEL_REPO}" \
        "${KERNEL_DIR}"

else

    echo "[INFO] Existing kernel detected."

    cd "${KERNEL_DIR}"

    git fetch origin

    git checkout "${KERNEL_BRANCH}"

    git reset --hard "origin/${KERNEL_BRANCH}"

fi

cd "${KERNEL_DIR}"

echo ""
echo "[INFO] Repository"

echo "Branch : $(git branch --show-current)"
echo "Commit : $(git rev-parse --short HEAD)"

echo ""
echo "[INFO] Saving build information..."

mkdir -p "${DEBUG_DIR}"

git rev-parse HEAD > "${DEBUG_DIR}/kernel_commit.txt"
git branch --show-current > "${DEBUG_DIR}/kernel_branch.txt"

git log -1 --oneline > "${DEBUG_DIR}/kernel_last_commit.txt"

echo ""
echo "========================================"
echo " Kernel Ready"
echo "========================================"
