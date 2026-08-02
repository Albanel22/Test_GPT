#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "===================================="
echo " Preparing build environment"
echo "===================================="

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] Missing command: $1"
        exit 1
    fi
}

echo "[INFO] Checking required tools..."

for cmd in git make patch clang zip curl python3; do
    require_cmd "$cmd"
done

echo "[OK] Required tools found."

if [ ! -d "${KERNEL_DIR}" ]; then
    echo "[INFO] Cloning kernel..."

    git clone \
        --depth=1 \
        --branch "${KERNEL_BRANCH}" \
        "${KERNEL_REPO}" \
        "${KERNEL_DIR}"
else
    echo "[INFO] Kernel already exists."
fi

mkdir -p "${KERNEL_DIR}/arch/arm64/configs/vendor"

cp -f \
"${PERFECT_DEFCONFIG}" \
"${KERNEL_DIR}/arch/arm64/configs/vendor/${DEFCONFIG}"

echo "[OK] Defconfig installed."

mkdir -p "${KERNEL_DIR}/${BUILD_DIR}"

echo "[OK] Build directory ready."
