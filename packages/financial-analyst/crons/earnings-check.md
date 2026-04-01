# Cron: Earnings Calendar Check

**Name:** earnings-check  
**Schedule:** `0 8 * * 1` (Monday 8am — weekly earnings calendar)

## OpenClaw Cron Setup

```
Name: earnings-check
Channel: telegram
Cron: 0 8 * * 1
Message:
Pull this week's earnings calendar. Focus on:
1. Companies in my watchlist (templates/portfolio-watchlist.md)
2. Major index components that could move the broader market
3. Any sector bellwethers (first reporter in a sector sets expectations)

For each relevant company:
- Report date and time (BMO/AMC)
- Consensus estimates (EPS, revenue)
- Key metric to watch
- Options implied move if available

Save to: research/finance/YYYY-MM-DD-earnings.md
Send me the watchlist hits only (skip companies I don't track).
```

## Weekly Earnings Alert (Day-of)

Set a second cron for day-of alerts:

```
Name: earnings-alert
Channel: telegram
Cron: 30 7 * * 1-5
Message:
Any earnings reports TODAY from my watchlist or major market movers?
If yes: pre-earnings brief for each (last quarter vs estimates, consensus expectation, risk factors).
If none: skip silently.
```

## Post-Earnings Follow-Up

After earnings, have the agent summarize results:

```
[Company] reported earnings. Pull the results and compare to estimates:
- Beat/miss EPS by how much?
- Revenue beat/miss?
- Guidance change vs expectations?
- Management commentary (any forward-looking signals)?
- Initial market reaction (AH/BMO move)?

Label everything as information, not a recommendation.
```

## Watchlist Configuration

Keep your watchlist current in `templates/portfolio-watchlist.md`. Add tickers and context:

```markdown
## My Earnings Watchlist

| Ticker | Company | Next Earnings | Notes |
|--------|---------|---------------|-------|
| AAPL | Apple | Q2 April | Watch services revenue |
| NVDA | Nvidia | Q1 May | Data center growth rate |
```

## Troubleshooting

- **Dates wrong:** Cross-check with company IR page — Yahoo Finance is approximate
- **Missing estimates:** Try searching "[Ticker] earnings consensus estimate [quarter]"
- **BMO vs AMC:** BMO = Before Market Open; AMC = After Market Close
