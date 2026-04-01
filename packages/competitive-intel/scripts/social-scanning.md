# Competitor Social Scanning

Monitor competitor activity on public social platforms.

## What to Monitor

For each competitor, track:
- New posts and content themes
- Engagement patterns (what's resonating?)
- Messaging changes (new positioning, new taglines)
- Product announcements
- Promotions and offers

## Platform-by-Platform Setup

### X (Twitter)
```
Search query: from:[competitor_handle] since:[7-days-ago]
Or: [competitor name] OR [competitor product] since:[7-days-ago]
```

Agent prompt:
```
Search X for recent posts from [@competitor1, @competitor2] in the last 7 days.
Look for: product announcements, pricing changes, new features, content themes.
Summarize what they're talking about and any strategic signals.
```

### Bluesky
- Visit their profile: `bsky.app/profile/[handle]`
- No search API currently; manual check or via RSS if they post consistently

### LinkedIn
- Follow competitor company pages
- Use web_fetch on their LinkedIn page (limited data available publicly)

### Substack
- Subscribe to competitor newsletters (RSS available):
  ```
  https://[publication].substack.com/feed
  ```

## Cron for Weekly Social Scan

```
Name: competitor-social-scan
Channel: telegram
Cron: 0 9 * * 1
Message:
Weekly competitor social scan. Check public posts from these competitors:

X: @[competitor1], @[competitor2], @[competitor3]
Substack: [competitor-pub].substack.com (check RSS for new posts)

For each competitor:
- New content themes this week
- Any pricing, product, or positioning changes
- Anything that looks like a strategic shift
- Their most engaged post this week (if visible)

Write to: research/competitive/social-YYYY-MM-DD.md
Alert me on any pricing changes or major announcements.
```

## Signal Interpretation

| Signal | Interpretation |
|--------|---------------|
| Competitor posts more frequently | Ramping up investment / worried |
| Competitor changes tagline/positioning | Market repositioning |
| Competitor launches free tier | Under competitive pressure |
| Competitor runs heavy promotion | Revenue shortfall or aggressive growth |
| Competitor stops posting | Pivoting, struggling, or acquired |
| Competitor hires (LinkedIn) | Strategic direction signal |

## Legal and Ethical Notes

- All monitoring is of public content only
- Do not create fake accounts to access gated content
- Do not scrape at volumes that constitute a DDOS
- Do not share competitors' private communications
