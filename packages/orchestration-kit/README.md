# Orchestration Kit

**Version:** 1.0 | **Setup Time:** 30–60 minutes

Multi-agent architecture for serious operators. One orchestrator. Six specialists. A cross-agent communication protocol that keeps everyone synchronized. Production-tested.

## Quick Start

1. Copy role definitions to your agents directory:
   ```bash
   mkdir -p ~/.openclaw/workspace/agents
   for role in orchestrator research builder writer ops artist; do
     cp roles/$role.md ~/.openclaw/workspace/agents/$role/ROLE.md
   done
   ```
2. Customize each ROLE.md with your specific tools and constraints
3. Set up the BULLETIN protocol (see `BULLETIN.md`)
4. Initialize status tracking:
   ```bash
   cp templates/status-file.json ~/.openclaw/workspace/content/agent-status.json
   ```
5. Run your first multi-agent task: tell the orchestrator what you need done

## Architecture

```
You (Human)
    │
    ▼
Orchestrator (Claude Opus)
    ├── Research Agent (Claude Sonnet)
    ├── Builder Agent (Claude Sonnet)
    ├── Writer Agent (Claude Sonnet)
    ├── Ops Agent (Claude Sonnet)
    └── Artist Agent (GPT Image or similar)
```

**Key principle:** The orchestrator delegates and synthesizes. It doesn't do the work — specialists do. If the orchestrator is writing code, the architecture is broken.

## Cross-Agent Communication

Agents communicate via shared files (not real-time):
- **BULLETIN.md** — broadcast from orchestrator to all agents
- **Status files** — each agent writes its current state
- **Handoff files** — structured data passed agent-to-agent

## Files Included

| File | Purpose |
|------|---------|
| roles/orchestrator.md | CEO agent: strategic planning + delegation |
| roles/research.md | Research and intelligence |
| roles/builder.md | Software development |
| roles/writer.md | Content and publishing |
| roles/ops.md | Infrastructure and monitoring |
| roles/artist.md | Visual asset generation |
| BULLETIN.md | Cross-agent communication protocol |
| templates/status-file.json | Agent status tracking schema |
| templates/handoff.md | Structured task handoff template |
| FAILURE-MODEL.md | How to handle agent failure patterns |
