# Channel Architecture — Recommended Layout

## Category Structure

```
📁 OPERATIONS
  #alerts           — System alerts, agent health, errors
  #logs             — Verbose agent logs (muted by default)

📁 RESEARCH
  #research         — Agent-posted research summaries
  #trending         — Trending topic feeds (auto-posted)
  #bookmarks        — Saved links from research runs

📁 CONTENT
  #scripts          — Draft scripts awaiting approval
  #approved         — Scripts that passed ✅ review
  #rejected         — Scripts that got ❌ (for audit)
  #published        — Confirmation when content goes live

📁 COMPETITOR INTEL
  #competitor-yt    — YouTube competitor video alerts
  #competitor-x     — Trending X posts from competitors
  #competitor-notes — Manual competitor analysis notes

📁 PROJECTS
  #projects-general — Cross-project coordination
  #ideas            — Backlog of ideas (any agent can post)
  #shipping         — What launched this week
```

## Setting Up Categories

1. Right-click in the channel list → **Create Category**
2. Name it (e.g., `OPERATIONS`)
3. Right-click the category → **Create Channel**
4. Set channel type: Text

## Permissions by Category

### OPERATIONS (restricted)
- `@everyone` → No read access
- `@agents` role → Read + Write
- `@admins` → Full access

### RESEARCH (read-only for humans)
- `@everyone` → Read only
- `@agents` role → Read + Write

### CONTENT (approval workflow)
- `@everyone` → Read only + Add Reactions
- `@agents` role → Read + Write + Add Reactions
- `@admins` → Manage Messages (to delete after processing)

### COMPETITOR INTEL (read-only)
- `@everyone` → Read only
- `@agents` role → Write

### PROJECTS (collaborative)
- `@everyone` → Read + Write
- `@agents` role → Read + Write

## Creating the `@agents` Role

1. Server Settings → Roles → Create Role
2. Name: `agents`
3. Color: something distinct (e.g., cyan)
4. Permissions: Send Messages, Embed Links, Add Reactions, Attach Files
5. Assign to your bot user

## Notification Strategy

**Mute by default:**
- `#logs` — too noisy
- `#bookmarks` — reference only
- `#rejected` — audit trail

**Enable notifications:**
- `#alerts` — @here for critical issues
- `#scripts` — @here when new draft ready for review
- `#published` — celebrate wins

## Channel Topics (Set These)

```
#alerts      → "Agent health + system alerts. Auto-posted by OpenClaw."
#scripts     → "Draft scripts. React ✅ to approve, ❌ to reject. No manual edits here."
#approved    → "Approved scripts ready to publish. Do not edit."
#competitor-yt → "YouTube competitor video alerts. Updated every 6 hours."
```

## Slash Command Channels

If you use Discord slash commands for agent control, create:
```
#commands    → Dedicated channel for /agent commands
```

This keeps command noise out of content channels.

## Thread Strategy

For `#scripts`, use threads per script instead of separate messages:
- Thread name = script title
- First message = full script
- Thread contains approval discussion
- React on the first message to trigger approval workflow

Enable **Forum Channel** type for `#scripts` if you want structured tagging (e.g., `platform:youtube`, `status:pending`).
