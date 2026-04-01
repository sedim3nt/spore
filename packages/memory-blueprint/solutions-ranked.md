# 15 Agent Memory Solutions — Ranked

Ranked by: practical value for solo/small-team OpenClaw setups. Criteria: setup cost, maintenance burden, actual memory quality, composability.

---

## Tier 1: Do These First (High ROI, Low Complexity)

### 1. 📄 Daily Log Files (YYYY-MM-DD.md)
**Score: 9.5/10**

Simple markdown files in `memory/`. Agents read them at session start. Zero infrastructure.

- Setup: 5 minutes (create the directory, start logging)
- Maintenance: daily write, weekly cleanup
- Strengths: readable by humans, durable, version-controllable
- Weaknesses: manual retrieval unless you have search
- **Verdict: Required. No agent setup is complete without this.**

---

### 2. 📋 MEMORY.md (Curated Long-Term Facts)
**Score: 9/10**

Single file with distilled facts that don't change often. User preferences, infrastructure, account names, recurring patterns.

- Setup: 5 minutes
- Maintenance: add entries as discovered, prune quarterly
- Strengths: always available, highest signal-to-noise
- Weaknesses: manual curation required, can drift without discipline
- **Verdict: Required. Pair with daily logs.**

---

### 3. 📣 BULLETIN.md (Cross-Agent Announcements)
**Score: 8.5/10**

Shared message board for multi-agent systems. Prevents agents from re-doing work or conflicting.

- Setup: 10 minutes (create file, establish protocol)
- Maintenance: weekly cleanup
- Strengths: lightweight, solves coordination without infrastructure
- Weaknesses: requires agents to respect the protocol
- **Verdict: Essential for multi-agent setups.**

---

### 4. 🔍 MuninnDB (Local Vector Search)
**Score: 8.5/10**

Local vector database for semantic memory search. The right tool for "find relevant past context" without cloud dependencies.

- Setup: 30-60 minutes
- Maintenance: occasional reindex, periodic backup
- Strengths: semantic search, local/private, no API costs
- Weaknesses: requires Ollama running, disk space (~2GB per 100K memories)
- **Verdict: High value. Install this after daily logs.**

---

### 5. 🔧 OpenClaw Native Memory Search
**Score: 8/10**

Built-in file-based memory search with configurable embedding and retrieval. Requires tuning `minScore` and `alwaysInclude`.

- Setup: 15 minutes (config changes)
- Maintenance: periodic reindex
- Strengths: integrated, no extra process, works with existing files
- Weaknesses: less control than dedicated DB
- **Verdict: Enable and tune before adding external solutions.**

---

## Tier 2: Worth Adding (Medium ROI)

### 6. 🗄️ SQLite (Structured Agent Data)
**Score: 7.5/10**

Local relational DB for structured data: content logs, agent run history, approval records.

- Setup: 1 hour
- Maintenance: low
- Strengths: fast, local, queryable with SQL
- Weaknesses: not semantic, requires schema design
- **Verdict: Good for content logs and structured tracking.**

---

### 7. 🌐 Notion via MCP
**Score: 7/10**

Notion as a knowledge base. Writable by agents, readable by humans.

- Setup: 1-2 hours
- Maintenance: moderate (Notion API changes, page sharing management)
- Strengths: human-readable, good for collaborative notes, database queries
- Weaknesses: cloud dependency, API rate limits, costs at scale
- **Verdict: Good if you already use Notion. Overkill if you don't.**

---

### 8. 🐘 Supabase (Cloud Postgres + Storage)
**Score: 7/10**

Managed Postgres for agent data that needs to persist across machines or be accessed by multiple systems.

- Setup: 2-3 hours
- Maintenance: low (managed service)
- Strengths: scalable, accessible from anywhere, pgvector for vector search
- Weaknesses: cloud dependency, costs at scale
- **Verdict: Use for content history, published records, analytics.**

---

### 9. 📊 Open Projects Tracker (memory/open-projects.md)
**Score: 7/10**

Dedicated file tracking active coding projects, their status, and next steps.

- Setup: 5 minutes
- Maintenance: update as projects change
- Strengths: simple, prevents agents from losing track of multi-day work
- Weaknesses: manual maintenance
- **Verdict: Use if you have ongoing coding projects.**

---

### 10. 🔁 Session Flush Protocol (softThresholdTokens)
**Score: 6.5/10**

Configure OpenClaw to flush session context to memory before compaction hits.

- Setup: 20 minutes (config changes)
- Maintenance: none
- Strengths: prevents context loss in long sessions
- Weaknesses: flush quality depends on model summarization
- **Verdict: Enable this. Easy win.**

---

## Tier 3: Situational (Specific Use Cases)

### 11. 🗃️ Obsidian Vault as Knowledge Base
**Score: 6/10**

Use Obsidian for structured, linked notes. Agents can read via filesystem MCP.

- Setup: 2-4 hours
- Strengths: excellent for knowledge graphs, backlinks, tags
- Weaknesses: complex to write to programmatically
- **Verdict: Good if Obsidian is already your note-taking system.**

---

### 12. 🌲 pgvector (Postgres Vector Extension)
**Score: 6/10**

Vector search built into Postgres. Combines structured and semantic search.

- Setup: 3-5 hours
- Strengths: no separate vector DB, SQL queryable
- Weaknesses: more complex setup than MuninnDB
- **Verdict: Use if you're already on Postgres and want to consolidate.**

---

### 13. 🔗 LlamaIndex (Retrieval Pipeline)
**Score: 5.5/10**

Python framework for building retrieval-augmented generation (RAG) pipelines.

- Setup: 4-8 hours
- Strengths: highly configurable, many index types
- Weaknesses: heavy dependency, complex, overkill for small setups
- **Verdict: For teams building sophisticated RAG. Not for solo operators.**

---

### 14. 🧠 Langchain Memory (ConversationBufferMemory, etc.)
**Score: 5/10**

Langchain's built-in memory classes. More relevant for Python-based agent frameworks.

- Weaknesses: tied to Langchain ecosystem, doesn't integrate with OpenClaw natively
- **Verdict: Skip unless you're building custom Langchain pipelines.**

---

### 15. ☁️ Pinecone / Weaviate / Qdrant (Cloud Vector DBs)
**Score: 4.5/10**

Managed cloud vector databases. High performance at scale.

- Strengths: no infrastructure to manage, high throughput
- Weaknesses: cloud costs, privacy concerns, overkill for solo use
- **Verdict: Relevant at team/production scale. Too much for a Mac Mini setup.**

---

## Summary Table

| Rank | Solution | Setup | Maintenance | Value |
|------|----------|-------|-------------|-------|
| 1 | Daily logs | 5 min | Daily | 🔥🔥🔥 |
| 2 | MEMORY.md | 5 min | Occasional | 🔥🔥🔥 |
| 3 | BULLETIN.md | 10 min | Weekly | 🔥🔥🔥 |
| 4 | MuninnDB | 1 hr | Low | 🔥🔥🔥 |
| 5 | Native search | 15 min | Rare | 🔥🔥🔥 |
| 6 | SQLite | 1 hr | Low | 🔥🔥 |
| 7 | Notion MCP | 2 hr | Moderate | 🔥🔥 |
| 8 | Supabase | 2 hr | Low | 🔥🔥 |
| 9 | Open projects | 5 min | Moderate | 🔥🔥 |
| 10 | Flush protocol | 20 min | None | 🔥🔥 |
| 11 | Obsidian | 3 hr | Moderate | 🔥 |
| 12 | pgvector | 4 hr | Low | 🔥 |
| 13 | LlamaIndex | 6 hr | High | 🔥 |
| 14 | Langchain | 4 hr | High | — |
| 15 | Cloud vectors | 2 hr | Paid | — |

**Start with 1-5. Add 6-10 as you scale.**
