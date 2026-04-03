#!/usr/bin/env bash
set -e

FEATURE_ID="$1"

if [ -z "$FEATURE_ID" ]; then
  echo "Usage: bash scripts/verify-feature.sh <FEATURE_ID>"
  exit 1
fi

echo "Verify feature: $FEATURE_ID"
echo "TODO: read features.json, extract verification command, execute it, then update state to passing if successful"
exit 0
