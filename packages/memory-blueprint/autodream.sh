#!/usr/bin/env bash
# autoDream — Nightly memory consolidation for OpenClaw agents
# Cron: 1:30 AM daily (adjust to your timezone)
# Usage: openclaw cron create autodream --schedule "30 1 * * *" --session isolated --script scripts/autodream.sh
#
# What it does:
# 1. Reads MEMORY.md, BRIDGE.md, FAILURE_MODEL.md
# 2. Searches LCM for decisions made in last 24h
# 3. Consolidates MEMORY.md (adds new, prunes stale)
# 4. Refreshes BRIDGE.md with current state
# 5. Writes audit trail to memory/dream-YYYY-MM-DD.md
#
# IMPORTANT: Writes a stub file FIRST so heartbeat can detect failures.
# If the dream log still says "STUB" after the cron window, consolidation failed.

set -euo pipefail

WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
DATE=$(date +%Y-%m-%d)
DREAM_LOG="$WORKSPACE/memory/dream-${DATE}.md"

# Write stub immediately — if we crash, heartbeat detects "STUB"
echo "# Dream Log — ${DATE}\n\nSTATUS: STUB\n\nConsolidation in progress..." > "$DREAM_LOG"

# The actual consolidation happens via the agent session.
# This script is the entry point; the LLM does the reasoning.
cat << 'PROMPT'
You are running the nightly autoDream consolidation pass.

1. Read MEMORY.md, BRIDGE.md, and memory/FAILURE_MODEL.md
2. Search LCM for decisions, policies, and configuration changes from the last 24 hours
3. Update MEMORY.md:
   - Add any new decisions or policies discovered
   - Prune entries that are no longer accurate
   - Verify cron table matches reality (run: openclaw cron list)
   - Verify site count matches reality
4. Refresh BRIDGE.md with current system state
5. Write the dream log to memory/dream-YYYY-MM-DD.md with:
   - What was added to MEMORY.md
   - What was pruned from MEMORY.md
   - Any drift detected and corrected
   - Current blocker status

CRITICAL: Replace the STUB content in the dream log with real content.
If you cannot complete consolidation, write WHY to the dream log (not just "STUB").
PROMPT
