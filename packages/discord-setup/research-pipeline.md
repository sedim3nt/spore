# Research Pipeline — Trending → Research → Content

## Pipeline Overview

```
X/Twitter trending
       ↓
  Filter + score
       ↓
  Rowan researches
       ↓
  Post to #research
       ↓
  Sage drafts script
       ↓
  Post to #scripts
       ↓
  Human approves (✅/❌)
       ↓
  Queue for publishing
```

## Step 1: Trending Topic Ingestion

### Option A: n8n + Twitter API

Create an n8n workflow:
1. **Schedule Trigger** → every 2 hours
2. **HTTP Request** → `GET https://api.twitter.com/2/trends/by/woeid/1` (worldwide)
3. **Filter** — require volume > 10,000 tweets
4. **Discord node** → post to `#trending`

Twitter API v2 endpoint for trends (requires Academic/Pro):
```
GET https://api.twitter.com/2/trends/by/woeid/{woeid}
Authorization: Bearer YOUR_BEARER_TOKEN
```

### Option B: Manual Trigger via OpenClaw

```bash
openclaw run research --topic "YOUR_TOPIC" --output discord:#research
```

### Option C: Nitter RSS (no API key)

Subscribe to nitter RSS feeds for keyword tracking:
```
https://nitter.net/search/rss?q=your+keyword&f=tweets
```
Feed this into n8n RSS node → filter by engagement signals → post to Discord.

## Step 2: Research Agent (Rowan)

Rowan fires on new `#trending` posts. Config:

```yaml
# OpenClaw agent config
agents:
  riptide:
    triggers:
      - channel: trending
        action: research
    output:
      channel: research
      format: embed
    depth: medium   # quick|medium|deep
    sources:
      - web_search
      - youtube_transcripts
      - wikipedia
```

Research post format in `#research`:
```
🔍 **[TOPIC]**

**Why it's trending:** [2-3 sentences]
**Key angles:** [bullet list]
**Source quality:** [high/medium/low]
**Content potential:** [1-10]
**Suggested format:** [short/long/thread]

React 🎯 to queue for scripting
```

## Step 3: Script Generation (Sage)

When research post gets 🎯 reaction:

1. Sage reads the research embed
2. Pulls related content from memory
3. Drafts a script in the format matching `Suggested format`
4. Posts to `#scripts` thread

Script post format:
```
📝 **[TITLE]**
Platform: [YouTube/X/Substack]
Format: [Short/Long/Thread]
Estimated time: [duration]
Based on: [link to #research post]

---

[FULL SCRIPT CONTENT]

---
React ✅ to approve | ❌ to reject | 🔄 to request revision
```

## Step 4: Approval + Routing

See `content-approval.md` for full reaction workflow.

After ✅:
- Script moves to `#approved`
- n8n picks up and queues for publishing
- Publishing confirmation posted to `#published`

## Tuning the Pipeline

**Signal quality filters** (adjust in n8n filter node):
- Minimum trend volume: 5,000 (lower = more noise)
- Keyword blocklist: news events, politics, anything off-brand
- Domain focus: tech, AI, crypto, systems — tune to your niche

**Research depth settings:**
- `quick` — 2 web searches, 200-word summary. Good for fast-moving trends.
- `medium` — 5 searches + YouTube scan, 500-word summary. Default.
- `deep` — Full research run, 1000+ words, source citations. For long-form.

**Cadence recommendation:**
- Trending scan: every 2 hours
- Max scripts per day: 3-5 (quality > volume)
- Approval window: 24 hours before auto-archive
