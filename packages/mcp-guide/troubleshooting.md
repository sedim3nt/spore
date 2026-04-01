# MCP Troubleshooting Guide

## Diagnostic Commands

```bash
# Check which MCP servers are loaded
openclaw mcp list-servers

# List all available tools
openclaw mcp list-tools

# Test a specific tool
openclaw mcp call --server muninndb --tool search_memory --args '{"query": "test"}'

# Check gateway logs for MCP errors
openclaw gateway logs --filter mcp

# Restart everything
openclaw gateway restart
```

## Common Issues

---

### ❌ "MCP server failed to start"

**Symptoms:** Server appears in config but not in `list-servers` output.

**Causes & Fixes:**

1. **Command not found**
   ```bash
   # Test the command manually
   python -m muninndb_mcp.server
   # or
   npx @modelcontextprotocol/server-notion
   ```
   If it fails, install the missing package.

2. **Missing environment variables**
   ```bash
   # Verify env vars are set
   echo $NOTION_API_KEY
   echo $MUNINNDB_PATH
   ```
   If empty, add to `~/.zshrc` and `source ~/.zshrc`.

3. **Wrong Python version**
   ```bash
   python --version   # needs 3.10+
   which python       # confirm path
   ```
   Use `python3` in args if needed.

---

### ❌ "Tool not found" when agent tries to use it

**Symptoms:** Agent reports tool doesn't exist, but server is listed as running.

**Fix:**
```bash
# Check actual tools loaded for that server
openclaw mcp list-tools --server muninndb

# If empty, the server started but failed to register tools
# Check server-specific logs:
openclaw gateway logs --filter "muninndb" --level debug
```

---

### ❌ MuninnDB: "Embedding model not available"

**Symptoms:** `store_memory` or `search_memory` fails with embedding error.

**Fix:**
```bash
# Verify Ollama is running
curl http://localhost:11434/api/tags

# If not running:
ollama serve &

# Verify model is downloaded
ollama list | grep nomic-embed-text

# If missing:
ollama pull nomic-embed-text
```

---

### ❌ Notion: "Could not find database"

**Symptoms:** `notion.query_database` returns nothing or 404.

**Fix:**
1. Open the database in Notion
2. Click **...** → **Add connections** → `OpenClaw Agent`
3. Wait 30 seconds for index update
4. Retry

Also verify the database ID is correct:
```bash
# Search by name instead of ID
openclaw mcp call --server notion --tool search --args '{"query": "database name"}'
```

---

### ❌ "ENOENT: no such file or directory" for npx servers

**Symptoms:** npx-based servers fail on startup.

**Fix:**
```bash
# npx may have a stale cache
npx clear-npx-cache

# Or force fresh install
npx -y --cache /tmp/mcp-npx-cache @modelcontextprotocol/server-notion

# Or install globally to avoid npx issues
npm install -g @modelcontextprotocol/server-notion
# Then change config to use: "command": "mcp-server-notion"
```

---

### ❌ Server connects but returns wrong data

**Symptoms:** Tools return stale, empty, or malformed data.

**Checks:**
```bash
# Verify env vars are correct
openclaw mcp inspect --server your-server

# Check the raw tool output
openclaw mcp call --server your-server --tool your-tool \
  --args '{"key": "value"}' --verbose
```

---

### ❌ Agent ignores MCP tools and uses web search instead

**Symptoms:** Agent doesn't use `muninndb.search_memory` when it should.

**Fix:** Explicitly instruct the agent:
```
Use muninndb.search_memory (not web search) to find information about X
```

Long term, add tool-use preferences to your system prompt or SOUL.md.

---

### ❌ "stdio transport closed unexpectedly"

**Symptoms:** Server starts then immediately disconnects.

**Causes:**
1. Server process crashed (check logs)
2. Server printed to stdout instead of stderr (corrupts MCP protocol)
3. Python `print()` calls in server code (use `sys.stderr.write()` instead)

**Fix for custom servers:**
```python
import sys
# Replace all print() with:
print("debug message", file=sys.stderr)
# Never print to stdout — it breaks the stdio MCP transport
```

---

## Checking MCP Server Health

Add this script as a health check:

```bash
#!/bin/bash
# mcp-health.sh
echo "=== MCP Server Health ==="

servers=$(openclaw mcp list-servers --json 2>/dev/null)
if [ -z "$servers" ]; then
  echo "❌ No MCP servers loaded — check gateway status"
  exit 1
fi

echo "$servers" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for s in data:
    status = '✅' if s['status'] == 'connected' else '❌'
    print(f\"{status} {s['name']}: {s['status']} ({s['tool_count']} tools)\")
"
```

Run: `bash mcp-health.sh`

## Log Locations

| Location | Contents |
|---|---|
| `openclaw gateway logs` | All gateway events including MCP |
| `~/.openclaw/logs/mcp-*.log` | Per-server logs (if file logging enabled) |
| `stderr` of server process | Server-side errors (captured by gateway) |

## Getting Help

1. Run `openclaw mcp diagnose` for automated diagnosis
2. Check [OpenClaw docs](https://openclaw.dev/mcp)
3. MCP spec: [spec.modelcontextprotocol.io](https://spec.modelcontextprotocol.io)
