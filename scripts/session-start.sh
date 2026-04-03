#!/usr/bin/env bash
set -e

echo "== Session start =="
echo "1. Read AGENTS.md"
echo "2. Read PROGRESS.md"
echo "3. Read DECISIONS.md"
echo "4. Read features.json"
echo "5. Run make check"

make check

echo "Session initialization complete"
