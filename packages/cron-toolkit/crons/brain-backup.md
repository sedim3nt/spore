# Cron: Brain Backup (Memory Flush)

**Name:** brain-backup
**Expression:** `0 23 * * *`
**Runs:** Daily at 11pm

## OpenClaw Message Prompt

```
End-of-day memory flush. Write today's log to memory/YYYY-MM-DD.md:

Format:
## What Happened
- [task]: [outcome]

## Decisions Made
- [decision + rationale]

## Open Loops
- [unresolved items]

## Tomorrow
- Start with: [first task]

Use any context from today's conversation. If I didn't work much, that's fine — note it.
Send me a 3-line summary. Write the full log to the file.
```

## Expected Behavior

Agent writes structured daily log → sends brief summary. File is the memory.

## Troubleshooting

- **Log is empty:** Agent needs session context; make sure you've chatted today
- **Wrong date:** Check system timezone; agent uses system time
- **File not written:** Check workspace write permissions
