# Cross-Post Workflow: 1 Piece → 5 Platforms

One article becomes five platform-native posts. This is the workflow.

## Overview

```
Substack article (source of truth)
         │
         ├──→ Substack (full article)
         ├──→ X/Twitter (thread — 5-8 tweets)
         ├──→ Bluesky (short standalone + link)
         ├──→ LinkedIn (500-800 word adaptation)
         └──→ Facebook (conversational version + link)
```

## Step-by-Step Workflow

### Step 1 — Publish to Substack (Primary)
```bash
python3 scripts/publish-substack.py content/drafts/SLUG.md --publish
# Note the published URL for use in cross-posts
```

### Step 2 — Generate Platform Versions

Prompt your agent:
```
Given the article at [SUBSTACK_URL], create platform adaptations:

1. X THREAD: 6 tweets, first tweet = hook, each tweet = one idea, last tweet = CTA with link
2. BLUESKY POST: 1 standalone post under 280 chars + link
3. LINKEDIN POST: 600-word professional adaptation, no hashtag spam, end with a question
4. FACEBOOK POST: conversational, 200-300 words, feels like sharing with friends

Save each to: content/cross-posts/SLUG-[platform].md
```

### Step 3 — Post to Each Platform

**X/Twitter** (using xurl or n8n):
```bash
# Post the thread
xurl post create --text "$(cat content/cross-posts/SLUG-twitter-1.md)"
```

**Bluesky:**
```bash
./scripts/bluesky-post.sh "$(cat content/cross-posts/SLUG-bluesky.md)" "SUBSTACK_URL"
```

**LinkedIn:** Post manually via browser (LinkedIn API requires company verification)

**Facebook:** Post via your preferred method (see social-automation package)

### Step 4 — Verify

For each platform:
- [ ] Post appeared in feed
- [ ] Links work
- [ ] Formatting is correct
- [ ] No truncation

## Platform Adaptation Rules

### Substack → X Thread
- First tweet: hook or most counterintuitive claim
- Each subsequent tweet: one complete idea (no cliffhangers between tweets)
- Thread length: 5-8 tweets
- Final tweet: "Full article: [URL]"
- No hashtags unless they're actually searchable in your niche

### Substack → Bluesky
- Pick the sharpest sentence from the article
- Add context in 1-2 more sentences
- End with the link
- Total: under 280 characters

### Substack → LinkedIn
- Reframe for professional context
- Lead with the practical implication
- Include the personal angle more than the theoretical
- End with a genuine question to the reader
- No engagement-bait ("Drop a ❤️ if you agree")

### Substack → Facebook
- More conversational, first-person
- Less "here's what I learned" more "I've been thinking about..."
- Shorter paragraphs (Facebook compresses them)
- Include the link but don't make it the focus

## Timing

| Platform | When to Post |
|----------|-------------|
| Substack | Tuesday-Thursday, 8-10am audience timezone |
| X | Same day as Substack, 12pm |
| Bluesky | Same day, 1pm |
| LinkedIn | Next morning, 8am |
| Facebook | Same day, 6pm |

## Automation Options

This workflow can be automated with n8n (see `n8n-recipes/` package):
- Substack webhook → trigger cross-posting workflow
- Queue all posts → stagger by time
- Verification check 30 minutes after each post

## Tracking

Log each cross-post to `content/distribution-log.md`:
```markdown
## Article: [Title]

| Platform | URL | Status | Posted At |
|----------|-----|--------|-----------|
| Substack | [url] | ✅ | 2026-03-18 09:00 |
| X | [url] | ✅ | 2026-03-18 12:00 |
| Bluesky | [url] | ✅ | 2026-03-18 13:00 |
| LinkedIn | pending | ⏳ | |
| Facebook | [url] | ✅ | 2026-03-18 18:00 |
```
