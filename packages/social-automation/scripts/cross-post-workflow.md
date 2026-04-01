# Cross-Post Workflow

One piece of content → 5 platforms. Automated.

## The Workflow

```
Substack (source) → X Thread → Bluesky → Facebook → LinkedIn
```

## Step 1 — Publish to Substack

```bash
python3 scripts/publish-substack.py content/drafts/SLUG.md --publish
# Note: copy the published URL
```

## Step 2 — Generate Adaptations

Tell your agent:
```
Generate platform-native versions of this article: [SUBSTACK_URL]

1. X thread: 6 tweets. Tweet 1 = hook. Each tweet = one idea. Tweet 6 = "Full article: [URL]"
2. Bluesky: 250-character standalone + link
3. Facebook: 200-word conversational version + link
4. LinkedIn: 600-word professional adaptation + question at end

Save each to content/cross-posts/SLUG-[platform].md
```

## Step 3 — Post to Each Platform

```bash
# X (using xurl)
xurl post create --text "$(cat content/cross-posts/SLUG-twitter-1.md)"
# Continue for each tweet in thread

# Bluesky
./scripts/bluesky-post.sh "$(cat content/cross-posts/SLUG-bluesky.md)" "SUBSTACK_URL"

# Facebook: use browser tool with pastePost() method
# LinkedIn: post manually (API requires company verification)
```

## Step 4 — Verify and Log

```
For each platform, verify the post exists and format is correct.
Log to content/distribution-log.md:
| Platform | URL | Posted At |
|----------|-----|-----------|
| Substack | [url] | YYYY-MM-DD HH:MM |
| X | [url] | |
| Bluesky | [url] | |
| Facebook | [url] | |
```

## Timing Guide

| Platform | When |
|----------|------|
| Substack | Morning, Tue-Thu |
| X | Same day, noon |
| Bluesky | Same day, 1pm |
| Facebook | Same day, 6pm |
| LinkedIn | Next morning |
