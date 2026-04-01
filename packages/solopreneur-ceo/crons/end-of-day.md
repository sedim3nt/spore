# Cron: End of Day

**Name:** end-of-day  
**Schedule:** `0 18 * * 1-5` (6pm weekdays — adjust to when you stop working)

## OpenClaw Cron Setup

```
Name: end-of-day
Channel: telegram (your Telegram DM)
Cron: 0 18 * * 1-5
Message:
End of day wrap. Write today's memory log to memory/YYYY-MM-DD.md with:
- What I worked on today (infer from any files modified, tasks discussed)
- Any decisions made
- Open loops / blockers
- Tomorrow's first task
Then give me a 3-line summary.
```

## What the Agent Will Do

1. Review context from today's session (files modified, tasks discussed)
2. Write structured log to `memory/YYYY-MM-DD.md`
3. Note open loops and blockers
4. Suggest tomorrow's starting point
5. Send you a brief summary

## Memory Log Format

The agent writes logs in this format:
```markdown
# YYYY-MM-DD

## What Happened
- [Task/event]: [outcome]
- [Task/event]: [outcome]

## Decisions Made
- [Decision + brief rationale]

## Open Loops
- [Unfinished task or question]

## Tomorrow
- Start with: [specific task]
```

## Expected Output (sent to you)

```
Day wrapped. Log written.

Today: proposal draft ✅, email catch-up ✅, design review 🟡 (half done)
Open: Jordan invoice (sent, awaiting reply), design review needs 1 more hour
Tomorrow: Finish design review first — it's the blocker for launch
```

## Why This Matters

OpenClaw agents don't have persistent memory between sessions. The daily log IS your agent's memory. Without it:
- Monday's agent doesn't know what Friday's did
- Projects lose continuity
- Context has to be re-established every session

With it:
- Every session starts informed
- Weekly reviews work automatically
- You can always answer "what did I do last week?"

## Troubleshooting

- **Agent doesn't know what you worked on:** Mention key work items during the day in chat
- **Logs getting long:** Add "Keep each section to 3 bullets max" to the prompt
- **Wrong date:** Check your system timezone; agent uses system time
