#!/usr/bin/env bash
# heartbeat-check.sh — Infrastructure health check for OpenClaw deployments
# Runs every 75 minutes via LaunchAgent (or cron)
# Outputs: HEARTBEAT_OK or alert message
#
# CUSTOMIZE: Edit the SERVICES array and CHECK_* variables below

set -euo pipefail

# ---- Configuration ----
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
STATUS_FILE="$WORKSPACE/content/channel-status.json"
KNOWN_ISSUES="$WORKSPACE/content/known-issues.json"
LOG_DIR="/tmp/openclaw"
MAX_AGE_SECONDS=4500  # 75 minutes — skip expensive checks if recent

mkdir -p "$LOG_DIR"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/heartbeat.log"; }

# ---- Service Checks ----
# Add/remove services here. Format: "name|check_command|expected_in_output"
declare -a SERVICES=(
  "gateway|openclaw health --json|ok"
  "n8n|curl -sf http://localhost:5678/healthz|ok"
  # Add your services:
  # "myapp|curl -sf http://localhost:3000/health|healthy"
  # "postgres|pg_isready -q && echo ok|ok"
)

ALERTS=()
PASS=()

for service_def in "${SERVICES[@]}"; do
  IFS='|' read -r name cmd expected <<< "$service_def"
  
  output=$(eval "$cmd" 2>/dev/null || true)
  
  if echo "$output" | grep -q "$expected"; then
    PASS+=("$name")
    log "✅ $name: OK"
  else
    ALERTS+=("$name")
    log "🚨 $name: FAILED (output: ${output:0:100})"
  fi
done

# ---- Known Issues Suppression ----
KNOWN_PATTERNS=()
if [[ -f "$KNOWN_ISSUES" ]]; then
  while IFS= read -r pattern; do
    KNOWN_PATTERNS+=("$pattern")
  done < <(python3 -c "
import json, sys
d = json.load(open('$KNOWN_ISSUES'))
for i in d.get('known_issues', []):
    if p := i.get('pattern'):
        print(p)
" 2>/dev/null || true)
fi

# ---- Output ----
if [[ ${#ALERTS[@]} -eq 0 ]]; then
  echo "HEARTBEAT_OK (checked: ${PASS[*]})"
else
  # Check if all alerts are known issues
  NEW_ALERTS=()
  for alert in "${ALERTS[@]}"; do
    is_known=false
    for pattern in "${KNOWN_PATTERNS[@]}"; do
      if [[ "$alert" == *"$pattern"* ]]; then
        is_known=true
        break
      fi
    done
    $is_known || NEW_ALERTS+=("$alert")
  done

  if [[ ${#NEW_ALERTS[@]} -eq 0 ]]; then
    echo "HEARTBEAT_OK (known issues suppressed: ${ALERTS[*]})"
  else
    echo "🚨 INFRA ALERT: ${NEW_ALERTS[*]} — check $LOG_DIR/heartbeat.log"
  fi
fi
