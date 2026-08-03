#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 03 - Integrate SuSFS"
echo "========================================"
echo ""

cd "${KERNEL_DIR}"

############################################################
# Check files
############################################################

echo "[1/6] Checking SuSFS files..."

FILES=(
    "${SUSFS_C}"
    "${SUSFS_H}"
    "${PATCH_KERNEL}/50_add_susfs_in_kernel-4.19.patch"
)

for FILE in "${FILES[@]}"
do
    if [ ! -f "$FILE" ]; then
        echo "[ERROR] Missing:"
        echo "        $FILE"
        exit 1
    fi
done

echo "[ OK ]"

############################################################
# Install susfs.c / susfs.h
############################################################

echo ""
echo "[2/6] Installing SuSFS..."

mkdir -p fs
mkdir -p include/linux

cp -f "${SUSFS_C}" fs/
cp -f "${SUSFS_H}" include/linux/

echo "[ OK ]"

############################################################
# Normalize patches
############################################################

echo ""
echo "[3/6] Normalizing patches..."

find "${PATCH_KERNEL}" \
-name "*.patch" \
-exec sed -i 's/\r$//' {} \;

echo "[ OK ]"

############################################################
# Apply kernel patch
############################################################

echo ""
echo "[4/6] Applying kernel patch..."

mkdir -p "${DEBUG_DIR}"

PATCH_LOG="${DEBUG_DIR}/kernel_patch.log"

if git apply \
    --3way \
    --whitespace=nowarn \
    "${PATCH_KERNEL}/50_add_susfs_in_kernel-4.19.patch" \
    >"${PATCH_LOG}" 2>&1
then

    echo "[ OK ]"

else

    echo "[WARNING] Patch not fully applied."

    echo "Searching reject files..."

    find . -name "*.rej" \
        -exec cp --parents {} "${DEBUG_DIR}" \; || true

    find . -name "*.orig" \
        -exec cp --parents {} "${DEBUG_DIR}" \; || true

    echo ""
    echo "Patch report saved:"
    echo "${PATCH_LOG}"

    exit 1

fi

############################################################
# Verify
############################################################

echo ""
echo "[5/6] Checking installation..."

test -f fs/susfs.c
test -f include/linux/susfs.h

echo "[ OK ]"

############################################################
# Finish
############################################################

echo ""
echo "[6/6] Finished"

echo ""
echo "========================================"
echo " SuSFS Ready"
echo "========================================"
