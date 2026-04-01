# Substack Publisher — n8n Workflow

Publishes articles to Substack from a Supabase queue. Triggers cross-posting to X and Facebook on success.

## How Substack Publishing Works

Substack has no official API. The workflow authenticates as a browser session using your Substack session cookie. This means:
- You need to extract your session cookie periodically (every few months)
- n8n makes HTTP requests directly to Substack's internal API

## Step 1: Get Your Session Cookie

1. Log into Substack in Chrome
2. Open DevTools (F12) → Application → Cookies → `substack.com`
3. Copy the value of `substack.sid`
4. Store in n8n as a credential or environment variable

```bash
# Store in .env
echo 'SUBSTACK_SID=your_cookie_value' >> ~/.env
```

Refresh this every 90 days or when publishing starts failing with 401 errors.

## Supabase Schema

```sql
CREATE TABLE content_queue (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL,
  subtitle text,
  body_html text NOT NULL,  -- full article HTML
  body_markdown text,       -- source markdown
  platform text DEFAULT 'substack' CHECK (platform IN ('substack', 'x', 'instagram', 'facebook')),
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'queued', 'published', 'failed')),
  publish_at timestamptz,   -- NULL = publish immediately when dequeued
  published_at timestamptz,
  url text,                 -- filled after publish
  substack_post_id text,
  cross_post_status jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);
```

## n8n Workflow Steps

### 1. Schedule Trigger
Run every morning at 9am Mountain Time:
```
Cron: 0 9 * * *
Timezone: America/Denver
```

### 2. Get Queued Article
```json
{
  "type": "n8n-nodes-base.supabase",
  "parameters": {
    "operation": "getAll",
    "tableId": "content_queue",
    "filterString": "status=eq.queued&platform=eq.substack&order=publish_at.asc.nullsfirst&limit=1"
  }
}
```

### 3. IF Article Exists
Check `$json.data.length > 0`

### 4. Create Substack Draft

```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "POST",
    "url": "https://YOUR_PUBLICATION.substack.com/api/v1/drafts",
    "headers": {
      "Cookie": "substack.sid={{ $env.SUBSTACK_SID }}",
      "Content-Type": "application/json"
    },
    "body": {
      "type": "newsletter",
      "draft_title": "={{ $('Get Queued Article').item.json.data[0].title }}",
      "draft_subtitle": "={{ $('Get Queued Article').item.json.data[0].subtitle }}",
      "draft_body": "={{ $('Get Queued Article').item.json.data[0].body_html }}",
      "draft_podcast_url": null,
      "draft_video_upload_id": null,
      "section_chosen": false
    }
  }
}
```

Response contains `id` (the draft ID).

### 5. Publish the Draft

```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "POST",
    "url": "https://YOUR_PUBLICATION.substack.com/api/v1/drafts/{{ $json.id }}/publish",
    "headers": {
      "Cookie": "substack.sid={{ $env.SUBSTACK_SID }}",
      "Content-Type": "application/json"
    },
    "body": {
      "send": true,
      "share_automatically": false
    }
  }
}
```

### 6. Update Supabase

Mark as published, store URL:
```json
{
  "fieldsUi": {
    "fieldValues": [
      { "fieldId": "status", "fieldValue": "published" },
      { "fieldId": "published_at", "fieldValue": "={{ $now.toISO() }}" },
      { "fieldId": "url", "fieldValue": "=https://YOUR_PUBLICATION.substack.com/p/{{ $('Publish Draft').item.json.slug }}" }
    ]
  }
}
```

### 7. Trigger Cross-Posting

After publishing, trigger the cross-post workflow via webhook:
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "POST",
    "url": "http://localhost:5678/webhook/cross-post",
    "body": {
      "title": "={{ $('Get Queued Article').item.json.data[0].title }}",
      "url": "=https://YOUR_PUBLICATION.substack.com/p/{{ $('Publish Draft').item.json.slug }}",
      "summary": "={{ $('Get Queued Article').item.json.data[0].subtitle }}"
    }
  }
}
```

See `content-distribution.md` for the cross-post workflow.

## Markdown to HTML Conversion

If your content is stored as markdown, convert before publishing:

Add a **Code node** before the draft creation step:
```javascript
const markdownIt = require('markdown-it');
const md = new markdownIt({ html: true, linkify: true });

const markdown = $input.first().json.data[0].body_markdown;
const html = md.render(markdown);

return [{ json: { ...($input.first().json), body_html: html } }];
```

Note: n8n has markdown-it available in Code nodes.

## Verification

After publishing, fetch the article URL and check for rendering issues:

```javascript
// Code node — verify no raw HTML tags in rendered content
const response = await $http.get(articleUrl);
const html = response.body;

const hasRawTags = /<p>|<h[1-6]>|<strong>|<em>/.test(html);
if (hasRawTags) {
  throw new Error('Article contains raw HTML tags — formatting broken');
}

return [{ json: { verified: true, url: articleUrl } }];
```

## Error Handling

Add error workflow: if publish fails:
1. Update status to `failed` in Supabase
2. Send Discord alert to `#alerts`
3. Include error message and article title
