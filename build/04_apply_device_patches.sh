#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 04 - Apply Device Patches"
echo "========================================"
echo ""

cd "${KERNEL_DIR}"

PATCH_LOG="${DEBUG_DIR}/device_patch.log"

mkdir -p "${DEBUG_DIR}"

#
# Check patch directory
#
if [ ! -d "${PATCH_DEVICE}" ]; then
    echo "[INFO] No device patch directory."
    exit 0
fi

PATCH_COUNT=$(find "${PATCH_DEVICE}" -name "*.patch" | wc -l)

if [ "$PATCH_COUNT" -eq 0 ]; then
    echo "[INFO] No device patches found."
    exit 0
fi

echo "[INFO] ${PATCH_COUNT} patch(es) found."

FAILED=0

find "${PATCH_DEVICE}" -name "*.patch" | sort | while read PATCH
do

    echo ""
    echo "----------------------------------------"
    echo "Applying $(basename "$PATCH")"
    echo "----------------------------------------"

    if git apply \
        --3way \
        --whitespace=nowarn \
        "$PATCH" >>"$PATCH_LOG" 2>&1
    then

        echo "[ OK ]"

    else

        echo "[FAILED] $(basename "$PATCH")"

        FAILED=1

        break

    fi

done

#
# Collect rejects
#
find . -name "*.rej" \
-exec cp --parents {} "${DEBUG_DIR}" \; || true

find . -name "*.orig" \
-exec cp --parents {} "${DEBUG_DIR}" \; || true

#
# Save useful contexts
#
mkdir -p "${DEBUG_DIR}/contexts"

for FILE in \
    fs/open.c \
    fs/namei.c \
    fs/proc/task_mmu.c \
    security/selinux/hooks.c \
    security/selinux/rules.c \
    security/selinux/avc.c
do

    if [ -f "$FILE" ]; then

        cp "$FILE" \
        "${DEBUG_DIR}/contexts/$(basename "$FILE")"

    fi

done

if [ "$FAILED" -ne 0 ]; then

    echo ""
    echo "[ERROR] Device patch failed."

    exit 1

fi

echo ""
echo "========================================"
echo " Device patches completed"
echo "========================================"
