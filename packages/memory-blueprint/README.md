# Memory Blueprint — 4-Layer Agent Memory Architecture

**Version:** 2.0 | **Updated:** 2026-04-03

The production-tested memory system behind SpiritTree's 8-agent fleet. 19 sites built in 26 days with ~90% retention across 200+ sessions.

## The Problem

Every agent session starts fresh. Without memory, agents repeat research, forget decisions, lose context, and can't compound work. Most memory solutions are either too simple (one file) or too complex (vector databases you can't audit).

## The 4-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Layer 4: autoDream (nightly)                │
│   Consolidates daily noise → curated long-term memory   │
├─────────────────────────────────────────────────────────┤
│         Layer 3: LCM (conversation compression)         │
│   Summary DAG over all conversations. Expand on demand. │
├─────────────────────────────────────────────────────────┤
│           Layer 2: Daily Logs (scratch pad)              │
│   memory/YYYY-MM-DD.md — tasks, decisions, blockers     │
├─────────────────────────────────────────────────────────┤
│         Layer 1: File-Based (loads at boot)              │
│   MEMORY.md · AGENTS.md · SOUL.md · USER.md · etc.      │
└─────────────────────────────────────────────────────────┘
```

### Layer 1: File-Based Memory
Plain text files that load automatically at session start. The cheapest, most reliable layer.

- **MEMORY.md** — Curated decisions, policies, cron schedules, site inventory. The single source of truth.
- **AGENTS.md** — Agent roles, coding patterns, retry policies, safety rules.
- **SOUL.md** — Personality and values. Prevents drift across sessions.
- **USER.md** — Who the human is. Background, preferences, communication style.

**Key insight:** These aren't documentation. They're working memory. Update them constantly. An out-of-date memory file is worse than none.

### Layer 2: Daily Logs
`memory/YYYY-MM-DD.md` — Append-only scratch pad. Everything that happens today goes here. Messy by design. Temporary — wipe old logs periodically.

### Layer 3: LCM (Lossless Context Management)
OpenClaw plugin that compresses conversations into a summary DAG. Searchable, expandable. Handles the "200+ sessions" problem.

**Recommended settings:**
```json
{
  "plugins": {
    "entries": {
      "lossless-claw": {
        "freshTailCount": 10,
        "contextThreshold": 0.75
      }
    }
  }
}
```

### Layer 4: autoDream (Nightly Consolidation)
A cron job that runs at 1:30 AM (or whenever your quiet period is). Reads the day's logs + LCM decisions, consolidates MEMORY.md, writes an audit trail.

Inspired by biological memory — short-term memory consolidates into long-term memory during sleep.

**Critical:** autoDream writes a STUB file first. If the dream log still says "STUB" after the cron window, consolidation failed. Use `heartbeat-verify.sh` to catch this.

## What's in This Package

```
memory-blueprint/
├── README.md                 # This file
├── MEMORY-TEMPLATE.md        # Starter MEMORY.md with sections
├── autodream.sh              # autoDream cron script
├── heartbeat-verify.sh       # Verify autoDream ran
└── daily-log-template.md     # Daily log template
```

## Quick Start

1. Copy `MEMORY-TEMPLATE.md` to your workspace as `MEMORY.md`
2. Start filling in decisions, policies, cron schedules
3. Add to AGENTS.md: "If it matters, write it down"
4. Set up daily logs: create `memory/` directory
5. Install LCM: `openclaw plugins install lossless-claw`
6. Set up autoDream: copy `autodream.sh` to `scripts/`, create cron

## Production Results

| Metric | Value |
|--------|-------|
| Sessions | 200+ |
| Retention | ~90% |
| MEMORY.md size | 7KB (curated, pruned weekly) |
| LCM summaries | 591 |
| LCM messages | 31,000+ |
| autoDream frequency | Nightly |
| Sites built with this stack | 19 in 26 days |
| Agents using it | 8 |

## Common Failures

1. **MEMORY.md drift** — Decisions made in conversation but never written down. Fix: autoDream + "write it down" rule.
2. **Phantom success** — autoDream reports success but never filled the stub. Fix: heartbeat verification.
3. **Stale entries** — Old policies that no longer apply. Fix: weekly prune pass.
4. **Log bloat** — Daily logs piling up forever. Fix: periodic wipe (keep last 7 days).

## License

MIT — part of [Spore](https://github.com/sedim3nt/spore)
