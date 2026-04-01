# Social Automation Kit

**Version:** 1.0 | **Setup Time:** 20 minutes

Scripts and workflows for automated posting to Bluesky, Substack, and Facebook. Real, runnable code — not descriptions.

## Quick Start

1. Copy scripts to your workspace scripts folder
2. Set up credentials in your .env file
3. Test each script manually before scheduling

## Credentials Needed

```bash
# Add to ~/.openclaw/workspace/.env
BSKY_HANDLE=yourhandle.bsky.social
BSKY_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx
SUBSTACK_SID=your_session_cookie
SUBSTACK_PUB=yourpublication
```

## Files Included

| File | Purpose |
|------|---------|
| scripts/bluesky-post.sh | Post to Bluesky via AT Protocol |
| scripts/substack-publish.md | Substack API publishing guide |
| scripts/facebook-post.md | Facebook posting (browser-based) |
| scripts/cross-post-workflow.md | 1 piece → 5 platforms workflow |
| templates/post-queue.json | Social queue format |
