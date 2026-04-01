# BULLETIN.md — Cross-Agent Communication Protocol

This file is how agents talk to each other. The orchestrator writes here. Specialist agents read it at session start.

**Rules:**
- Orchestrator writes; specialists read
- Append new bulletins; never delete old ones
- Use ISO timestamps
- Max 5 active bulletins at once; archive older ones

---

## Active Bulletins

### [YYYY-MM-DD HH:MM] — Priority: HIGH | From: Orchestrator | To: ALL

**Status update:**
[What's the current state of the system / active project]

**Active priorities this week:**
1. [Priority 1]
2. [Priority 2]
3. [Priority 3]

**Known blockers:**
- [Blocker and who owns the resolution]

**Do NOT touch:**
- [Files, systems, or tasks off-limits this week]

---

### [YYYY-MM-DD HH:MM] — Priority: NORMAL | From: Orchestrator | To: Builder

**Task delegated:**
[Task name]

**Spec file:** `tasks/[task-slug].md`

**Expected output:** [What the builder should deliver]

**Deadline:** [Date or "ASAP"]

---

<!-- Add new bulletins above this line -->
<!-- Archive to BULLETIN-ARCHIVE.md when > 10 bulletins -->

---

## Protocol Reference

### Bulletin Format

```markdown
### [YYYY-MM-DD HH:MM] — Priority: HIGH/NORMAL/LOW | From: [Agent] | To: [Agent/ALL]

[Content]
```

### Priority Levels

- **HIGH** — affects all agents, read first
- **NORMAL** — relevant to named recipients
- **LOW** — FYI, no action required

### Agent Reading Order

All agents read this file at session start, after SOUL.md and their own ROLE.md.
Only the orchestrator writes to this file directly.
Specialists may request bulletin updates via their status file.

### Status File

Each agent writes their status to:
`content/agent-status/[agent-name].json`

```json
{
  "agent": "builder",
  "status": "working",
  "task": "auth-implementation",
  "last_updated": "2026-03-18T14:30:00Z",
  "blocking": null,
  "eta": "2026-03-18T16:00:00Z"
}
```
