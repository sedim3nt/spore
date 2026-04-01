# Cron: YouTube Monitor

**Name:** youtube-monitor
**Expression:** `0 8 * * *`
**Runs:** Daily at 8am

## OpenClaw Message Prompt

```
Check these YouTube RSS feeds for new videos in the last 24 hours:

- https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID_1
- https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID_2

For each new video: title, channel, URL, publish time.
Flag if topic overlaps with: [your keywords].
Write results to: research/youtube-YYYY-MM-DD.md
Send only flagged items. Skip if nothing relevant.
```

## Expected Behavior

Agent fetches RSS → filters by date → surfaces relevant videos → saves and reports.

## Troubleshooting

- **No results:** Verify channel ID is correct
- **Too many results:** Add keyword filter to prompt
- **Feed not loading:** Try the RSS URL in a browser to verify it's valid
