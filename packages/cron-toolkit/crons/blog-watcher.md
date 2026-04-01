# Cron: Blog Watcher (RSS Feed Monitor)

**Name:** blog-watcher
**Expression:** `0 8 * * *`
**Runs:** Daily at 8am

## OpenClaw Message Prompt

```
Blog watch. Check these RSS feeds for posts published in the last 24 hours:

FEEDS:
- https://[blog-you-follow].com/feed
- https://[newsletter].substack.com/feed
- [other feeds]

For each new post:
- Title, author, date
- 2-sentence summary
- Flag if it's highly relevant to: [your topics]

Write results to: research/blogs-YYYY-MM-DD.md
Send only flagged items. Ignore if nothing relevant.
```

## Using OpenClaw's Blogwatcher Skill

If you have the blogwatcher skill:
```bash
blogwatcher add [feed-url] "[Feed Name]"
blogwatcher list   # see all monitored feeds
blogwatcher check  # manual check
```

## Troubleshooting

- **Too much noise:** Narrow the relevance keywords
- **No results:** Feed might not update daily; check manually
- **Feed URL wrong:** Try the URL in browser; add /feed or /rss if needed
