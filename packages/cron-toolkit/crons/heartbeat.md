# Cron: Heartbeat (Infrastructure Health)

**Name:** heartbeat
**Expression:** `*/75 * * * *` (every 75 minutes)
**Note:** OpenClaw's built-in heartbeat — verify cron expression format for your setup

## OpenClaw Message Prompt

```
Heartbeat check. Run scripts/heartbeat-check.sh and report the result.

If HEARTBEAT_OK: send no message (suppress clean heartbeats).
If alert: send the alert text immediately.

Then check:
- Gateway: openclaw health
- Any services in your monitor list

Report only if something needs attention.
```

## Expected Behavior

Silent on healthy systems. Alerts only on issues.

## Troubleshooting

- **Too many alerts:** Add known issues to content/known-issues.json
- **No alerts when things break:** Verify heartbeat-check.sh is executable
- **Spam:** Add suppress logic — don't alert on same issue twice in 4 hours
