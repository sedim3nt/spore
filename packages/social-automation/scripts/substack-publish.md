# Substack Publishing Setup

Publish articles to Substack programmatically.

## Prerequisites

1. Active Substack publication
2. Session cookie from logged-in browser session

## Getting Your Cookie

1. Log in to Substack in Chrome
2. DevTools → Application → Cookies → your publication URL
3. Copy `substack.sid` value
4. Add to `.env`:
   ```
   SUBSTACK_SID=your_sid_value
   SUBSTACK_PUB=yourpublicationname
   ```

## Agent Prompt to Publish

```
Publish this article to Substack:
File: content/drafts/[article-slug].md

Steps:
1. Read the file
2. Use the Substack API with my credentials from .env
3. Create as draft first
4. If I confirm: publish
5. Verify the live URL loads correctly
6. Report the published URL

My publication: $SUBSTACK_PUB.substack.com
```

## Manual API Call

```bash
# Create draft
curl -X POST "https://yourpub.substack.com/api/v1/drafts" \
  -H "Content-Type: application/json" \
  -b "substack.sid=$SUBSTACK_SID" \
  -d '{
    "draft_title": "Your Title",
    "draft_subtitle": "Your subtitle",
    "draft_body": "{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Your content here.\"}]}]}",
    "audience": "everyone"
  }'

# Publish (use post ID from draft response)
curl -X POST "https://yourpub.substack.com/api/v1/drafts/[POST_ID]/publish" \
  -H "Content-Type: application/json" \
  -b "substack.sid=$SUBSTACK_SID" \
  -d '{"send": true}'
```

## After Publishing — Verify

```bash
curl -s "https://yourpub.substack.com/p/[slug]" | grep "<title>"
```

If the title returns: publish confirmed.
If HTML shows raw tags or garbled text: formatting issue — fix before sending to subscribers.

## Cross-Post Checklist

After every Substack publish:
- [ ] Article loads correctly at published URL
- [ ] Title and subtitle correct
- [ ] No raw HTML visible in body
- [ ] Images loading
- [ ] Run cross-post workflow: X, Bluesky, Facebook
