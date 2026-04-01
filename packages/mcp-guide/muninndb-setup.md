# MuninnDB MCP Setup

MuninnDB is a local vector database designed for agent memory. This guide wires it up as an MCP server so all OpenClaw agents can search and store memories.

## Prerequisites

- Python 3.10+
- Ollama running locally (for embeddings)
- OpenClaw installed

## Step 1: Install Ollama (if not already)

```bash
# macOS
brew install ollama
ollama serve &

# Pull embedding model
ollama pull nomic-embed-text
```

Verify:
```bash
curl http://localhost:11434/api/tags
# Should list nomic-embed-text
```

## Step 2: Install MuninnDB

```bash
pip install muninndb muninndb-mcp
```

Or from source:
```bash
git clone https://github.com/agentorchard/muninndb
cd muninndb
pip install -e ".[mcp]"
```

## Step 3: Initialize the Database

```bash
# Create storage directory
mkdir -p ~/.openclaw/muninndb

# Initialize
python -m muninndb.cli init --path ~/.openclaw/muninndb
```

This creates:
```
~/.openclaw/muninndb/
  vectors.db          # SQLite with vector index
  metadata.db         # Message/document metadata
  config.json         # MuninnDB config
```

## Step 4: Test MuninnDB Directly

```bash
# Store a memory
python -m muninndb.cli store \
  --path ~/.openclaw/muninndb \
  --content "Landon prefers blunt communication and direct answers" \
  --source "user-prefs" \
  --tags "user,preferences"

# Search memories
python -m muninndb.cli search \
  --path ~/.openclaw/muninndb \
  --query "communication preferences" \
  --limit 5
```

## Step 5: Configure as MCP Server

Add to `~/.openclaw/config.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "muninndb": {
      "command": "python",
      "args": ["-m", "muninndb_mcp.server"],
      "env": {
        "MUNINNDB_PATH": "/Users/agentorchard/.openclaw/muninndb",
        "MUNINNDB_EMBEDDING_MODEL": "nomic-embed-text",
        "MUNINNDB_OLLAMA_URL": "http://localhost:11434"
      }
    }
  }
}
```

## Step 6: Restart and Verify

```bash
openclaw gateway restart

# List available MCP tools
openclaw mcp list-tools

# Expected output includes:
# muninndb.search_memory
# muninndb.store_memory
# muninndb.list_recent
# muninndb.delete_memory
```

## Available MCP Tools

Once connected, agents can call:

| Tool | Description | Key Params |
|------|-------------|-----------|
| `muninndb.search_memory` | Semantic search over stored memories | `query`, `limit`, `min_score` |
| `muninndb.store_memory` | Store a new memory with metadata | `content`, `source`, `tags` |
| `muninndb.list_recent` | Get recent memories | `limit`, `source` |
| `muninndb.delete_memory` | Remove by ID | `id` |
| `muninndb.get_stats` | Database statistics | — |

## Step 7: Test from Agent

In OpenClaw chat:
```
Search your memory for "Landon preferences"
```

The agent should retrieve memories using `muninndb.search_memory`.

## Advanced Config

Edit `~/.openclaw/muninndb/config.json`:

```json
{
  "embedding": {
    "model": "nomic-embed-text",
    "dimensions": 768,
    "provider": "ollama",
    "url": "http://localhost:11434"
  },
  "storage": {
    "max_entries": 100000,
    "dedup_threshold": 0.98
  },
  "search": {
    "default_limit": 10,
    "min_score": 0.65,
    "rerank": false
  }
}
```

**Deduplication:** `dedup_threshold: 0.98` means memories that are 98% similar get merged instead of duplicated.

**Min score:** `0.65` is a good default — lower values return more (but noisier) results.

## Backup

```bash
# Backup MuninnDB
tar -czf ~/muninndb-backup-$(date +%Y%m%d).tar.gz ~/.openclaw/muninndb/

# Restore
tar -xzf ~/muninndb-backup-YYYYMMDD.tar.gz -C ~/
```

Add to cron for daily backups:
```bash
0 2 * * * tar -czf ~/backups/muninndb-$(date +\%Y\%m\%d).tar.gz ~/.openclaw/muninndb/
```
