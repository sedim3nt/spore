# Content Approval Flow — Reaction-Based

## How It Works

Scripts posted to `#scripts` use Discord reactions as the approval UI. No forms, no buttons — just emoji reactions on the message.

```
Agent posts script → You react ✅ or ❌ → n8n webhook fires → content queued or archived
```

## Reaction Meanings

| Reaction | Action |
|----------|--------|
| ✅ | Approve — queue for publishing |
| ❌ | Reject — archive in `#rejected` |
| 🔄 | Revision needed — ping agent to revise |
| 🔥 | Boost — approve AND prioritize (publish today) |
| ⏳ | Hold — approve but delay publishing |

## n8n Webhook Setup

### 1. Create a Discord webhook listener in n8n

**Trigger:** Webhook node (POST)

Configure Discord to send reaction events to your n8n webhook using a bot (not webhook URL — you need the bot to listen for reaction events).

### 2. Bot listener code (add to OpenClaw or standalone)

```javascript
// reaction-handler.js
const { Client, GatewayIntentBits } = require('discord.js');

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessageReactions,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
  ]
});

const SCRIPTS_CHANNEL_ID = process.env.SCRIPTS_CHANNEL_ID;
const APPROVED_CHANNEL_ID = process.env.APPROVED_CHANNEL_ID;
const REJECTED_CHANNEL_ID = process.env.REJECTED_CHANNEL_ID;
const N8N_WEBHOOK_URL = process.env.N8N_APPROVAL_WEBHOOK;

client.on('messageReactionAdd', async (reaction, user) => {
  if (user.bot) return;
  if (reaction.message.channelId !== SCRIPTS_CHANNEL_ID) return;

  const emoji = reaction.emoji.name;
  const messageContent = reaction.message.content;

  const payload = {
    action: emoji,
    messageId: reaction.message.id,
    content: messageContent,
    reactor: user.username,
    timestamp: new Date().toISOString(),
  };

  // Forward to n8n
  await fetch(N8N_WEBHOOK_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  // Move to appropriate channel
  if (emoji === '✅' || emoji === '🔥') {
    const approvedChannel = reaction.message.guild.channels.cache.get(APPROVED_CHANNEL_ID);
    await approvedChannel.send(`✅ **APPROVED** by ${user.username}\n\n${messageContent}`);
  } else if (emoji === '❌') {
    const rejectedChannel = reaction.message.guild.channels.cache.get(REJECTED_CHANNEL_ID);
    await rejectedChannel.send(`❌ **REJECTED** by ${user.username}\n\n${messageContent}`);
  }
});

client.login(process.env.DISCORD_BOT_TOKEN);
```

### 3. n8n Approval Workflow

After receiving the webhook:

```
Webhook → Switch (by emoji) →
  ✅ → "Publish Queue" node → Substack/X/IG API
  ❌ → "Archive" node → log to Supabase
  🔄 → "Revision Request" → Discord DM to agent
  🔥 → "Priority Queue" → immediate publish
  ⏳ → "Scheduled Queue" → publish at next window
```

### 4. Environment Variables

```bash
SCRIPTS_CHANNEL_ID=123456789
APPROVED_CHANNEL_ID=123456790
REJECTED_CHANNEL_ID=123456791
N8N_APPROVAL_WEBHOOK=http://localhost:5678/webhook/approval
DISCORD_BOT_TOKEN=your_bot_token
```

## Auto-Archive Stale Scripts

Scripts not reacted to in 48 hours should be auto-archived. Add to n8n:

1. **Schedule Trigger** → every 6 hours
2. **Discord Get Messages** → fetch `#scripts` channel, last 100 messages
3. **Filter** → messages older than 48 hours with no ✅/❌
4. **Discord Send** to `#rejected` → "Auto-archived: no review in 48h"
5. **Discord Delete** → remove from `#scripts`

## Audit Trail

All approved/rejected scripts should be logged to Supabase for tracking:

```sql
CREATE TABLE content_approvals (
  id uuid DEFAULT gen_random_uuid(),
  discord_message_id text,
  title text,
  action text,  -- approved|rejected|revision|hold
  reactor text,
  script_content text,
  created_at timestamptz DEFAULT now()
);
```

Insert on each approval event from n8n using the Supabase node.

## Revision Flow

When 🔄 is reacted:
1. Bot DMs Sage agent with the original script + "Revision requested"
2. Sage posts a new draft as a thread reply on the original message
3. Original message gets 🔄 auto-reacted to show it's in revision
4. When revision is ready, bot pings the channel: "@here Revised draft ready for review"
