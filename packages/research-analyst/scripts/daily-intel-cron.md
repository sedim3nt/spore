# Cron: Daily Intelligence Brief

**Name:** daily-intel  
**Schedule:** `0 7 * * *` (7am daily)

## OpenClaw Cron Setup

```
Name: daily-intel
Channel: telegram (your Telegram DM)
Cron: 0 7 * * *
Message:
Daily intelligence brief. Research and synthesize:

TOPICS:
- [Topic 1, e.g., "AI agent frameworks — new releases, benchmarks, community discussion"]
- [Topic 2, e.g., "Your industry — funding news, product launches, executive moves"]
- [Topic 3, e.g., "Competitor names — any new content, pricing, or positioning changes"]

SOURCES TO CHECK:
- Web search for each topic (last 24 hours)
- [Any specific sites, e.g., "Hacker News", "TechCrunch", "your-industry.com"]

FORMAT: Use the briefing template (templates/research/briefing-format.md).
Write full brief to: research/YYYY-MM-DD-daily.md
Send me a 5-line summary via this message.
```

## What the Agent Will Do

1. Search each topic with `freshness: day` filter
2. Fetch and read key articles
3. Synthesize findings per topic
4. Write full brief to file
5. Send abbreviated summary to Telegram

## Customizing Your Topics

Replace the topic placeholders with your actual focus areas:

**For solopreneurs:**
```
- My industry: [name] — funding, talent moves, product launches
- Tool/platform updates: [tools you use] — new features, pricing changes
- Client industry: [client vertical] — anything affecting their business
```

**For investors:**
```
- Macro: Fed signals, inflation data, yield curve
- Sector: [your sector] — earnings, analyst updates, M&A
- Portfolio companies: [names] — news, sentiment
```

**For content creators:**
```
- Platform algorithm changes: YouTube, X, Substack, etc.
- Trending topics in [your niche]
- Competitor content: [channels/accounts to monitor]
```

## Expected Output (Telegram summary)

```
Daily Brief — March 18

🤖 AI: Anthropic released Claude 4 with 200k context. OpenAI announced GPT-5 delay.
📊 Industry: Series B funding in [sector] up 40% QoQ per Crunchbase.
🎯 Competitors: [Name] launched new pricing tier at $49/mo (was $79).

Full brief: research/2026-03-18-daily.md
```

## Troubleshooting

- **Too much noise:** Narrow topics to specific subtopics, add "focus on: X, not Y"
- **Missing key stories:** Add specific sites to check explicitly
- **Too slow:** Reduce to 2 topics per brief; research more = better quality
- **Date filter not working:** Add "published in the last 24 hours" to each topic prompt
