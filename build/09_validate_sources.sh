#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 09 - Validate Sources"
echo "========================================"

cd "${KERNEL_DIR}"

ERROR=0

FILES=(
Makefile
Kconfig
fs/open.c
fs/proc/task_mmu.c
include/linux/fs.h
init/main.c
kernel
security
drivers
)

echo ""

for FILE in "${FILES[@]}"
do
    if [ -e "$FILE" ]; then
        echo "[ OK ] $FILE"
    else
        echo "[FAIL] $FILE"
        ERROR=1
    fi
done

echo ""

if [ "$ERROR" -eq 1 ]; then
    echo "Source validation failed."
    exit 1
fi

echo "Source validation successful."
