# Health Monitor Workflow

Check service health endpoints on a schedule and alert on failures.

## Trigger
- **Cron node** — every 15 minutes

## Workflow
1. Cron fires → HTTP Request to each service URL
2. Check response status codes
3. If any non-200 → send Telegram/Slack/Discord alert
4. Log results to a file or database

## Services to Monitor
```
Dashboard:  http://localhost:3333
API:        http://localhost:3334/api/health
n8n:        http://localhost:5678/healthz
Gateway:    openclaw health --json
```

## Setup
1. Add Schedule Trigger node (every 15 min)
2. Add HTTP Request node per service (set: Continue on Fail = true)
3. Add IF node → check `{{$json.statusCode}} !== 200`
4. On failure → Telegram Send Message: "🚨 Service down: {{$node.name}}"
5. On success → No Op (silent)
