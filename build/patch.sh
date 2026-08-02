#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "===================================="
echo " Applying ReSuKiSU + SUSFS"
echo "===================================="

cd "${KERNEL_DIR}"

#
# Verify project files
#
for f in \
    "${SUSFS_C}" \
    "${SUSFS_H}" \
    "${PATCH_DIR}/50_add_susfs_in_kernel-4.19.patch" \
    "${PATCH_DIR}/10_enable_susfs_for_ksu.patch"
do
    if [ ! -f "$f" ]; then
        echo "[ERROR] Missing: $f"
        exit 1
    fi
done

echo "[OK] Project files found."

#
# Install SUSFS
#
mkdir -p include/linux

cp "${SUSFS_C}" fs/
cp "${SUSFS_H}" include/linux/

echo "[OK] SUSFS copied."

#
# Normalize patch files
#
find "${PATCH_DIR}" -name "*.patch" -exec sed -i 's/\r$//' {} \;

#
# Apply SUSFS kernel patch
#
echo "[INFO] Applying kernel patch..."

patch -p1 --forward \
    < "${PATCH_DIR}/50_add_susfs_in_kernel-4.19.patch"

#
# Install ReSuKiSU
#
rm -rf drivers/kernelsu

git clone \
    --depth=1 \
    https://github.com/resukisu/ResukiSU.git \
    drivers/kernelsu

echo "[OK] ReSuKiSU installed."

#
# Apply SUSFS support
#
cd drivers/kernelsu

patch -p1 \
    --forward \
    --fuzz=2 \
    < "${PATCH_DIR}/10_enable_susfs_for_ksu.patch"

cd ../..

echo "[OK] ReSuKiSU patched."

echo "===================================="
echo " Patch stage finished"
echo "===================================="
