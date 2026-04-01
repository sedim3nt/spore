# Content Engine Agent

**Version:** 1.0 | **Setup Time:** 20 minutes

A writing and publishing agent that drafts long-form articles, adapts content for every platform, and executes your cross-posting workflow. Tell it to publish — it publishes.

## Quick Start

1. Copy files to your workspace:
   ```bash
   cp ROLE.md ~/.openclaw/workspace/agents/content/ROLE.md
   cp CONTENT-STANDARD.md ~/.openclaw/workspace/
   cp -r scripts/ templates/ ~/.openclaw/workspace/
   ```
2. Set up Substack credentials (see `scripts/publish-substack.md`)
3. Set up Bluesky credentials (see `scripts/bluesky-post.md`)
4. Test: "Draft a 1500-word article about [topic] in my voice"

## What This Agent Does

- **Article drafting** — long-form content in your brand voice
- **Social adaptation** — turns one piece into posts for 5 platforms
- **Direct publishing** — pushes to Substack, Bluesky, X via API
- **Editorial calendar** — tracks what's planned, in draft, published

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Agent role and voice guide |
| CONTENT-STANDARD.md | 10-point quality checklist |
| scripts/publish-substack.md | Substack API setup and usage |
| scripts/bluesky-post.md | Bluesky AT Protocol posting |
| scripts/cross-post-workflow.md | 1 piece → 5 platform workflow |
| templates/editorial-calendar.md | Content planning template |

## Requirements

- OpenClaw with web_fetch capability
- Substack account (for newsletter publishing)
- Bluesky account (for AT Protocol posts)
- X/Twitter account (optional)
