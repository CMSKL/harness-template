#!/usr/bin/env bash
set -e

FEATURE_ID="$1"
BEHAVIOR="$2"
VERIFICATION="$3"

if [ -z "$FEATURE_ID" ] || [ -z "$BEHAVIOR" ] || [ -z "$VERIFICATION" ]; then
  echo "Usage: bash scripts/add-feature.sh <ID> \"<BEHAVIOR>\" \"<VERIFICATION>\""
  exit 1
fi

echo "TODO: append feature to features.json"
echo "Feature: $FEATURE_ID"
echo "Behavior: $BEHAVIOR"
echo "Verification: $VERIFICATION"
