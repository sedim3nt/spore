# Cron: Morning Briefing

**Name:** morning-briefing
**Expression:** `30 7 * * *`
**Runs:** Daily at 7:30am (adjust to your timezone)

## OpenClaw Message Prompt

```
Good morning. Give me my morning brief:
1. Check email — flag anything urgent or from key contacts
2. Read yesterday's memory log — what was I working on?
3. One priority for today (not a list — the single most important thing)
4. Anything blocking that needs early attention?

Keep it to 5 lines. No filler.
```

## Expected Behavior

Agent reads: SOUL.md → USER.md → yesterday's memory log → email (if configured)
Agent outputs: 5-line brief covering email status, yesterday's status, and today's priority.

## Troubleshooting

- **Brief is too long:** Add "Max 5 lines" to prompt
- **No memory log:** Agent will note this; run end-of-day cron to start logging
- **Email not working:** Check himalaya config (`himalaya envelope list`)
- **Wrong time:** Verify cron timezone in OpenClaw settings
