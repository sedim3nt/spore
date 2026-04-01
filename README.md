# 🌱 Spore

**Production-ready AI agent configurations. Free. Open source. No catch.**

Spore is the open source agent configuration library from [SpiritTree](https://spirittree.dev). Every agent config, skill template, and orchestration pattern we use in production — given away for free.

## Why

Agent configs are commoditizing. Within 12 months, selling agent templates will be like selling website templates in 2015 — a race to zero. So instead of fighting that, we're accelerating it.

Every config in this library is battle-tested. These aren't demos. They're the actual configurations running our 8-agent fleet across 13 live sites.

## Install

```bash
npx @spirittree/spore init
```

Or browse and copy what you need:

```bash
# Get a specific agent
npx @spirittree/spore add ceo-stack

# Get a skill
npx @spirittree/spore add content-pipeline

# List everything
npx @spirittree/spore list
```

## What's Inside

### Agents (Personas)
Production agent configurations with SOUL.md, AGENTS.md, IDENTITY.md, HEARTBEAT.md, and role-specific skills.

| Agent | Role | Model | Description |
|-------|------|-------|-------------|
| `ceo-stack` | Orchestrator | Opus | Full CEO operations — routing, priorities, fleet management |
| `research-analyst` | Research | Sonnet | Deep research, synthesis, daily intel briefings |
| `content-engine` | Content | Opus | Writing, editing, publishing across platforms |
| `coding-agent` | Engineering | Sonnet | Blueprint pattern, PR review, refactoring |
| `ops-monitor` | Operations | Sonnet | System monitoring, cron management, automation |
| `solopreneur-ceo` | Solo Ops | Opus | One-person company operations stack |
| `freelancer-ops` | Freelance | Sonnet | Client delivery, invoicing, project management |
| `financial-analyst` | Finance | Sonnet | Revenue tracking, Stripe dashboards, projections |

### Skills
Plug-and-play capability modules that any agent can use.

| Skill | Description |
|-------|-------------|
| `content-pipeline` | Multi-agent content production (research → write → edit → publish) |
| `memory-blueprint` | Memory architecture with daily logs, MEMORY.md, and embeddings |
| `cron-toolkit` | Cron job management, scheduling, heartbeat monitoring |
| `social-automation` | X, Bluesky, Facebook posting with queue management |
| `research-briefing` | Daily research gathering from web, YouTube, social feeds |
| `discord-setup` | Multi-channel Discord agent architecture |
| `mcp-guide` | MCP server integration (Notion, custom servers, MuninnDB) |
| `n8n-recipes` | Workflow automation recipes for n8n |

### Guides
Step-by-step documentation for common agent operations.

| Guide | Description |
|-------|-------------|
| `quick-start` | Get your first agent running in 15 minutes |
| `multi-agent-orchestration` | Patterns for running multiple agents |
| `cost-optimizer` | Reduce your agent costs by 60%+ |
| `security-checklist` | Harden your agent deployment |
| `frontier-ops` | Advanced patterns for production agent fleets |

## Philosophy

- **Free forever.** The code is MIT licensed. Use it however you want.
- **Battle-tested.** Every config runs in production. We eat our own cooking.
- **Opinionated.** We made choices. You can change them, but the defaults work.
- **No lock-in.** Works with any OpenClaw setup. No proprietary dependencies.

## The Ecosystem

Spore is the open source foundation. The paid ecosystem built on top:

- **[Agent Orchard](https://agentorchard.dev)** — Managed hosting, one-click deploys
- **[Agent Vitals](https://vitals.spirittree.dev)** — Cognitive monitoring dashboard
- **Community** — [Discord](https://discord.gg/spirittree) · [X](https://x.com/sedim3nt) · [Substack](https://sedim3nt.substack.com)

## Contributing

PRs welcome. If you've built a useful agent config or skill, open a PR. We'll review it, test it, and if it works, it joins the library.

## License

MIT. Do whatever you want. Credit appreciated but not required.

---

*Built by [Sedim3nt](https://x.com/sedim3nt) 🦋 — an autonomous intelligence network rooted in care.*

*The fruiting body is not the organism.*
