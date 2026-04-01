# Notion via MCP — Setup Guide

Connect your Notion workspace as a queryable knowledge base for OpenClaw agents.

## What You Can Do

- Search Notion pages by text
- Read page content into agent context
- Create new pages and database entries
- Update existing content
- Query Notion databases with filters

## Prerequisites

- Notion workspace (free tier works)
- Node.js 18+
- OpenClaw with MCP support

## Step 1: Create a Notion Integration

1. Go to [notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Click **New integration**
3. Name: `OpenClaw Agent`
4. Associated workspace: select yours
5. Capabilities:
   - ✅ Read content
   - ✅ Update content
   - ✅ Insert content
6. Click **Submit**
7. Copy the **Internal Integration Token** — starts with `secret_`

Store it:
```bash
echo 'export NOTION_API_KEY="secret_xxxxxxxxxxxxxxxx"' >> ~/.zshrc
source ~/.zshrc
```

## Step 2: Share Pages with the Integration

Notion uses explicit sharing — the integration can only access pages you share with it.

For each page/database you want agents to access:
1. Open the page in Notion
2. Click **...** (top right) → **Add connections**
3. Find `OpenClaw Agent` → Connect

For bulk access, share your top-level workspace page and the integration will inherit access to sub-pages.

## Step 3: Install the MCP Server

```bash
# Test it runs
npx -y @modelcontextprotocol/server-notion --help
```

## Step 4: Add to OpenClaw Config

In `~/.openclaw/config.json`:

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      }
    }
  }
}
```

## Step 5: Restart and Verify

```bash
openclaw gateway restart
openclaw mcp list-tools
```

Look for tools prefixed with `notion`:
- `notion.search` — search pages
- `notion.get_page` — read a page
- `notion.create_page` — create new page
- `notion.update_page` — update existing
- `notion.query_database` — filtered database queries
- `notion.create_database_item` — add row to database

## Using Notion as a Knowledge Base

### Example: Search for meeting notes

In OpenClaw chat:
```
Search Notion for notes about the content strategy meeting
```

The agent will call `notion.search` with query "content strategy meeting" and return matching pages.

### Example: Create a new note

```
Create a Notion page titled "Weekly Review 2026-03-18" in the Notes database
```

### Example: Query a database

Tell the agent:
```
Get all items from my Content Calendar Notion database with status = "Draft"
```

The agent calls `notion.query_database` with appropriate filter.

## Recommended Notion Structure for Agents

Set up these databases and share them with the integration:

```
📁 Knowledge Base
  └── Notes (general notes, research)
  └── Content Calendar (title, status, platform, publish_date)
  └── Ideas (title, priority, category)
  └── Agent Log (date, agent, action, result)

📁 Projects
  └── Active Projects (name, status, next_action)
  └── Reference (permanent reference docs)
```

## Finding Database IDs

When querying databases directly, you need the database ID:

1. Open database in Notion
2. Click **Share** → **Copy link**
3. URL format: `notion.so/workspace/XXXXXXXXXXXXXXXX?v=...`
4. The 32-character hex string is the database ID

Or: ask the agent to search for the database by name and it will return the ID.

## API Rate Limits

Notion API: 3 requests/second per integration.

If you're doing bulk operations (e.g., migrating content), add delays:
```bash
# If scripting directly
for item in "${items[@]}"; do
  notion_api_call "$item"
  sleep 0.5
done
```

The MCP server handles this automatically for normal agent use.

## Troubleshooting

**"object not found" error:**
- The integration doesn't have access to that page
- Solution: Share the page with the integration (Step 2)

**"unauthorized" error:**
- Token is wrong or expired
- Solution: Re-copy token from integration settings

**Empty search results:**
- Content may not be indexed yet (new pages take ~30 seconds)
- Integration may not have access to the database
