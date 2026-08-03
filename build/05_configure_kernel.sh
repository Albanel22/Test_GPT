#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 05 - Configure Kernel"
echo "========================================"

cd "${KERNEL_DIR}"

#
# Clean previous config
#
echo "[1/7] Cleaning previous configuration..."

make O="${BUILD_DIR}" mrproper

echo "[ OK ]"

#
# Generate defconfig
#
echo ""
echo "[2/7] Generating ${DEFCONFIG}..."

make \
    O="${BUILD_DIR}" \
    ARCH="${ARCH}" \
    LLVM=1 \
    LLVM_IAS=1 \
    "${DEFCONFIG}"

echo "[ OK ]"

CONFIG="${BUILD_DIR}/.config"

if [ ! -f "${CONFIG}" ]; then
    echo "[ERROR] .config not generated."
    exit 1
fi

#
# Helper
#
enable_config() {

    local CFG="$1"

    if grep -q "^# ${CFG} is not set" "${CONFIG}"; then

        sed -i "s/^# ${CFG} is not set/${CFG}=y/" "${CONFIG}"

    elif grep -q "^${CFG}=" "${CONFIG}"; then

        sed -i "s/^${CFG}=.*/${CFG}=y/" "${CONFIG}"

    else

        echo "${CFG}=y" >> "${CONFIG}"

    fi

}

echo ""
echo "[3/7] Enabling KernelSU..."

enable_config CONFIG_KSU
enable_config CONFIG_KSU_MANUAL_HOOK

echo "[ OK ]"

echo ""
echo "[4/7] Enabling SuSFS..."

enable_config CONFIG_KSU_SUSFS
enable_config CONFIG_KSU_SUSFS_SUS_PATH
enable_config CONFIG_KSU_SUSFS_SPOOF_UNAME
enable_config CONFIG_KSU_SUSFS_ENABLE_LOG

echo "[ OK ]"

echo ""
echo "[5/7] Required filesystem options..."

enable_config CONFIG_TMPFS
enable_config CONFIG_TMPFS_XATTR
enable_config CONFIG_OVERLAY_FS

echo "[ OK ]"

echo ""
echo "[6/7] Saving configuration..."

cp "${CONFIG}" \
"${DEBUG_DIR}/kernel.config"

echo "[ OK ]"

echo ""
echo "[7/7] Configuration summary"

grep CONFIG_KSU "${CONFIG}" || true
grep CONFIG_KSU_SUSFS "${CONFIG}" || true
grep CONFIG_TMPFS "${CONFIG}" || true
grep CONFIG_OVERLAY_FS "${CONFIG}" || true

echo ""
echo "========================================"
echo " Kernel Config Ready"
echo "========================================"
