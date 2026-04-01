# Cron: Morning Brief

**Name:** morning-brief  
**Schedule:** `30 7 * * *` (7:30 AM daily, adjust to your timezone)

## OpenClaw Cron Setup

In OpenClaw, add this as a scheduled message to yourself:

```
Name: morning-brief
Channel: telegram (your Telegram DM)
Cron: 30 7 * * *
Message:
Good morning. Give me my morning brief:
1. Any flagged emails from overnight
2. Today's top priority from yesterday's memory log
3. One thing I should start with today
Keep it to 5 lines max.
```

## What the Agent Will Do

1. Read yesterday's `memory/YYYY-MM-DD.md`
2. Check email (if himalaya is configured)
3. Surface anything flagged or time-sensitive
4. Give a focused priority for the day
5. Done — no filler, no pleasantries

## Customization

Adjust the prompt to add:
- Weather (add "and current weather in [city]")
- Calendar (if you have calendar access configured)
- Specific projects to check on ("Status on [project name]")
- Market data (if relevant to your work)

## Expected Output

```
Morning. Here's your brief:

📧 Email: 2 new, 1 flagged (from Sarah re: contract — draft reply ready)
🎯 Priority: Finish client proposal draft (from yesterday's log)
⚡ Start with: The proposal — you blocked 2 hours for it

Nothing else urgent.
```

## Troubleshooting

- **No memory log found:** Agent will say so and ask what today's priority is
- **Email not working:** Check himalaya config (`himalaya account list`)
- **Wrong time:** Verify your timezone in USER.md matches your system timezone
