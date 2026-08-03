#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 00 - Prepare Build Environment"
echo "========================================"

echo ""

#
# Check Ubuntu
#
echo "[1/8] Checking operating system..."

if ! grep -qi ubuntu /etc/os-release; then
    echo "[ERROR] Ubuntu runner required."
    exit 1
fi

echo "[ OK ] Ubuntu detected."

#
# Check free disk
#
echo ""
echo "[2/8] Checking free disk..."

FREE_GB=$(df -BG . | awk 'NR==2 {gsub("G","",$4); print $4}')

echo "Free space : ${FREE_GB} GB"

if [ "$FREE_GB" -lt 20 ]; then
    echo "[ERROR] Less than 20 GB available."
    exit 1
fi

echo "[ OK ] Enough disk space."

#
# Check RAM
#
echo ""
echo "[3/8] Checking memory..."

RAM_MB=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')

echo "RAM : ${RAM_MB} MB"

echo "[ OK ]"

#
# Required tools
#
echo ""
echo "[4/8] Checking required commands..."

REQUIRED=(
git
clang
ld.lld
gcc
make
bc
python3
zip
unzip
curl
wget
)

for CMD in "${REQUIRED[@]}"
do
    if ! command -v "$CMD" >/dev/null 2>&1; then
        echo "[ERROR] Missing command: $CMD"
        exit 1
    fi

    echo "  OK - $CMD"
done

#
# Create directories
#
echo ""
echo "[5/8] Creating directories..."

mkdir -p "$BUILD_DIR"
mkdir -p "$DEBUG_DIR"
mkdir -p "$PATCH_ROOT"

echo "[ OK ]"

#
# Kernel check
#
echo ""
echo "[6/8] Checking kernel directory..."

if [ -d "$KERNEL_DIR" ]; then
    echo "[INFO] Existing kernel source detected."
else
    echo "[INFO] Kernel will be cloned."
fi

#
# Git
#
echo ""
echo "[7/8] Git version"

git --version

#
# Summary
#
echo ""
echo "[8/8] Environment summary"

echo "Project : $PROJECT_ROOT"
echo "Device  : $DEVICE"
echo "Kernel  : $KERNEL_BRANCH"
echo "Output  : $BUILD_DIR"

echo ""
echo "========================================"
echo " Environment Ready"
echo "========================================"
