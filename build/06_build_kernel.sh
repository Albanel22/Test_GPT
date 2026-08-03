#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 06 - Build Kernel"
echo "========================================"
echo ""

cd "${KERNEL_DIR}"

BUILD_LOG="${DEBUG_DIR}/build.log"

mkdir -p "${BUILD_DIR}"
mkdir -p "${DEBUG_DIR}"

#
# Toolchain
#
export ARCH="${ARCH}"
export SUBARCH="${SUBARCH}"
export LLVM="${LLVM}"
export LLVM_IAS="${LLVM_IAS}"
export CC="${CC}"
export CROSS_COMPILE="${CROSS_COMPILE}"

#
# ccache
#
export USE_CCACHE=1

ccache -M 10G || true

echo ""
echo "[INFO] Starting compilation..."
echo ""

START_TIME=$(date +%s)

if make \
    -j"$(nproc)" \
    O="${BUILD_DIR}" \
    ARCH="${ARCH}" \
    LLVM=1 \
    LLVM_IAS=1 \
    CC=clang \
    >"${BUILD_LOG}" 2>&1
then

    RESULT=0

else

    RESULT=1

fi

END_TIME=$(date +%s)

ELAPSED=$((END_TIME-START_TIME))

echo ""
echo "Compilation time : ${ELAPSED} seconds"

#
# Detect Image
#
IMAGE=""

for FILE in \
    "${BUILD_DIR}/arch/arm64/boot/Image" \
    "${BUILD_DIR}/arch/arm64/boot/Image.gz" \
    "${BUILD_DIR}/arch/arm64/boot/Image.gz-dtb"
do

    if [ -f "$FILE" ]; then

        IMAGE="$FILE"

        break

    fi

done

if [ "$RESULT" -eq 0 ]; then

    if [ -z "$IMAGE" ]; then

        echo "[ERROR] Build succeeded but no Image found."

        exit 1

    fi

    echo ""
    echo "[OK] Kernel image:"
    echo "$IMAGE"

    cp "$IMAGE" "${BUILD_DIR}/"

else

    echo ""
    echo "[ERROR] Build failed."

    exit 1

fi

echo ""
echo "========================================"
echo " Kernel Build Finished"
echo "========================================"
