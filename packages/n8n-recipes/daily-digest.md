# Daily Digest — n8n Workflow

Generates a daily summary of everything that happened across the system and posts it to Telegram (or Discord). Runs every morning before your first session.

## What It Summarizes

- Yesterday's published content (all platforms)
- Agent activity from daily log
- n8n workflow errors in last 24 hours
- Services health status
- Queue sizes (tweet queue, content queue)
- Top stats (views, likes if accessible)

## Schedule

```
Cron: 0 8 * * *
Timezone: America/Denver
```

## Workflow Steps

### 1. Gather Published Content (Yesterday)

```json
{
  "type": "n8n-nodes-base.supabase",
  "parameters": {
    "operation": "getAll",
    "tableId": "published_content",
    "filterString": "published_at=gte.{{ $now.minus({days: 1}).startOf('day').toISO() }}&published_at=lt.{{ $now.startOf('day').toISO() }}"
  }
}
```

### 2. Get Queue Status

```json
{
  "type": "n8n-nodes-base.supabase",
  "parameters": {
    "operation": "getAll",
    "tableId": "content_queue",
    "filterString": "status=eq.queued"
  }
}
```

Parallel node for tweet_queue:
```json
{
  "filterString": "status=eq.queued&order=priority.desc"
}
```

### 3. Check n8n Workflow Errors

```javascript
// Code node — fetch n8n execution history via internal API
const response = await $http.get('http://localhost:5678/api/v1/executions', {
  headers: { 'X-N8N-API-KEY': process.env.N8N_API_KEY },
  params: {
    status: 'error',
    limit: 20,
    includeData: false,
    // Last 24 hours
    startedAfter: new Date(Date.now() - 86400000).toISOString()
  }
});

const errors = response.body.data || [];
return [{ json: { errorCount: errors.length, errors: errors.map(e => ({
  workflow: e.workflowData?.name,
  startedAt: e.startedAt,
  stoppedAt: e.stoppedAt
})) } }];
```

Get n8n API key: Settings → n8n API → Create API Key

### 4. Check Service Health

```javascript
// Code node — ping services
const checks = [
  { name: 'n8n', url: 'http://localhost:5678/healthz' },
  { name: 'Ollama', url: 'http://localhost:11434/api/tags' },
  { name: 'OpenClaw', url: 'http://localhost:3000/health' },
];

const results = await Promise.allSettled(
  checks.map(async (c) => {
    const start = Date.now();
    const resp = await $http.get(c.url, { timeout: 3000 });
    return { name: c.name, status: '🟢', latency: Date.now() - start };
  })
);

return [{ json: {
  services: results.map((r, i) => 
    r.status === 'fulfilled' 
      ? r.value 
      : { name: checks[i].name, status: '🔴', error: r.reason?.message }
  )
}}];
```

### 5. Build Digest Message

```javascript
// Code node — compose digest
const published = $('Get Published').item.json.data || [];
const queueSize = $('Get Queue').item.json.data?.length || 0;
const tweetQueueSize = $('Get Tweet Queue').item.json.data?.length || 0;
const errors = $('Check Errors').item.json.errorCount || 0;
const services = $('Health Check').item.json.services || [];

const date = new Date().toLocaleDateString('en-US', { 
  weekday: 'long', month: 'short', day: 'numeric',
  timeZone: 'America/Denver'
});

const serviceLines = services.map(s => 
  `${s.status} ${s.name}${s.latency ? ` (${s.latency}ms)` : ''}`
).join('\n');

const publishedLines = published.length > 0
  ? published.map(p => `  • ${p.platform}: ${p.title || p.content?.slice(0, 50)}`).join('\n')
  : '  None';

const digest = `
📋 **Daily Digest — ${date}**

**Published Yesterday:**
${publishedLines}

**Queue:**
  • Content: ${queueSize} items
  • Tweets: ${tweetQueueSize} queued

**System:**
${serviceLines}
${errors > 0 ? `\n⚠️ **${errors} workflow error(s)** — check n8n` : '✅ No errors'}
`.trim();

return [{ json: { digest } }];
```

### 6. Send to Telegram

```json
{
  "type": "n8n-nodes-base.telegram",
  "parameters": {
    "operation": "sendMessage",
    "chatId": "{{ $env.TELEGRAM_CHAT_ID }}",
    "text": "={{ $json.digest }}",
    "parseMode": "Markdown"
  }
}
```

## Telegram Setup

1. Message @BotFather on Telegram → `/newbot`
2. Get bot token
3. Start a chat with your bot
4. Get your chat ID: `https://api.telegram.org/botTOKEN/getUpdates`
5. Store as `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` in n8n credentials

## Optional: Weekly Summary

Run a heavier version on Mondays that includes:
- Total content published last week (count + breakdown by platform)
- Top performing tweet (if you have Twitter analytics access)
- Upcoming content in queue
- Any recurring errors that need attention

Add a separate workflow with `0 9 * * 1` schedule.

## Sample Output

```
📋 Daily Digest — Tuesday, Mar 18

Published Yesterday:
  • Substack: Why Multi-Agent Systems Need Memory
  • X: 3 tweets posted
  • Instagram: atlas.botanical post (8,247 likes)

Queue:
  • Content: 2 items
  • Tweets: 5 queued

System:
🟢 n8n (12ms)
🟢 Ollama (45ms)
🟢 OpenClaw (8ms)
✅ No errors
```
