# Cron: Content Distribution (Post-Publish)

**Name:** content-distribution
**Expression:** Manual trigger (or webhook-based)
**Trigger:** After Substack article is published

## OpenClaw Message Prompt

```
Content distribution run for: [ARTICLE_TITLE]
Substack URL: [ARTICLE_URL]

Distribute to all platforms:

1. X THREAD: Create 6-tweet thread. First tweet = hook. Each tweet = one idea. Last = CTA with link. Post via xurl.
2. BLUESKY: Single post under 280 chars + link. Post via bluesky-post.sh.
3. FACEBOOK: Conversational 200-word version + link. Queue for 6pm post.

For each platform, verify post succeeded (don't trust API response — check the platform).
Report: which platforms got the post, with URLs.
```

## Expected Behavior

Agent adapts content for each platform → posts → verifies → reports distribution status.

## Timing

Set a reminder 30 minutes after any Substack publish to run this cron.

## Troubleshooting

- **API auth failing:** Regenerate tokens in .env
- **Post formatting off:** Re-read platform adaptation guide
- **Verification failing:** Agent must fetch the actual URL, not just check API response
