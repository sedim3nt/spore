# YouTube Channel Monitor Setup

Monitor YouTube channels for new videos using free RSS feeds — no API key required.

## How YouTube RSS Works

Every YouTube channel has a public RSS feed:
```
https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID
```

Get the channel ID from the channel URL:
- `youtube.com/channel/UC...` → the `UC...` part is the ID
- `youtube.com/@handle` → view page source, search for `channelId`

## OpenClaw Cron Setup

Use the blogwatcher skill or a custom cron:

```
Name: youtube-monitor
Channel: telegram
Cron: 0 8 * * *
Message:
Check these YouTube RSS feeds for videos published in the last 24 hours:

CHANNELS:
- https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID_1
- https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID_2
- https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID_3

For each new video:
- Title + publish date
- Channel name
- URL
- 2-sentence summary of what it's likely about (based on title/description)

Format as a clean list. Skip videos older than 24 hours.
Write results to: research/youtube-YYYY-MM-DD.md
```

## Using OpenClaw's Blogwatcher

If you have the blogwatcher skill installed:

```bash
# Add channels to monitor
blogwatcher add https://www.youtube.com/feeds/videos.xml?channel_id=UC_CHANNEL_ID "Channel Name"

# List monitored feeds
blogwatcher list

# Check for updates
blogwatcher check
```

## Finding Channel IDs

**Method 1 — URL**
If the URL shows: `youtube.com/channel/UCXv5B-Uu_SLBDa3vclI4GxQ`
Channel ID = `UCXv5B-Uu_SLBDa3vclI4GxQ`

**Method 2 — Page source**
1. Go to the channel page
2. Ctrl+U to view source
3. Search for `"channelId"`
4. Copy the value (starts with `UC`)

**Method 3 — YouTube Data API (optional)**
```bash
curl "https://www.googleapis.com/youtube/v3/channels?part=id&forHandle=@channelhandle&key=YOUR_API_KEY"
```

## Parsing RSS in a Script

```python
#!/usr/bin/env python3
import feedparser
from datetime import datetime, timedelta, timezone

CHANNELS = {
    "Channel Name": "https://www.youtube.com/feeds/videos.xml?channel_id=UC...",
}

cutoff = datetime.now(timezone.utc) - timedelta(hours=24)

for name, url in CHANNELS.items():
    feed = feedparser.parse(url)
    print(f"\n## {name}")
    for entry in feed.entries:
        published = datetime(*entry.published_parsed[:6], tzinfo=timezone.utc)
        if published > cutoff:
            print(f"- [{entry.title}]({entry.link}) — {published.strftime('%Y-%m-%d %H:%M')}")
```

Install: `pip install feedparser`

## Alert Patterns

Set alerts for specific keywords in video titles:

```
For each new video, flag it if the title contains any of:
- [keyword 1, e.g., "tutorial", "how to"]
- [keyword 2, e.g., "competitor name"]
- [keyword 3, e.g., "product category"]
Send a high-priority alert for flagged videos.
```

## Troubleshooting

- **Feed not found:** Verify channel ID is correct; try viewing the RSS URL in a browser
- **No new videos:** The feed is working; channel just hasn't posted
- **Old videos appearing:** Add date filter to your prompt; RSS sometimes shows recent reposts
