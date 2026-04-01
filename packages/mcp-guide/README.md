# MCP Guide — Model Context Protocol for OpenClaw

## What is MCP?

Model Context Protocol (MCP) is an open standard that lets AI models talk to external tools and data sources through a unified interface. Instead of each integration being custom-built, MCP gives you a plug-and-play system: write one server, use it with any MCP-compatible client.

Think of it as USB-C for AI integrations.

## Why It Matters

Without MCP:
- Each tool integration is a one-off build
- Context is siloed per conversation
- Agents can't share memory or tools cleanly

With MCP:
- One server exposes a tool → all agents can use it
- Memory backends (MuninnDB, Notion, SQLite) become queryable context
- You build infrastructure once and compose it

## MCP Architecture

```
OpenClaw Agent
      ↓
  MCP Client (built into OpenClaw)
      ↓
MCP Server (your tool/data source)
      ↓
  Actual resource (DB, API, filesystem)
```

MCP servers can expose:
- **Tools** — callable functions (e.g., `search_memory`, `create_note`)
- **Resources** — readable data sources (e.g., files, database rows)
- **Prompts** — reusable prompt templates

## What's In This Guide

- `openclaw-mcp-config.json` — Drop-in config example
- `muninndb-setup.md` — Connect MuninnDB as a memory MCP server
- `custom-server-template.py` — Python template for your own MCP server
- `notion-mcp.md` — Connect Notion as an MCP knowledge base
- `troubleshooting.md` — Common issues and fixes

## Quick Start

1. Install an MCP server (e.g., MuninnDB):
   ```bash
   pip install muninndb-mcp
   ```

2. Add to OpenClaw config (see `openclaw-mcp-config.json`)

3. Restart OpenClaw:
   ```bash
   openclaw gateway restart
   ```

4. Verify tools are loaded:
   ```bash
   openclaw mcp list-tools
   ```

## MCP vs. Traditional Plugins

| | MCP | Plugin |
|---|---|---|
| Standard | Yes (open spec) | No (custom per platform) |
| Reusable across AI systems | Yes | No |
| Server/client separation | Yes | No |
| Transport options | stdio, HTTP/SSE | Varies |
| Tool discovery | Automatic | Manual |

MCP is the standard going forward. Build new integrations as MCP servers.
