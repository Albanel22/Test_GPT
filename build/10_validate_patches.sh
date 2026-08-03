#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

echo "========================================"
echo " STEP 10 - Validate Patches"
echo "========================================"

cd "${KERNEL_DIR}"

FAIL=0

for DIR in \
    "${PATCH_KERNEL}" \
    "${PATCH_KSU}" \
    "${PATCH_DEVICE}"
do

    [ -d "$DIR" ] || continue

    find "$DIR" -name "*.patch" | sort | while read PATCH
    do

        echo ""
        echo "Checking $(basename "$PATCH")"

        if git apply --check "$PATCH"
        then
            echo "PASS"
        else
            echo "FAIL"
            FAIL=1
        fi

    done

done

exit "$FAIL"
