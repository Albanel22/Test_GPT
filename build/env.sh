#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Test-GPT v2
# Global environment
# ==========================================================

# -------- Project --------

export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

export BUILD_DIR="${PROJECT_ROOT}/out"
export DEBUG_DIR="${PROJECT_ROOT}/debug"

mkdir -p "${BUILD_DIR}"
mkdir -p "${DEBUG_DIR}"

# -------- Device --------

export DEVICE="kiev"

# -------- Kernel --------

export KERNEL_REPO="https://github.com/LineageOS/android_kernel_motorola_sm8250.git"
export KERNEL_BRANCH="lineage-23.2"

export KERNEL_DIR="${PROJECT_ROOT}/kernel"

# -------- Kernel Config --------

export ARCH=arm64
export SUBARCH=arm64
export DEFCONFIG=lito-perf_defconfig

# -------- Toolchain --------

export CC=clang

export LLVM=1
export LLVM_IAS=1

export CROSS_COMPILE=aarch64-linux-gnu-

export CCACHE_DIR="$HOME/.ccache"

# -------- KernelSU --------

export KSU_REPO="https://github.com/ReSukiSU/ReSukiSU.git"

# ⚠️ provisoire
# sera remplacé après validation de la bonne version
export KSU_BRANCH="main"

export KSU_DIR="${KERNEL_DIR}/drivers/kernelsu"

# -------- SUSFS --------

export SUSFS_C="${PROJECT_ROOT}/susfs.c"
export SUSFS_H="${PROJECT_ROOT}/susfs.h"

# -------- Patches --------

#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# Test-GPT v2
# Global environment
# ==========================================================

# -------- Project --------

export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

export BUILD_DIR="${PROJECT_ROOT}/out"
export DEBUG_DIR="${PROJECT_ROOT}/debug"

mkdir -p "${BUILD_DIR}"
mkdir -p "${DEBUG_DIR}"

# -------- Device --------

export DEVICE="kiev"

# -------- Kernel --------

export KERNEL_REPO="https://github.com/LineageOS/android_kernel_motorola_sm8250.git"
export KERNEL_BRANCH="lineage-23.2"

export KERNEL_DIR="${PROJECT_ROOT}/kernel"

# -------- Kernel Config --------

export ARCH=arm64
export SUBARCH=arm64
export DEFCONFIG=lito-perf_defconfig

# -------- Toolchain --------

export CC=clang

export LLVM=1
export LLVM_IAS=1

export CROSS_COMPILE=aarch64-linux-gnu-

export CCACHE_DIR="$HOME/.ccache"

# -------- KernelSU --------

export KSU_REPO="https://github.com/ReSukiSU/ReSukiSU.git"

# ⚠️ provisoire
# sera remplacé après validation de la bonne version
export KSU_BRANCH="main"

export KSU_DIR="${KERNEL_DIR}/drivers/kernelsu"

# -------- SUSFS --------

export SUSFS_C="${PROJECT_ROOT}/susfs.c"
export SUSFS_H="${PROJECT_ROOT}/susfs.h"

# -------- Patches --------

# -------- Patches --------

export PATCH_ROOT="${PROJECT_ROOT}/patches"

# Les patches sont actuellement tous dans le même dossier
export PATCH_KERNEL="${PATCH_ROOT}"
export PATCH_KSU="${PATCH_ROOT}"
export PATCH_DEVICE="${PATCH_ROOT}"

# -------- AnyKernel --------

export ANYKERNEL_DIR="${PROJECT_ROOT}/AnyKernel3"

export ZIP_NAME="TestGPT-${DEVICE}.zip"

echo ""
echo "========================================"
echo " Test-GPT v2"
echo "========================================"

echo "Project : ${PROJECT_ROOT}"
echo "Kernel  : ${KERNEL_BRANCH}"
echo "Device  : ${DEVICE}"
echo ""


# -------- AnyKernel --------

export ANYKERNEL_DIR="${PROJECT_ROOT}/AnyKernel3"

export ZIP_NAME="TestGPT-${DEVICE}.zip"

echo ""
echo "========================================"
echo " Test-GPT v2"
echo "========================================"

echo "Project : ${PROJECT_ROOT}"
echo "Kernel  : ${KERNEL_BRANCH}"
echo "Device  : ${DEVICE}"
echo ""
