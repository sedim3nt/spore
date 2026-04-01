# Cron: Agent Self-Improvement Review

**Name:** self-improvement
**Expression:** `0 10 * * 0`
**Runs:** Sunday 10am weekly

## OpenClaw Message Prompt

```
Weekly agent performance review. Read the last 7 days of memory logs.

Assess:
1. Tasks where you underperformed or the human had to correct you
2. Prompts that were ambiguous or produced bad results
3. Any patterns in what went wrong

Produce:
1. 3 specific improvements to make next week
2. Any files or configs you'd recommend updating
3. One thing that worked well (keep doing it)

Be honest. Don't perform competence you don't have.
```

## Expected Behavior

Agent reviews its own performance logs and proposes specific improvements.

## Troubleshooting

- **Too abstract:** Add "be specific — cite actual examples from the logs"
- **Always positive:** Add "identify at least one thing to improve"
