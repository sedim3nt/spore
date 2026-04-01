# Cron: Weekly Review

**Name:** weekly-review
**Expression:** `0 9 * * 1`
**Runs:** Monday 9am

## OpenClaw Message Prompt

```
Weekly review. Read memory logs from the past 7 days (memory/YYYY-MM-DD.md).

Produce:
1. What shipped — completed or meaningfully advanced projects
2. What stalled — and the honest reason why
3. One pattern to change next week
4. This week's top priority (one thing, not a list)
5. Anything worth adding to long-term MEMORY.md

Keep it honest. No spin. Under 20 lines total.
Write full review to: memory/weekly-YYYY-MM-DD.md
```

## Expected Behavior

Agent reviews week's memory logs → produces structured weekly review → sends summary.

## Troubleshooting

- **No memory logs:** Daily brain-backup cron needs to be running
- **Review too long:** Add "Under 15 lines total" to prompt
- **Too positive:** Add "Identify at least one thing that went wrong"
