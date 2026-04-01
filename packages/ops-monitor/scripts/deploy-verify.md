# Deploy Verification Guide

Every deployment should be followed by a structured verification step. "It deployed" ≠ "it works."

## The Verification Ladder

Run these checks after every deploy, in order. Stop if any step fails.

### Level 1 — Service Up (30 seconds)
```bash
# Is the process running?
ps aux | grep [service-name] | grep -v grep

# Is the port bound?
lsof -i :[PORT] | grep LISTEN

# Does the health endpoint respond?
curl -sf http://localhost:[PORT]/health
```

### Level 2 — Functional (2 minutes)
Test a real operation — not just the health endpoint:
```bash
# For an API: test a real endpoint
curl -sf http://localhost:[PORT]/api/v1/status | jq .

# For a database: run a test query
echo "SELECT 1;" | psql [DBNAME]

# For a message broker: publish + consume a test message
```

### Level 3 — Integration (5 minutes)
Test the full data path end-to-end:
```bash
# Send a real test request
curl -X POST http://localhost:[PORT]/api/v1/[endpoint] \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Verify it appeared in the output (database, file, downstream service)
# Verify logs show the expected flow
tail -20 /var/log/[service].log
```

### Level 4 — Rollback Test (optional, on major deploys)
```bash
# Verify you can roll back if needed
git log --oneline -5  # know your rollback target
# Tag the current working state
git tag deploy-$(date +%Y%m%d-%H%M) && git push --tags
```

## Post-Deploy Checklist

Copy and run this after each deploy:

```markdown
## Deploy Verification — [Service] — [Date]

- [ ] Service process running
- [ ] Health endpoint responding
- [ ] Port bound correctly
- [ ] Real operation tested (not just health ping)
- [ ] Logs clean (no unexpected errors)
- [ ] Previous version tagged for rollback
- [ ] Monitoring/alerts verified still working
- [ ] Smoke test: [describe what you tested]

Result: ✅ PASS / ❌ FAIL (see notes)
Notes: [anything unexpected]
```

## Common Deploy Issues

### Gateway won't restart after config change
```bash
# Kill all processes first (launchctl unload alone isn't enough)
pkill -f openclaw || true
sleep 3

# Verify nothing on the port
lsof -ti :3001 | xargs kill -9 2>/dev/null || true

# Load fresh
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.openclaw.plist
```

### Service starts but requests fail
- Check if environment variables loaded correctly
- Look for `.env` vs system env discrepancy
- Run: `printenv | grep [SERVICE_PREFIX]`

### Port already in use after deploy
```bash
# Find and kill whatever is on the port
lsof -ti :PORT | xargs kill -9
```

### Logs show old version still running
```bash
# Force kill by process name
pkill -f "old-binary-name"
# Then start new version
```

## Integration with Ops Agent

Add deploy verification to your ops agent prompt:
```
After any deploy, run the deploy verification checklist in scripts/deploy-verify.md.
Report the result (PASS/FAIL) and any unexpected findings.
If FAIL: do not mark the task complete. Report the specific failure point.
```
