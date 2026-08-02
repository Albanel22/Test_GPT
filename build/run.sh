#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/env.sh"

echo "===================================="
echo " Copilote Build System v1.0"
echo "===================================="

"${SCRIPT_DIR}/prepare.sh"
"${SCRIPT_DIR}/patch.sh"
"${SCRIPT_DIR}/compile.sh"
"${SCRIPT_DIR}/package.sh"

echo ""
echo "===================================="
echo " BUILD FINISHED"
echo "===================================="
