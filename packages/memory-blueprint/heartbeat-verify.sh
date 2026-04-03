#!/usr/bin/env bash
# heartbeat-verify.sh — Verify autoDream ran successfully
# Run this in your morning heartbeat check (e.g., 6:30 AM)
# Exit codes: 0 = OK, 1 = FAILED (dream log missing or STUB)

set -euo pipefail

WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
DATE=$(date +%Y-%m-%d)
DREAM_LOG="$WORKSPACE/memory/dream-${DATE}.md"

if [ ! -f "$DREAM_LOG" ]; then
  echo "🚨 autoDream FAILED — dream log missing: $DREAM_LOG"
  exit 1
fi

if grep -q "STUB" "$DREAM_LOG"; then
  echo "🚨 autoDream FAILED — dream log still says STUB (consolidation never completed)"
  exit 1
fi

echo "✅ autoDream OK — dream log exists and consolidated"
exit 0
