# MuninnDB — Installation + MCP Integration

MuninnDB is a local vector database for agent memory. Stores and retrieves memories semantically — meaning you search by meaning, not keywords.

Named after Odin's raven Muninn (Memory), which is the right energy.

## Install

### Prerequisites

```bash
# Python 3.10+
python --version

# Ollama for embeddings
brew install ollama
ollama serve &
ollama pull nomic-embed-text
```

### Install MuninnDB

```bash
pip install muninndb muninndb-mcp
```

Verify:
```bash
python -m muninndb.cli --version
```

## Initialize

```bash
mkdir -p ~/.openclaw/muninndb
python -m muninndb.cli init --path ~/.openclaw/muninndb
```

Output:
```
✅ Initialized MuninnDB at /Users/you/.openclaw/muninndb
   - vectors.db: 0 entries
   - config.json: created
   - Embedding model: nomic-embed-text (768 dims)
```

## Basic Operations

### Store a memory

```bash
python -m muninndb.cli store \
  --path ~/.openclaw/muninndb \
  --content "Landon prefers Supabase for persistent storage and uses Vercel for deployment" \
  --source "user-prefs" \
  --tags "preferences,infrastructure"
```

### Search memories

```bash
python -m muninndb.cli search \
  --path ~/.openclaw/muninndb \
  --query "what database does Landon prefer?" \
  --limit 5
```

Output:
```
Score  Source        Content
0.89   user-prefs    Landon prefers Supabase for persistent storage...
0.72   agent-log     Used Supabase for content storage in publishing pipeline...
```

### List recent memories

```bash
python -m muninndb.cli list \
  --path ~/.openclaw/muninndb \
  --limit 20 \
  --since "2026-03-15"
```

### Delete a memory

```bash
# Get the ID from search output
python -m muninndb.cli delete \
  --path ~/.openclaw/muninndb \
  --id "mem_abc123"
```

### Stats

```bash
python -m muninndb.cli stats --path ~/.openclaw/muninndb
```

```
Total memories:    1,247
Total sources:     12
Oldest entry:      2026-01-15
Storage size:      24.3 MB
```

## Wire Up as MCP Server

Add to `~/.openclaw/config.json`:

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

Restart OpenClaw:
```bash
openclaw gateway restart
openclaw mcp list-tools | grep muninndb
```

Expected tools:
```
muninndb.search_memory      Semantic search over stored memories
muninndb.store_memory       Store a new memory with metadata
muninndb.list_recent        Get recent memories by source/date
muninndb.delete_memory      Remove a memory by ID
muninndb.get_stats          Database statistics
```

## Auto-Store Session Context

Configure MuninnDB to automatically store key context from each session:

```json
{
  "memory": {
    "autoStore": {
      "enabled": true,
      "provider": "muninndb",
      "triggers": [
        "session_end",
        "flush_event",
        "user_preference_detected"
      ],
      "extractTypes": [
        "user_preferences",
        "technical_decisions",
        "file_locations",
        "published_content",
        "error_patterns"
      ]
    }
  }
}
```

## Bulk Import Existing Files

Import your existing workspace into MuninnDB:

```bash
python -m muninndb.cli import \
  --path ~/.openclaw/muninndb \
  --source-dir ~/.openclaw/workspace/memory \
  --recursive \
  --file-types ".md,.txt" \
  --source "workspace-import"
```

This embeds and stores all markdown files. Takes a few minutes.

## MuninnDB Config

Edit `~/.openclaw/muninndb/config.json`:

```json
{
  "embedding": {
    "model": "nomic-embed-text",
    "dimensions": 768,
    "provider": "ollama",
    "url": "http://localhost:11434",
    "batchSize": 32
  },
  "storage": {
    "maxEntries": 500000,
    "dedupThreshold": 0.97,
    "compressionEnabled": true
  },
  "search": {
    "defaultLimit": 10,
    "minScore": 0.60,
    "rerank": false,
    "rerankModel": null
  },
  "retention": {
    "enabled": false,
    "maxAgeDays": 365,
    "protectedSources": ["user-prefs", "workspace-import"]
  }
}
```

## Backup + Restore

```bash
# Backup
tar -czf ~/backups/muninndb-$(date +%Y%m%d).tar.gz ~/.openclaw/muninndb/

# Restore
tar -xzf ~/backups/muninndb-20260318.tar.gz -C ~/

# Verify after restore
python -m muninndb.cli stats --path ~/.openclaw/muninndb
```

Automate daily backups:
```bash
# crontab -e
0 2 * * * tar -czf ~/backups/muninndb-$(date +\%Y\%m\%d).tar.gz ~/.openclaw/muninndb/ && find ~/backups -name "muninndb-*.tar.gz" -mtime +30 -delete
```

## Performance Notes

- **Cold start:** First embedding of a new Ollama model is slow (model loading). Subsequent calls are fast.
- **Disk:** ~100K memories ≈ 2GB (depends on content length)
- **Search speed:** Under 100ms for 100K memories on modern hardware
- **Embedding speed:** ~50 memories/second on M-series Mac
