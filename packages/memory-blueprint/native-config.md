# OpenClaw Native Memory Config — Search Optimization

OpenClaw includes a built-in memory search system separate from external databases like MuninnDB. This doc covers how to tune it.

## Config Location

```bash
~/.openclaw/config.json
```

## Memory Search Config Block

```json
{
  "memory": {
    "search": {
      "enabled": true,
      "provider": "native",
      "indexPaths": [
        "~/.openclaw/workspace",
        "~/.openclaw/workspace/memory"
      ],
      "excludePaths": [
        "node_modules",
        ".git",
        "*.zip",
        "*.db"
      ],
      "maxResults": 10,
      "minScore": 0.65,
      "chunkSize": 500,
      "chunkOverlap": 50,
      "rerank": false,
      "embeddingModel": "nomic-embed-text",
      "ollamaUrl": "http://localhost:11434"
    },
    "injection": {
      "enabled": true,
      "maxTokens": 2000,
      "strategy": "relevance",
      "alwaysInclude": [
        "MEMORY.md",
        "SOUL.md",
        "USER.md"
      ]
    }
  }
}
```

## Key Parameters Explained

### `minScore` (0.0 – 1.0)
Controls how relevant a memory must be before it's included.

| Value | Effect |
|-------|--------|
| 0.50 | More results, more noise |
| 0.65 | Good default — balanced |
| 0.75 | Fewer results, higher precision |
| 0.85 | Only very strong matches |

**Start at 0.65.** If agents are missing context, lower to 0.60. If results are noisy/irrelevant, raise to 0.70.

### `maxResults`
How many memory chunks to retrieve per query.

- `5` — lean context, fast
- `10` — good default
- `20` — for deep research tasks (watch context usage)

### `chunkSize` (tokens)
How large each indexed chunk is.

- `300` — fine-grained, better for facts
- `500` — default, good for notes
- `800` — better for narrative/prose files

### `chunkOverlap` (tokens)
Overlap between chunks so context isn't cut mid-sentence.

- `50` — default, appropriate for most uses
- `100` — better for dense technical docs

### `alwaysInclude`
Files injected into every session regardless of relevance score. Keep this list short — every token counts.

Recommended always-include:
```json
["MEMORY.md", "SOUL.md", "USER.md"]
```

Don't add daily logs here — they change daily and should be loaded via session startup protocol instead.

## Strategy Options

### `"strategy": "relevance"`
Default. Retrieves most semantically similar chunks to the current query. Good for most use cases.

### `"strategy": "recency"`
Prioritizes recent memories. Good for sessions where "what happened recently" matters more than semantic similarity.

### `"strategy": "hybrid"`
Combines recency and relevance. Recommended for long-running projects where both matter.

```json
{
  "injection": {
    "strategy": "hybrid",
    "hybridWeights": {
      "relevance": 0.7,
      "recency": 0.3
    }
  }
}
```

## Tuning for Different Agent Types

### Rowan (Research Agent)
```json
{
  "maxResults": 15,
  "minScore": 0.60,
  "strategy": "relevance"
}
```
More results, lower threshold — capture everything potentially related.

### Sage (Content Agent)
```json
{
  "maxResults": 8,
  "minScore": 0.70,
  "strategy": "hybrid",
  "alwaysInclude": ["MEMORY.md", "SOUL.md", "USER.md", "brand-voice.md"]
}
```
Include brand voice, higher precision.

### Forrest (Coding Agent)
```json
{
  "maxResults": 10,
  "minScore": 0.65,
  "indexPaths": [
    "~/.openclaw/workspace",
    "~/code/current-project"
  ]
}
```
Add active project directory to index paths.

### Grove (Ops Agent)
```json
{
  "maxResults": 5,
  "minScore": 0.75,
  "strategy": "recency",
  "alwaysInclude": ["MEMORY.md", "BULLETIN.md"]
}
```
High precision, recency-focused — ops needs current state, not historical context.

## Rebuilding the Index

If you've added many new files and search results seem stale:

```bash
openclaw memory reindex
```

This re-embeds all files in `indexPaths`. Takes 1-5 minutes depending on workspace size.

Schedule nightly reindex:
```bash
# Add to crontab
0 3 * * * openclaw memory reindex >> ~/.openclaw/logs/reindex.log 2>&1
```

## Monitoring Memory Quality

Ask the agent to report what it retrieved:
```
Show me what you retrieved from memory for this question. List the file names and relevance scores.
```

If scores are consistently low (< 0.50) for relevant topics:
1. Lower `minScore` to 0.55
2. Check that files are in `indexPaths`
3. Run `openclaw memory reindex`
