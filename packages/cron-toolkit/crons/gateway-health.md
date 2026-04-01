# Cron: Gateway Health Check

**Name:** gateway-health
**Expression:** `*/5 * * * *`
**Runs:** Every 5 minutes
**Note:** Typically done via LaunchAgent (see ops-monitor package), not OpenClaw cron

## LaunchAgent Approach (Recommended)

Use the LaunchAgent from the ops-monitor package instead of an OpenClaw cron.
This runs more reliably and can restart the gateway before OpenClaw even sees it's down.

See: ops-monitor/launchagents/gateway-watchdog.plist

## OpenClaw Cron Approach (Backup)

```
Name: gateway-health
Channel: telegram
Cron: */15 * * * *
Message:
Gateway health check. Run: openclaw health --json
If ok: no message.
If not ok: run openclaw gateway restart, wait 10 seconds, check again.
Report only if recovery failed.
```

## Expected Behavior

Silent on healthy. Self-heals minor failures. Alerts only on persistent outage.

## Troubleshooting

- **Circular dependency:** If gateway is down, OpenClaw crons won't fire. Use LaunchAgent.
- **Too many alerts:** Add cooldown — don't alert same issue twice in 15 minutes
