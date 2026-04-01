#!/bin/bash
# gateway-watchdog.sh — Detects gateway down, runs doctor --fix, restarts
# Designed to run via LaunchAgent every 5 minutes
#
# CUSTOMIZE: Adjust TELEGRAM_TOKEN/CHAT_ID for alerts (optional)

LOG="/tmp/openclaw/gateway-watchdog.log"
ALERT_COOLDOWN="/tmp/openclaw/watchdog-last-alert"
mkdir -p /tmp/openclaw

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

send_telegram_alert() {
  local msg="$1"
  local token="${TELEGRAM_BOT_TOKEN:-}"
  local chat="${TELEGRAM_CHAT_ID:-}"
  
  # Skip if not configured
  [[ -z "$token" || -z "$chat" ]] && return 0
  
  # Cooldown: don't alert more than once per 15 minutes
  local now=$(date +%s)
  local last=0
  [[ -f "$ALERT_COOLDOWN" ]] && last=$(cat "$ALERT_COOLDOWN")
  local diff=$((now - last))
  
  if [[ $diff -gt 900 ]]; then
    curl -s "https://api.telegram.org/bot${token}/sendMessage" \
      -d "chat_id=${chat}" \
      -d "text=${msg}" \
      -d "parse_mode=Markdown" > /dev/null 2>&1
    echo "$now" > "$ALERT_COOLDOWN"
  fi
}

# Check if gateway is responding
if openclaw health --json 2>/dev/null | grep -q '"ok"'; then
  # Gateway healthy — nothing to do
  exit 0
fi

log "⚠️ Gateway not responding. Running doctor + restart..."

# Run doctor with non-interactive fix
openclaw doctor --fix --non-interactive --yes >> "$LOG" 2>&1 || true

# Give it a moment
sleep 3

# Restart the gateway service
openclaw gateway restart >> "$LOG" 2>&1 || true

# Wait for startup
sleep 5

# Verify recovery
if openclaw health --json 2>/dev/null | grep -q '"ok"'; then
  log "✅ Gateway recovered successfully (pid $(pgrep -f 'openclaw.*gateway' | head -1 || echo 'unknown'))"
else
  log "🚨 Gateway STILL DOWN after doctor + restart. Manual intervention needed."
  send_telegram_alert "🚨 OpenClaw gateway is DOWN and could not self-recover. Manual intervention needed on $(hostname)."
fi
