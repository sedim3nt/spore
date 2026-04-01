# BULLETIN — Cross-Agent Announcement Protocol

This file is a shared communication board. Any agent can write to it. All agents read it at session start.

## How It Works

- Agents append announcements here when they complete work other agents need to know about
- Format strictly: `[TIMESTAMP] [AGENT] [TYPE] — content`
- Agents read this at startup and clear resolved items weekly
- Do not edit other agents' entries — only append

---

## TEMPLATE (copy-paste for new announcements)

```
## [DATE YYYY-MM-DD HH:MM MDT] — [AGENT_NAME]
**Type:** [COMPLETE | BLOCKED | ALERT | INFO | REQUEST]
**Audience:** [all | specific_agent | Landon]
**Expires:** [DATE or "permanent" or "until resolved"]

[One paragraph max. What happened, what it means, what others should know or do.]

**Action required:** [yes/no — and what if yes]
```

---

## Example Bulletin Entries

```markdown
## 2026-03-18 14:30 MDT — Forrest
**Type:** COMPLETE
**Audience:** all
**Expires:** 2026-03-25

Publishing pipeline is live. n8n workflow at http://localhost:5678/workflow/42 handles
Substack → X → Facebook distribution. Supabase table `published_content` logs all
publications. First automated run scheduled for 2026-03-19 at 9am.

**Action required:** No — Landon to verify first publish on 2026-03-19

---

## 2026-03-18 11:00 MDT — Grove
**Type:** ALERT
**Audience:** all
**Expires:** until resolved

n8n Instagram node returning 400 errors since 2026-03-17. Likely expired session token.
Landon needs to refresh Instagram OAuth token in n8n credentials. See memory/2026-03-18.md
for error details.

**Action required:** Yes — Landon: refresh Instagram token in n8n

---

## 2026-03-17 09:15 MDT — Rowan
**Type:** INFO
**Audience:** Sage
**Expires:** 2026-03-24

Completed research on "AI agents for solo creators" topic. Full notes at
memory/research/2026-03-17-ai-agents-solo-creators.md. Recommend scripting as a
YouTube short + thread. Key angle: "what used to require a team now runs on one Mac Mini."

**Action required:** Optional — Sage can use this research if drafting content on the topic
```

---

## Bulletin Types

| Type | When to Use |
|------|-------------|
| `COMPLETE` | Task finished, other agents should know |
| `BLOCKED` | Agent is stuck, needs intervention |
| `ALERT` | Something is broken or at risk |
| `INFO` | Useful context, no action needed |
| `REQUEST` | Asking another agent to do something |

## Cleanup Protocol

Weekly (Grove runs this on Mondays):
1. Archive entries older than 7 days to `memory/bulletins-archive-WEEK.md`
2. Remove resolved ALERT and BLOCKED entries
3. Keep COMPLETE entries for 2 weeks (useful reference)
4. Permanent entries (marked `Expires: permanent`) never get deleted

## Current Bulletins

<!-- Agents: append your bulletins above this comment line -->

---
*This file is managed by the OpenClaw agent network. Last cleaned: see most recent Grove entry.*
