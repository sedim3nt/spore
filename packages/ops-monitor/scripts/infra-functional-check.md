# Infrastructure Functional Check Setup

A functional check goes beyond "is the service up?" — it verifies the service is actually doing its job.

## Concept

A ping test confirms the port responds. A functional test confirms:
- The service processes a request end-to-end
- The output matches expectations
- Nothing is silently broken

## Setup Steps

### 1. Create the Check Script

Save as `scripts/infra-functional-check.sh`:

```bash
#!/bin/bash
# Functional check — tests actual operations, not just port availability
# Add your checks below and run every 30-60 minutes

WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
STATUS_FILE="$WORKSPACE/content/channel-status.json"
ERRORS=()

# ---- Gateway: full health ----
if ! openclaw health --json 2>/dev/null | python3 -c "
import sys, json
d = json.load(sys.stdin)
assert d.get('ok'), 'gateway not ok'
" 2>/dev/null; then
  ERRORS+=("gateway:unhealthy")
fi

# ---- n8n: execution health ----
# Check if last 10 executions have < 50% errors
if command -v curl &>/dev/null; then
  N8N_KEY=$(grep N8N_API_KEY "$WORKSPACE/.env" 2>/dev/null | cut -d= -f2- || true)
  if [[ -n "$N8N_KEY" ]]; then
    ERROR_RATE=$(curl -sf "http://localhost:5678/api/v1/executions?limit=10" \
      -H "X-N8N-API-KEY: $N8N_KEY" 2>/dev/null | python3 -c "
import sys, json
d = json.load(sys.stdin)
execs = d.get('data', [])
if not execs:
    print(0)
else:
    errors = sum(1 for e in execs if e.get('status') == 'error')
    print(round(errors / len(execs) * 100))
" 2>/dev/null || echo "unknown")
    
    if [[ "$ERROR_RATE" != "unknown" && "$ERROR_RATE" -gt 50 ]]; then
      ERRORS+=("n8n:error_rate_${ERROR_RATE}pct")
    fi
  fi
fi

# ---- Custom services ----
# Add your checks here:
# if ! curl -sf http://localhost:3000/api/health | grep -q '"status":"ok"'; then
#   ERRORS+=("myapp:health_failed")
# fi

# ---- Output ----
if [[ ${#ERRORS[@]} -eq 0 ]]; then
  # Write clean status
  python3 -c "
import json
from pathlib import Path
from datetime import datetime, timezone
p = Path('$STATUS_FILE')
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps({'ok': True, 'ts': datetime.now(timezone.utc).isoformat(), 'alert': ''}))
"
  echo "INFRA_OK"
else
  # Write alert status
  alert_str="${ERRORS[*]}"
  python3 -c "
import json
from pathlib import Path
from datetime import datetime, timezone
p = Path('$STATUS_FILE')
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps({'ok': False, 'ts': datetime.now(timezone.utc).isoformat(), 'alert': 'INFRA ALERT: $alert_str'}))
"
  echo "INFRA_ALERT: $alert_str"
fi
```

### 2. Add Custom Checks

For each service you want to monitor, add a block like:

```bash
# Service: [Name]
if ! [check command] | grep -q "[expected output]"; then
  ERRORS+=("[service-name]:[failure-description]")
fi
```

Examples:
```bash
# PostgreSQL
if ! pg_isready -q; then ERRORS+=("postgres:not_ready"); fi

# Redis
if ! redis-cli ping | grep -q "PONG"; then ERRORS+=("redis:not_responding"); fi

# Custom HTTP API
if ! curl -sf http://localhost:4000/health | grep -q "healthy"; then ERRORS+=("api:unhealthy"); fi
```

### 3. Schedule via Cron

```bash
# Run every 30 minutes
*/30 * * * * /bin/bash $HOME/scripts/infra-functional-check.sh >> /tmp/openclaw/infra-check.log 2>&1
```

Or use the LaunchAgent in this package for more reliable scheduling on macOS.

## Alerting Integration

The check writes to `content/channel-status.json`. The heartbeat-check.sh script reads this file and surfaces alerts to Telegram.

To get alerts:
1. Make sure heartbeat-check.sh is running (LaunchAgent)
2. Make sure your agent's heartbeat cron reads heartbeat-check.sh output
3. Configure TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in your environment
