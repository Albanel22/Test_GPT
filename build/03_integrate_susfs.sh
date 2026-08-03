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

echo ""
echo "========================================"
echo " PATCH FAILED"
echo "========================================"

echo ""
echo "----- git apply output finished -----"

echo ""
echo "Searching reject/orig files..."

find . -name "*.rej" | while read f; do
    echo ""
    echo "========================================"
    echo "REJECT FILE: $f"
    echo "========================================"
    cat "$f"
done

find . -name "*.orig" | while read f; do
    echo ""
    echo "========================================"
    echo "ORIGINAL FILE: $f"
    echo "========================================"
    sed -n '1,250p' "$f"
done

echo ""
echo "========================================"
echo "git diff"
echo "========================================"

git diff --stat || true
git diff || true

exit 1

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
