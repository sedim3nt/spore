# Cron: Daily Competitive Digest

**Name:** competitive-digest  
**Schedule:** `0 8 * * *` (8am daily)

## OpenClaw Cron Setup

```
Name: competitive-digest
Channel: telegram
Cron: 0 8 * * *
Message:
Daily competitive digest. Research:

YOUTUBE: Check RSS feeds for new videos from these channels:
- [Competitor 1 RSS URL]
- [Competitor 2 RSS URL]

SOCIAL: Search for recent posts from: @[comp1], @[comp2]

WEB: Check these competitor pages for changes:
- [competitor-1.com/pricing]
- [competitor-2.com/blog]

ALERT if:
- Any competitor announces a new product or feature
- Any pricing changes
- Any content that directly addresses our positioning
- New blog posts or major marketing pushes

Write full digest to: research/competitive/YYYY-MM-DD.md
Only send me items that require attention. Skip if nothing material.
```

## Alert Thresholds

Send immediate alert (not just daily digest) if:
- Competitor announces pricing reduction > 20%
- Competitor launches product directly competing with yours
- Competitor mentions your brand by name
- Competitor raises funding (market signal)

## Reducing Noise

If the digest generates too many low-signal alerts:
- Add "Only flag items that require a strategic response"
- Specify "Skip routine blog posts unless topic overlaps our content strategy"
- Increase threshold: "Only send if at least 3 material items found"

## Weekly Summary Version

For a once-per-week version instead of daily:

```
Name: competitive-weekly
Schedule: 0 9 * * 1
Message:
Weekly competitive summary. Review the last 7 days of competitor activity:

[same competitors as above]

Produce a summary:
1. What's new across all competitors this week?
2. Any strategic moves or signals?
3. One thing we should consider doing (or not doing) based on this?

Write to: research/competitive/week-of-YYYY-MM-DD.md
```
