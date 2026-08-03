#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 07 - Package AnyKernel3"
echo "========================================"
echo ""

IMAGE=""

for FILE in \
    "${BUILD_DIR}/Image" \
    "${BUILD_DIR}/Image.gz" \
    "${BUILD_DIR}/Image.gz-dtb"
do
    if [ -f "$FILE" ]; then
        IMAGE="$FILE"
        break
    fi
done

if [ -z "$IMAGE" ]; then
    echo "[ERROR] No kernel image found."
    exit 1
fi

#
# Clone AnyKernel3
#
if [ ! -d "${ANYKERNEL_DIR}/.git" ]; then

    echo "[INFO] Cloning AnyKernel3..."

    git clone \
        --depth=1 \
        https://github.com/osm0sis/AnyKernel3.git \
        "${ANYKERNEL_DIR}"

fi

echo "[INFO] Cleaning AnyKernel..."

rm -f "${ANYKERNEL_DIR}/Image"* || true

cp "${IMAGE}" "${ANYKERNEL_DIR}/Image"

cd "${ANYKERNEL_DIR}"

ZIP="${BUILD_DIR}/${ZIP_NAME}"

rm -f "${ZIP}"

echo "[INFO] Creating ZIP..."

zip -r9 "${ZIP}" . \
    -x ".git/*" \
    -x "README.md"

echo ""
echo "[OK] Package created:"
echo "${ZIP}"

echo ""
echo "========================================"
echo " AnyKernel Ready"
echo "========================================"
