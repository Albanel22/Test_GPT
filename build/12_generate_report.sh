#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

REPORT="${DEBUG_DIR}/build_report.txt"

mkdir -p "${DEBUG_DIR}"

echo "Generating report..."

{

echo "===================================="

echo "Test-GPT"

echo "===================================="

echo

echo "Device : $DEVICE"

echo "Kernel : $KERNEL_BRANCH"

echo

date

echo

if [ -d "${KERNEL_DIR}/.git" ]; then

echo "Kernel Commit"

git -C "${KERNEL_DIR}" rev-parse HEAD

echo

git -C "${KERNEL_DIR}" log -1 --oneline

fi

echo

echo "Build directory"

echo "${BUILD_DIR}"

echo

echo "Debug directory"

echo "${DEBUG_DIR}"

} > "$REPORT"

echo "Report created."
