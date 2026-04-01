# Ops Monitor Agent

**Version:** 1.0 | **Setup Time:** 15–20 minutes

Infrastructure monitoring and system health for OpenClaw deployments. Detects gateway failures, watches service health, alerts on anomalies, and self-heals where possible.

## Quick Start

1. Copy scripts:
   ```bash
   cp scripts/heartbeat-check.sh ~/scripts/heartbeat-check.sh
   cp scripts/gateway-watchdog.sh ~/scripts/gateway-watchdog.sh
   chmod +x ~/scripts/*.sh
   ```
2. Install LaunchAgents:
   ```bash
   cp launchagents/gateway-watchdog.plist ~/Library/LaunchAgents/
   cp launchagents/heartbeat.plist ~/Library/LaunchAgents/
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.openclaw.gateway-watchdog.plist
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.openclaw.heartbeat.plist
   ```
3. Copy ROLE.md to your agents directory and set up the ops cron
4. Test: run `./scripts/heartbeat-check.sh` and verify output

## What This Package Does

- **Gateway watchdog** — detects gateway down, runs doctor, restarts automatically
- **Heartbeat checks** — monitors services every 75 minutes
- **Alert delivery** — sends anomalies to Telegram
- **Self-healing** — fixes what it can, escalates what it can't

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Ops agent role and protocols |
| scripts/heartbeat-check.sh | Main health monitoring script |
| scripts/gateway-watchdog.sh | Auto-restart failed gateway |
| scripts/infra-functional-check.md | Setup guide for infra checks |
| scripts/deploy-verify.md | Post-deploy verification guide |
| launchagents/gateway-watchdog.plist | macOS LaunchAgent for watchdog |
| launchagents/heartbeat.plist | macOS LaunchAgent for heartbeat |

## Requirements

- macOS (LaunchAgents) or adapt plist for systemd on Linux
- OpenClaw installed and running
- `openclaw health` command available
