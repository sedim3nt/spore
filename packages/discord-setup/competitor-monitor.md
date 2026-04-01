# Competitor Monitor — YouTube Tracking Channel

## What This Does

Automatically tracks competitor YouTube channels, posts new video alerts to `#competitor-yt`, and extracts key data (title, views, topic) so you can respond with content quickly.

## Prerequisites

- YouTube Data API v3 key (free, 10,000 units/day)
- n8n running
- `#competitor-yt` channel created in Discord

## Step 1: Get YouTube API Key

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create project → Enable **YouTube Data API v3**
3. Credentials → Create API Key
4. Store as `YOUTUBE_API_KEY` in environment

## Step 2: Compile Your Competitor List

Create `competitors.json`:
```json
{
  "channels": [
    {
      "name": "Competitor A",
      "channelId": "UCxxxxxxxxxxxxxxxxxxxxxxxx",
      "notes": "Focus on AI productivity"
    },
    {
      "name": "Competitor B",
      "channelId": "UCyyyyyyyyyyyyyyyyyyyyyyyy",
      "notes": "Long-form technical tutorials"
    }
  ]
}
```

### Finding Channel IDs

Method 1: From channel URL
- `youtube.com/@channelname` → use YouTube API:
```bash
curl "https://www.googleapis.com/youtube/v3/channels?forHandle=channelname&part=id&key=YOUR_KEY"
```

Method 2: View page source → search for `"channelId"`

## Step 3: n8n Workflow

### Nodes:

**1. Schedule Trigger**
- Interval: Every 6 hours

**2. Code node** — Loop competitors
```javascript
const competitors = [
  { name: "Competitor A", channelId: "UCxxxxxx" },
  { name: "Competitor B", channelId: "UCyyyyyy" },
];
return competitors.map(c => ({ json: c }));
```

**3. HTTP Request** — Fetch latest videos
```
GET https://www.googleapis.com/youtube/v3/search
Query params:
  channelId: {{ $json.channelId }}
  part: snippet
  order: date
  maxResults: 3
  publishedAfter: {{ $now.minus({hours: 6}).toISO() }}
  type: video
  key: {{ $env.YOUTUBE_API_KEY }}
```

**4. IF node** — Check if items exist
```
{{ $json.items.length > 0 }}
```

**5. Code node** — Format Discord embed
```javascript
const items = $input.first().json.items;
const channelName = $input.first().json.channelName;

return items.map(item => ({
  json: {
    embeds: [{
      title: `🎥 New: ${item.snippet.title}`,
      url: `https://youtube.com/watch?v=${item.id.videoId}`,
      description: item.snippet.description.slice(0, 200) + '...',
      color: 0xFF0000,
      author: { name: channelName },
      fields: [
        { name: 'Published', value: item.snippet.publishedAt.split('T')[0], inline: true },
        { name: 'Channel', value: channelName, inline: true },
      ],
      thumbnail: { url: item.snippet.thumbnails.medium.url }
    }]
  }
}));
```

**6. HTTP Request** — Post to Discord
```
POST https://discord.com/api/v10/channels/COMPETITOR_CHANNEL_ID/messages
Authorization: Bot YOUR_BOT_TOKEN
Content-Type: application/json
Body: {{ $json }}
```

## Step 4: Deduplication

Track seen video IDs to avoid re-posting. Use Supabase:

```sql
CREATE TABLE seen_videos (
  video_id text PRIMARY KEY,
  channel_name text,
  title text,
  posted_at timestamptz DEFAULT now()
);
```

In n8n before posting:
1. **Supabase Select** → check `seen_videos` for `video_id`
2. **IF** → skip if already seen
3. **Supabase Insert** → log new video ID after posting

## Step 5: Response Tagging

After bot posts in `#competitor-yt`, auto-add reaction options:
- 🎯 — we should make a response video
- 📊 — analyze their strategy
- 💡 — good angle to steal
- 🚫 — not relevant

React with 🎯 to trigger the research pipeline (see `research-pipeline.md`).

## Monitoring X (Twitter) Competitors

Same pattern, different API:

```bash
# Using xurl (from xurl skill)
xurl get /2/users/by/username/competitorhandle --fields id

# Get recent tweets
xurl get "/2/users/USER_ID/tweets?max_results=10&tweet.fields=public_metrics"
```

Schedule this in n8n, filter by engagement (`like_count > 100`), post to `#competitor-x`.

## Alert Thresholds

Set up special alerts for breakout videos:

In n8n, after fetching video data, fetch view count:
```
GET https://www.googleapis.com/youtube/v3/videos?id=VIDEO_ID&part=statistics&key=KEY
```

If `viewCount > 50000` within 24 hours → post with `@here` mention for urgent review.

## Weekly Digest

Add a weekly summary workflow:
1. **Schedule** → every Monday 9am
2. Fetch all `#competitor-yt` posts from past 7 days
3. Summarize with agent: top topics, most active competitor, suggested response content
4. Post to `#competitor-notes`
