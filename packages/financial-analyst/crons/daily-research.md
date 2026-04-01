# Cron: Daily Financial Research Brief

**Name:** financial-brief  
**Schedule:** `30 6 * * 1-5` (6:30 AM weekdays — before US market open)

## OpenClaw Cron Setup

```
Name: financial-brief
Channel: telegram
Cron: 30 6 * * 1-5
Message:
Pre-market financial brief. Research and compile:

1. MACRO: Any Fed speeches, economic data releases, or policy signals from the last 24h
2. MARKETS: Overnight futures direction, significant international market moves
3. CALENDAR: What economic data releases today? What earnings today/this week?
4. WATCHLIST: Any news on my tracked companies (see templates/portfolio-watchlist.md)
5. ONE THING: The single macro factor most likely to move markets today

Use public sources: Yahoo Finance, FRED, Reuters, FT.
Write full brief to: research/finance/YYYY-MM-DD-macro.md
Send me the 5-line summary.

Note: Label all analysis clearly as research, not financial advice.
```

## Customizing Your Brief

Add specific focuses to the prompt:
- **Sector focus:** "Pay special attention to semiconductor sector news"
- **Position context:** "I'm long [sector], flag any negative macro signals"
- **Event tracking:** "FOMC meeting on [date] — flag any preliminary signals"

## Expected Output (Telegram)

```
Pre-market Brief — March 18

📊 Macro: CPI data at 8:30 ET (est. 3.1%). Fed's Powell speaks at 14:00.
🌏 Futures: S&P +0.3%, Nasdaq +0.5%. Nikkei closed +1.2%.
📅 Today: AAPL earnings after close. Housing starts at 8:30.
📌 Watchlist: No material news on your tracked names.
⚡ Watch: CPI print — market priced for 3.1%, surprise in either direction = vol.

Full brief: research/finance/2026-03-18-macro.md
```

## Troubleshooting

- **No real-time data:** The agent uses free public sources; data may be 15-30 min delayed
- **Earnings dates wrong:** Confirm against company IR pages — Yahoo Finance sometimes shifts dates
- **Too much noise:** Narrow to 3 specific questions in the prompt
