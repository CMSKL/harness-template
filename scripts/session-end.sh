#!/usr/bin/env bash
set -e

echo "== Session end =="
echo "1. Confirm PROGRESS.md updated"
echo "2. Confirm features.json updated"
echo "3. Run full verification"
echo "4. Check clean state"

make check
bash scripts/check-clean-state.sh

echo "Session handoff ready"
