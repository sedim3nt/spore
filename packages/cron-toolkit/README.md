# Cron Toolkit

**Version:** 1.0 | **Setup Time:** 30–60 minutes

13 production-ready cron configurations for OpenClaw. Copy the ones you want, customize the prompts, and paste into OpenClaw's scheduler. Each file includes the cron expression, OpenClaw prompt, expected behavior, and troubleshooting.

## Quick Start

1. Browse the `crons/` folder and pick what you need
2. In OpenClaw: Settings → Scheduled Messages (or use `openclaw cron add`)
3. Copy the cron expression and message from each file
4. Test each cron manually before scheduling

## Crons Included

| Cron | Schedule | What It Does |
|------|---------|--------------|
| morning-briefing | Daily 7:30am | Daily brief, email, priorities |
| social-posting | Daily 12pm | Queue social posts |
| heartbeat | Every 75min | Infrastructure health check |
| email-check | 3x daily | Inbox triage |
| youtube-monitor | Daily 8am | Competitor/interest channel updates |
| brain-backup | Daily 11pm | Memory flush to workspace files |
| self-improvement | Weekly Sunday | Agent performance review |
| gateway-health | Every 5min | Gateway watchdog |
| facebook-daily | Daily 6pm | Facebook post queue |
| blog-watcher | Daily 8am | RSS/blog feed updates |
| content-distribution | On trigger | Cross-post after Substack publish |
| weekly-review | Monday 9am | Weekly summary and planning |
