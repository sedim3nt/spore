# YouTube Competitor Monitor

Track competitor YouTube channels for new videos automatically using free RSS feeds.

## Setup

Get channel RSS feed URLs:
```
https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID
```

Find channel IDs: view page source → search for `"channelId"` → copy `UC...` value.

## OpenClaw Cron Configuration

```
Name: youtube-competitor-monitor
Channel: telegram
Cron: 0 8 * * *
Message:
Check these competitor YouTube RSS feeds for videos published in the last 24 hours:

COMPETITOR CHANNELS:
- https://www.youtube.com/feeds/videos.xml?channel_id=UC_COMPETITOR_1_ID  (Competitor Name 1)
- https://www.youtube.com/feeds/videos.xml?channel_id=UC_COMPETITOR_2_ID  (Competitor Name 2)
- https://www.youtube.com/feeds/videos.xml?channel_id=UC_COMPETITOR_3_ID  (Competitor Name 3)

For each new video:
- Competitor name + channel
- Video title and publish time
- URL
- Category/topic (based on title)
- Flag if topic overlaps with our content strategy

Write results to: research/competitive/youtube-YYYY-MM-DD.md
Send me flagged items only (skip if nothing overlaps with our strategy).
```

## Python Script for Monitoring

```python
#!/usr/bin/env python3
"""Monitor competitor YouTube channels for new content."""

import feedparser
from datetime import datetime, timedelta, timezone
from pathlib import Path

COMPETITORS = {
    "Competitor Name 1": "https://www.youtube.com/feeds/videos.xml?channel_id=UC...",
    "Competitor Name 2": "https://www.youtube.com/feeds/videos.xml?channel_id=UC...",
}

# Keywords that overlap with your content strategy
OVERLAP_KEYWORDS = [
    "your topic 1",
    "your topic 2",
    "your product category",
]

cutoff = datetime.now(timezone.utc) - timedelta(hours=24)

results = []
for name, url in COMPETITORS.items():
    feed = feedparser.parse(url)
    for entry in feed.entries:
        published = datetime(*entry.published_parsed[:6], tzinfo=timezone.utc)
        if published > cutoff:
            title = entry.title.lower()
            overlaps = [kw for kw in OVERLAP_KEYWORDS if kw in title]
            results.append({
                "competitor": name,
                "title": entry.title,
                "url": entry.link,
                "published": published.strftime('%Y-%m-%d %H:%M'),
                "overlaps": overlaps,
                "flagged": bool(overlaps)
            })

# Output
for r in sorted(results, key=lambda x: x['flagged'], reverse=True):
    flag = "🚩 FLAGGED" if r['flagged'] else "  "
    print(f"{flag} [{r['competitor']}] {r['title']}")
    print(f"   Published: {r['published']}")
    print(f"   URL: {r['url']}")
    if r['overlaps']:
        print(f"   Overlap topics: {', '.join(r['overlaps'])}")
    print()
```

Install: `pip install feedparser`  
Run: `python3 scripts/youtube-monitor.py`

## What to Look For

- **New series or formats** — signals a strategic pivot
- **Topics that overlap yours** — direct content competition
- **Views/engagement on new topics** — market validation signal
- **Frequency changes** — ramping up = doubling down; slowing = pulling back
