# Cron: Facebook Daily Post

**Name:** facebook-daily
**Expression:** `0 18 * * *`
**Runs:** Daily at 6pm

## OpenClaw Message Prompt

```
Facebook post time. Check content/facebook-queue.md for today's post.

If a post is queued for today:
1. Read the post
2. Open Facebook and compose it (use browser tool)
3. Verify formatting — check for paragraph breaks before posting
4. Post and confirm it appeared in the feed
5. Mark as posted in the queue file

If no post queued: skip silently.

Important: Facebook's editor loses paragraph breaks with keyboard input.
Use the clipboard paste method to preserve formatting.
```

## Expected Behavior

Agent reads queue → opens Facebook → pastes post → verifies → marks complete.

## Troubleshooting

- **No paragraph breaks:** Use HTML clipboard method (see scripts/facebook-post-helper.js)
- **Not logged in:** May need to re-authenticate browser session
- **Post not appearing:** Check Facebook's post visibility settings
