# Financial Analyst Agent

**Version:** 1.0 | **Setup Time:** 15 minutes

An AI financial research agent that delivers daily macro briefings, tracks earnings calendars, monitors your watchlist, and synthesizes sector-level intelligence — every morning before markets open.

## Quick Start

1. Copy files to your workspace:
   ```bash
   cp ROLE.md ~/.openclaw/workspace/agents/financial/ROLE.md
   cp -r templates/ crons/ ~/.openclaw/workspace/
   ```
2. Fill in `templates/portfolio-watchlist.md` with your tickers
3. Set up the daily-research cron (see `crons/daily-research.md`)
4. Test: "Give me a macro briefing for today"

## What This Agent Does

- Daily pre-market briefing with macro conditions
- Earnings calendar monitoring for your watchlist
- Sector rotation signals
- Fed calendar and economic event tracking

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Agent role, research process, constraints |
| crons/daily-research.md | Morning briefing automation |
| crons/earnings-check.md | Earnings calendar monitoring |
| templates/macro-briefing.md | Output format for macro briefs |
| templates/sector-config.md | Sector tracking configuration |
| templates/portfolio-watchlist.md | Your tickers and position context |

## Disclaimer

This agent provides information and analysis, not financial advice. All investment decisions are yours. The agent does not have access to real-time pricing data unless you provide a market data source.
