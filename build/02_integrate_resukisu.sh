#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 02 - Integrate ReSuKiSU"
echo "========================================"
echo ""

cd "${KERNEL_DIR}"

#
# Remove previous installation
#
if [ -d "drivers/kernelsu" ]; then
    echo "[INFO] Removing previous ReSuKiSU..."
    rm -rf drivers/kernelsu
fi

#
# Clone ReSuKiSU
#
echo "[INFO] Cloning ReSuKiSU..."

git clone \
    --depth=1 \
    --branch "${KSU_BRANCH}" \
    "${KSU_REPO}" \
    drivers/kernelsu

echo "[OK] Clone completed."

#
# Collect information
#
echo ""
echo "[INFO] Collecting version..."

cd drivers/kernelsu

echo "Repository : ${KSU_REPO}" \
    > "${DEBUG_DIR}/resukisu_info.txt"

echo "Branch : $(git branch --show-current)" \
    >> "${DEBUG_DIR}/resukisu_info.txt"

echo "Commit : $(git rev-parse HEAD)" \
    >> "${DEBUG_DIR}/resukisu_info.txt"

git log -1 --oneline \
    >> "${DEBUG_DIR}/resukisu_info.txt"

#
# Check setup.sh
#
echo ""

if [ -f setup.sh ]; then
    echo "[INFO] setup.sh found."
else
    echo "[WARNING] setup.sh not found."
fi

echo ""
echo "========================================"
echo " ReSuKiSU Ready"
echo "========================================"
