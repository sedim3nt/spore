# Cron: Weekly Review

**Name:** weekly-review  
**Schedule:** `0 9 * * 1` (Monday 9am — start of week review)  
_Or: `0 17 * * 5` (Friday 5pm — end of week review)_

## OpenClaw Cron Setup

```
Name: weekly-review
Channel: telegram (your Telegram DM)
Cron: 0 9 * * 1
Message:
Weekly review time. Read the last 7 days of memory logs (memory/YYYY-MM-DD.md).
Produce a weekly review with:
1. What shipped (completed or meaningfully advanced)
2. What stalled — and the real reason why
3. One thing that needs to change next week
4. Top priority for this week
5. Anything to add to long-term MEMORY.md

Keep it honest. No spin.
```

## What the Agent Will Do

1. Read `memory/` logs from the past 7 days
2. Identify completed vs stalled work
3. Find patterns (what keeps blocking you?)
4. Propose the week's top priority
5. Write a summary to this week's log
6. Flag anything for long-term memory

## Expected Output

```
Weekly Review — Week of March 17

✅ Shipped:
- Client proposal sent (Mon)
- New landing page deployed (Thu)

⏸ Stalled:
- Blog post #4 — no draft started; context: kept deprioritizing for client work
- Invoice follow-up with Jordan — sent once, no response

🔄 What needs to change:
- Block 2 hours every Tuesday specifically for writing

🎯 This week's priority:
- Jordan invoice + blog draft (Tuesday writing block)

📝 Adding to MEMORY.md:
- Jordan payment pattern: follows up after 2nd reminder, not 1st
```

## Customization

Adjust the prompt to review specific areas:
- **Revenue:** "Include: invoices sent, payments received, pipeline status"
- **Content:** "Include: pieces published, drafts in progress, scheduled posts"
- **Clients:** "Include: client project status, open questions, upcoming deadlines"

## Troubleshooting

- **No memory logs:** Agent will say so; start by asking it to summarize the week manually
- **Logs too sparse:** Make sure daily log cron is running (see heartbeat setup)
- **Review too long:** Add "Keep total under 15 lines" to the prompt
