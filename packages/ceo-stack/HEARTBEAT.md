# HEARTBEAT.md

## Heartbeat Schedule

<!-- CUSTOMIZE: Set your check-in frequency and times -->

- Heartbeat is ON by default
- Send one concise check-in every **6 hours**
- Target times (your timezone): 00:30, 06:30, 12:30, 18:30

## Infrastructure Health Checks

<!-- CUSTOMIZE: List your services to monitor -->

Include in each heartbeat:
- **Dashboard**: Ping your dashboard URL
- **API**: Check health endpoint
- **n8n**: Check workflow executions — if >50% errors in 24h, alert
- **LaunchAgents**: Verify PIDs are recent (not stale from days ago)

## Critical Blocker Override

Alert immediately if:
- Security/privacy incident
- Data loss/corruption risk
- Delivery slip > 4 hours
- Infrastructure failure persisting > 1 hour

## Known Issue Suppression

- Track acknowledged persistent issues in `known-issues.json`
- Suppress alerts for known patterns
- New/unknown alerts still fire
- Review and prune known issues weekly
