# Tweet Poster — n8n Workflow

Posts tweets from a queue in Supabase on a schedule. Supports text, images, and threads.

## Workflow Overview

```
Schedule (every 2 hrs) → Supabase: Get next queued tweet → IF exists →
  IF has image → Download image → Twitter: Post with media
  ELSE → Twitter: Post text tweet
→ Supabase: Update status to "posted"
→ Discord: Notify #published
```

## Prerequisites

- Twitter API v2 developer account (Elevated or Basic tier)
- n8n with Twitter credentials configured
- Supabase table for tweet queue

## Supabase Schema

```sql
CREATE TABLE tweet_queue (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  content text NOT NULL CHECK (length(content) <= 280),
  thread_continuation text,  -- for thread posts (reply to previous)
  image_url text,
  status text DEFAULT 'queued' CHECK (status IN ('queued', 'posted', 'failed', 'skipped')),
  priority int DEFAULT 0,    -- higher = posts first
  scheduled_for timestamptz, -- NULL = post anytime
  posted_at timestamptz,
  tweet_id text,             -- filled after posting
  created_at timestamptz DEFAULT now()
);

CREATE INDEX tweet_queue_status_priority ON tweet_queue(status, priority DESC, created_at);
```

## n8n Workflow (JSON)

Import this into n8n (Settings → Import from JSON):

```json
{
  "name": "Tweet Poster",
  "nodes": [
    {
      "name": "Schedule",
      "type": "n8n-nodes-base.scheduleTrigger",
      "parameters": {
        "rule": { "interval": [{ "field": "hours", "hoursInterval": 2 }] }
      }
    },
    {
      "name": "Get Next Tweet",
      "type": "n8n-nodes-base.supabase",
      "parameters": {
        "operation": "getAll",
        "tableId": "tweet_queue",
        "filterType": "string",
        "filterString": "status=eq.queued&order=priority.desc,created_at.asc&limit=1"
      }
    },
    {
      "name": "IF Has Tweet",
      "type": "n8n-nodes-base.if",
      "parameters": {
        "conditions": {
          "number": [{ "value1": "={{ $json.data.length }}", "operation": "larger", "value2": 0 }]
        }
      }
    },
    {
      "name": "Post Tweet",
      "type": "n8n-nodes-base.twitter",
      "parameters": {
        "operation": "create",
        "text": "={{ $('Get Next Tweet').item.json.data[0].content }}"
      }
    },
    {
      "name": "Mark Posted",
      "type": "n8n-nodes-base.supabase",
      "parameters": {
        "operation": "update",
        "tableId": "tweet_queue",
        "filterType": "string",
        "filterString": "={{ 'id=eq.' + $('Get Next Tweet').item.json.data[0].id }}",
        "fieldsUi": {
          "fieldValues": [
            { "fieldId": "status", "fieldValue": "posted" },
            { "fieldId": "posted_at", "fieldValue": "={{ $now.toISO() }}" },
            { "fieldId": "tweet_id", "fieldValue": "={{ $json.data.id }}" }
          ]
        }
      }
    }
  ]
}
```

## Adding Tweets to Queue

### Via n8n HTTP Request node
```bash
curl -X POST http://localhost:5678/webhook/add-tweet \
  -H "Content-Type: application/json" \
  -d '{"content": "Your tweet text here", "priority": 5}'
```

### Via Supabase directly
```bash
curl -X POST "https://YOUR_PROJECT.supabase.co/rest/v1/tweet_queue" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"content": "Tweet text", "priority": 0}'
```

### Via OpenClaw agent
```
Queue this tweet: "Your tweet text"
```
Agent calls Supabase MCP tool to insert the record.

## Twitter Credentials in n8n

1. n8n Settings → Credentials → New → Twitter OAuth2 API
2. You need: API Key, API Key Secret, Access Token, Access Token Secret
3. All from [developer.twitter.com](https://developer.twitter.com) → Your App → Keys and Tokens

## Rate Limiting

Twitter Basic tier: 1,500 tweets/month. That's ~50/day.
With 2-hour schedule posting 1 tweet: 12/day max.

To post more, adjust:
- Schedule interval: every 1 hour for 24/day
- Or batch: get top 3 queued and post all in one run (watch rate limits)

## Thread Support

For threads (reply chains), the workflow needs modification:

1. Get tweet with `thread_continuation IS NULL` first
2. Post it → get tweet ID
3. Query next tweet in same thread: `thread_continuation=eq.[tweet_id]`
4. Post as reply: set `in_reply_to_tweet_id` parameter
5. Repeat until no more thread replies
