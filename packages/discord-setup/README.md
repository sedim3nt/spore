# Discord Multi-Agent Setup — Quick Start

Get your Discord server wired up as a command center for OpenClaw agents in under 30 minutes.

## What You're Building

A Discord server where:
- OpenClaw agents post alerts, research, and content drafts
- You approve/reject scripts with ✅/❌ reactions
- Competitor monitoring runs automatically
- The research → content pipeline is visible end-to-end

## Prerequisites

- Discord account with a server you control (or create one)
- OpenClaw installed and running
- n8n running locally (optional but recommended for automation)

## Quick Start (5 steps)

### 1. Create the Bot

Go to [discord.com/developers/applications](https://discord.com/developers/applications), create a new application, enable the bot, copy the token. Full details in `bot-setup.md`.

### 2. Set Channel Architecture

Follow `channel-architecture.md` to create the recommended channel layout. Takes ~10 minutes.

### 3. Invite the Bot

Generate an OAuth2 URL with scopes: `bot`, `applications.commands`. Permissions: Send Messages, Read Message History, Add Reactions, Manage Messages, Embed Links, Attach Files.

### 4. Wire OpenClaw

Add to your OpenClaw config:
```json
{
  "plugins": {
    "discord": {
      "token": "YOUR_BOT_TOKEN",
      "defaultChannel": "YOUR_ALERTS_CHANNEL_ID"
    }
  }
}
```

### 5. Test

Send a test message from OpenClaw:
```bash
openclaw send --channel discord --target "#alerts" "Bot online ✅"
```

## Next Steps

- `bot-setup.md` — Full bot creation walkthrough
- `channel-architecture.md` — Channel layout + permissions
- `research-pipeline.md` — Trending → research → content flow
- `content-approval.md` — Reaction-based script approval
- `competitor-monitor.md` — YouTube tracking setup
