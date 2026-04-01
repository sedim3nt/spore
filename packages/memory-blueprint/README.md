# Memory Blueprint — Agent Memory Architecture

## The Core Problem

Every Claude conversation starts fresh. Without a memory system, agents repeat research, forget preferences, and can't build on past work. This blueprint solves that.

## The 80/20 Rule of Agent Memory

80% of value comes from 20% of your memory architecture:

1. **Daily logs** — what happened today, decisions made, blockers
2. **Curated long-term memory** — distilled facts that rarely change
3. **Semantic search** — find relevant past context without manual retrieval

Everything else (fancy graph databases, complex schemas, multi-tier hierarchies) is optimization you can add later.

## Memory Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    AGENT CONTEXT                        │
│   (what fits in context window right now)               │
├─────────────────────────────────────────────────────────┤
│                  HOT MEMORY (files)                     │
│   MEMORY.md     — curated long-term facts               │
│   YYYY-MM-DD.md — today's log                           │
│   BULLETIN.md   — cross-agent announcements             │
├─────────────────────────────────────────────────────────┤
│               WARM MEMORY (vector search)               │
│   MuninnDB      — semantic search over past sessions    │
│   Embeddings    — nomic-embed-text via Ollama           │
├─────────────────────────────────────────────────────────┤
│              COLD MEMORY (structured data)              │
│   Supabase      — content history, agent logs           │
│   SQLite        — local structured agent data           │
└─────────────────────────────────────────────────────────┘
```

## What's in This Package

| File | What It Covers |
|------|---------------|
| `native-config.md` | OpenClaw memory search config (tune retrieval) |
| `flush-tuning.md` | Pre-compaction flush settings (softThresholdTokens) |
| `muninndb-setup.md` | MuninnDB install + MCP integration |
| `BULLETIN.md` | Cross-agent announcement template |
| `daily-log-template.md` | Standard daily log format |
| `solutions-ranked.md` | 15 memory solutions compared |

## Quick Start

### Minimum viable memory system (30 minutes)

1. Create `MEMORY.md` in your workspace root
2. Create `memory/` directory for daily logs
3. Use `daily-log-template.md` format for daily logs
4. Configure `softThresholdTokens` (see `flush-tuning.md`)
5. Instruct agents to read `MEMORY.md` + today's log at session start

That's it. This alone prevents 80% of context loss.

### Add vector search (2 hours)

Follow `muninndb-setup.md` to wire up MuninnDB. Now agents can semantically search all past sessions.

### Add cross-agent coordination (1 hour)

Use `BULLETIN.md` protocol so multiple agents share announcements without collision.

## Session Startup Protocol

Every agent session should begin with:

```
1. Read SOUL.md          (personality + operating principles)
2. Read USER.md          (user preferences + background)
3. Read memory/TODAY.md  (what happened today)
4. Read memory/YESTERDAY.md (continuity)
5. Read MEMORY.md        (curated long-term facts)
6. Read BULLETIN.md      (cross-agent announcements)
```

Total: ~5-15K tokens. Worth every token.

## Memory Write Discipline

**Write when it matters:**
- Decisions made (especially irreversible ones)
- Preferences discovered about the user
- Technical facts about the codebase or infrastructure
- Failures and what caused them
- External account IDs, credentials structure (not secrets)
- Content published (title, platform, date)

**Don't write:**
- Routine completed tasks without lessons
- Temporary state that doesn't compound
- Summaries of summaries
