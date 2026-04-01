# Content Distribution Workflow

Publish one piece of content across multiple platforms automatically.

## Trigger
- **Webhook** or **Manual** — fires when content is approved

## Workflow
1. Receive content (title, body, URL, image)
2. Format for each platform:
   - **X/Twitter**: Truncate to 280 chars + link
   - **Bluesky**: Short post + link card
   - **Facebook**: Full paragraph + link preview
   - **Substack**: Full article via API
3. Post to each platform with rate limiting (1 per 30 seconds)
4. Log results + verify each post landed

## Setup
1. Webhook trigger with JSON body: `{title, body, url, image_url}`
2. Set node → create platform-specific versions
3. HTTP Request → X API (or xurl CLI via Execute Command)
4. HTTP Request → Bluesky AT Protocol
5. HTTP Request → Facebook Graph API
6. Wait 30s between each to avoid rate limits
7. Final node → log results to file

## Rate Limiting
Add Wait nodes (30s) between platform posts to avoid triggering spam filters.
