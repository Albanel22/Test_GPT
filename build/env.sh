#!/usr/bin/env bash
set -euo pipefail

# ========= Project =========
export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# ========= Device ==========
export DEVICE="kiev"

# ========= Kernel ==========
export KERNEL_REPO="https://github.com/LineageOS/android_kernel_motorola_sm8250.git"
export KERNEL_BRANCH="lineage-23.2"
export KERNEL_DIR="${PROJECT_ROOT}/kernel_src"

# ========= Build ===========
export BUILD_DIR="out"
export ARCH="arm64"
export SUBARCH="arm64"
export DEFCONFIG="lito-perf_defconfig"

# ========= Toolchain =======
export CC=clang
export LLVM=1
export LLVM_IAS=1
export CROSS_COMPILE=aarch64-linux-gnu-
export CCACHE_DIR="$HOME/.cache/ccache"

# ========= Project files ===
export PATCH_DIR="${PROJECT_ROOT}/patches"
export SUSFS_C="${PROJECT_ROOT}/susfs.c"
export SUSFS_H="${PROJECT_ROOT}/susfs.h"
export PERFECT_DEFCONFIG="${PROJECT_ROOT}/kiev_perfect_defconfig"

# ========= Output ==========
export ANYKERNEL_DIR="${PROJECT_ROOT}/anykernel"
export ZIP_NAME="ReSuKiSU-AnyKernel3-kiev.zip"
