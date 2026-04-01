# Cron: Social Posting Queue

**Name:** social-posting
**Expression:** `0 12 * * *`
**Runs:** Daily at noon

## OpenClaw Message Prompt

```
Social post time. Check content/social-queue.md (or content/queue/) for scheduled posts.

For today's date:
- Post any X/Twitter content in the queue
- Post any Bluesky content in the queue
- Mark each as posted with timestamp

If queue is empty: skip silently.
If any post fails: report the error.
```

## Expected Behavior

Agent reads social queue file → posts pending items → marks complete → reports result.

## Queue File Format

Create `content/social-queue.md`:
```markdown
## 2026-03-18

### X
[Tweet text here]

### Bluesky
[Bluesky post here]
```

## Troubleshooting

- **Posts not going through:** Check API credentials in .env
- **Queue file not found:** Create content/social-queue.md
- **Duplicate posts:** Verify "mark as posted" is working
