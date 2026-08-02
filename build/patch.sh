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

if ! git apply \
    --3way \
    --whitespace=nowarn \
    "${PATCH_DIR}/50_add_susfs_in_kernel-4.19.patch"
then
    echo ""
    echo "===================================="
    echo " PATCH FAILED - Collecting debug files"
    echo "===================================="

    mkdir -p "${PROJECT_ROOT}/debug"

    echo "[INFO] Saving context..."

    sed -n '340,460p' fs/open.c \
        > "${PROJECT_ROOT}/debug/open_context.txt" || true

    sed -n '1,80p' fs/proc/task_mmu.c \
        > "${PROJECT_ROOT}/debug/task_mmu_context.txt" || true

    find . -name "*.rej" -exec cp --parents {} "${PROJECT_ROOT}/debug/" \; || true
    find . -name "*.orig" -exec cp --parents {} "${PROJECT_ROOT}/debug/" \; || true

    echo ""
    echo "[INFO] Debug files saved in:"
    echo "${PROJECT_ROOT}/debug"

    exit 1
fi

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

if ! git apply \
    --3way \
    --whitespace=nowarn \
    "${PATCH_DIR}/10_enable_susfs_for_ksu.patch"
then
    echo "[ERROR] Failed to apply KernelSU patch."
    exit 1
fi

cd ../..

echo "[OK] ReSuKiSU patched."

echo "===================================="
echo " Patch stage finished"
echo "===================================="
