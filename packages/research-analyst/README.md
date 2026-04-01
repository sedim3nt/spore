# Research Analyst Agent

**Version:** 1.0 | **Setup Time:** 15 minutes

Deploy an AI research agent that produces daily intelligence briefings, monitors YouTube channels, tracks competitors, and synthesizes information from across the web — delivered to your inbox or Telegram every morning.

## Quick Start

1. Copy files to your OpenClaw workspace:
   ```bash
   cp ROLE.md ~/.openclaw/workspace/agents/research/ROLE.md
   cp -r scripts/ ~/.openclaw/workspace/scripts/
   cp -r templates/ ~/.openclaw/workspace/templates/research/
   ```
2. Set up the daily intel cron (see `scripts/daily-intel-cron.md`)
3. Configure your source list in the cron prompt
4. Test: send your agent "Run a research brief on [your topic]"

## What This Agent Does

- **Daily briefings** — synthesizes web sources into a structured brief every morning
- **YouTube monitoring** — tracks channels via RSS, surfaces new videos
- **Source ranking** — weights primary over secondary sources, flags speculation
- **File-first output** — always writes findings to workspace files, not just chat

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Agent role definition and constraints |
| scripts/daily-intel-cron.md | Automated daily briefing setup |
| scripts/youtube-monitor-setup.md | YouTube RSS monitoring guide |
| templates/briefing-format.md | Output format for all briefings |
| templates/source-ranking.md | How to weight and evaluate sources |

## Requirements

- OpenClaw with web_search capability
- Telegram or email for delivery
- Optional: YouTube channels to monitor (free RSS, no API key)
