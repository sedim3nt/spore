# Discord Bot Setup — Step-by-Step

## Step 1: Create the Application

1. Go to [discord.com/developers/applications](https://discord.com/developers/applications)
2. Click **New Application**
3. Name it (e.g., `AgentOrchard Agent`) → Create
4. Copy the **Application ID** — you'll need it later

## Step 2: Create the Bot

1. Left sidebar → **Bot**
2. Click **Add Bot** → Yes, do it
3. Under **Token** → click **Reset Token** → copy and store it securely
   - Store as env var: `DISCORD_BOT_TOKEN=your_token_here`
   - Never commit this to git

### Bot Settings (Privileged Gateway Intents)

Enable these under Bot settings:
- ✅ **Message Content Intent** — required to read messages for approval workflow
- ✅ **Server Members Intent** — optional, for DM escalation
- ✅ **Presence Intent** — optional

## Step 3: Set Permissions

Under **OAuth2 → URL Generator**:

**Scopes:**
- `bot`
- `applications.commands`

**Bot Permissions:**
| Permission | Why |
|---|---|
| Read Messages/View Channels | See channel content |
| Send Messages | Post alerts and drafts |
| Send Messages in Threads | Thread-based approvals |
| Embed Links | Rich embeds for research |
| Attach Files | Send JSON/PDF exports |
| Add Reactions | Auto-react for UI affordance |
| Manage Messages | Delete old alerts |
| Read Message History | React-based approval polling |
| Use External Emojis | Custom status emojis |

## Step 4: Generate Invite URL

1. OAuth2 → URL Generator
2. Select scopes and permissions above
3. Copy the generated URL
4. Open in browser, select your server → Authorize

## Step 5: Get Channel IDs

Enable Developer Mode: Discord Settings → Advanced → Developer Mode ON

Right-click any channel → **Copy Channel ID**

You'll need IDs for:
- `#alerts`
- `#research`
- `#scripts`
- `#approved`
- `#competitor-monitor`

## Step 6: Configure OpenClaw

In your OpenClaw config (typically `~/.openclaw/config.json`):

```json
{
  "plugins": {
    "discord": {
      "token": "${DISCORD_BOT_TOKEN}",
      "guilds": ["YOUR_GUILD_ID"],
      "channels": {
        "alerts": "CHANNEL_ID_ALERTS",
        "research": "CHANNEL_ID_RESEARCH",
        "scripts": "CHANNEL_ID_SCRIPTS",
        "approved": "CHANNEL_ID_APPROVED",
        "competitor": "CHANNEL_ID_COMPETITOR"
      }
    }
  }
}
```

Set the token in your shell profile:
```bash
echo 'export DISCORD_BOT_TOKEN="your_token_here"' >> ~/.zshrc
source ~/.zshrc
```

## Step 7: Test the Connection

```bash
# Verify bot is online
curl -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  https://discord.com/api/v10/users/@me

# Expected: JSON with your bot's username
```

## Step 8: Verify in Discord

The bot should appear in your server's member list with online status when OpenClaw is running.

If offline: check that OpenClaw gateway is running (`openclaw gateway status`) and the token is correct.

## Troubleshooting

**Bot appears offline:**
- Verify token is correct and not expired
- Confirm `openclaw gateway status` shows running
- Check firewall isn't blocking outbound WebSocket connections

**Missing permissions errors:**
- Re-generate invite URL with correct permissions
- Kick the bot and re-invite with the new URL

**Cannot read messages:**
- Ensure Message Content Intent is enabled in developer portal
- This requires verification for bots in 100+ servers
