#!/usr/bin/env python3
"""
Custom MCP Server Template
==========================
A minimal, production-ready template for building your own MCP server.
Uses the official `mcp` Python SDK.

Install: pip install mcp

Usage:
  python custom-server-template.py

Add to OpenClaw config:
  "custom": {
    "command": "python",
    "args": ["/path/to/custom-server-template.py"],
    "env": { "MY_API_KEY": "..." }
  }
"""

import asyncio
import os
import json
from typing import Any
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import (
    Tool,
    TextContent,
    CallToolResult,
    ListToolsResult,
)

# ─────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────

SERVER_NAME = "custom-agentorchard"
SERVER_VERSION = "1.0.0"

# Load secrets from environment (never hardcode)
MY_API_KEY = os.environ.get("MY_API_KEY", "")
SUPABASE_URL = os.environ.get("SUPABASE_URL", "")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "")

# ─────────────────────────────────────────────
# TOOLS — define what this server exposes
# ─────────────────────────────────────────────

TOOLS = [
    Tool(
        name="hello_world",
        description="A simple test tool that echoes back a message.",
        inputSchema={
            "type": "object",
            "properties": {
                "message": {
                    "type": "string",
                    "description": "The message to echo back"
                }
            },
            "required": ["message"]
        }
    ),
    Tool(
        name="fetch_data",
        description="Fetch data from an external source. Replace with your real implementation.",
        inputSchema={
            "type": "object",
            "properties": {
                "resource_id": {
                    "type": "string",
                    "description": "ID of the resource to fetch"
                },
                "format": {
                    "type": "string",
                    "enum": ["json", "text", "markdown"],
                    "description": "Output format",
                    "default": "json"
                }
            },
            "required": ["resource_id"]
        }
    ),
    Tool(
        name="save_record",
        description="Save a record to the data store.",
        inputSchema={
            "type": "object",
            "properties": {
                "key": {
                    "type": "string",
                    "description": "Unique key for this record"
                },
                "value": {
                    "type": "string",
                    "description": "Content to store"
                },
                "tags": {
                    "type": "array",
                    "items": {"type": "string"},
                    "description": "Optional tags for categorization"
                }
            },
            "required": ["key", "value"]
        }
    ),
]

# ─────────────────────────────────────────────
# TOOL IMPLEMENTATIONS
# ─────────────────────────────────────────────

async def handle_hello_world(args: dict[str, Any]) -> str:
    """Simple echo tool — replace with real logic."""
    message = args.get("message", "")
    return f"Echo: {message}"


async def handle_fetch_data(args: dict[str, Any]) -> str:
    """Fetch data — replace with real API call."""
    resource_id = args["resource_id"]
    fmt = args.get("format", "json")

    # ── Replace this with your actual data fetching ──
    # Example: Supabase query
    # import httpx
    # async with httpx.AsyncClient() as client:
    #     resp = await client.get(
    #         f"{SUPABASE_URL}/rest/v1/your_table?id=eq.{resource_id}",
    #         headers={"apikey": SUPABASE_KEY, "Authorization": f"Bearer {SUPABASE_KEY}"}
    #     )
    #     data = resp.json()

    # Stub response
    data = {
        "id": resource_id,
        "status": "found",
        "content": f"Data for {resource_id} — implement real fetch here"
    }

    if fmt == "json":
        return json.dumps(data, indent=2)
    elif fmt == "markdown":
        return f"## Resource: {resource_id}\n\n```json\n{json.dumps(data, indent=2)}\n```"
    else:
        return str(data)


async def handle_save_record(args: dict[str, Any]) -> str:
    """Save a record — replace with real storage."""
    key = args["key"]
    value = args["value"]
    tags = args.get("tags", [])

    # ── Replace this with your actual storage ──
    # Example: SQLite
    # import aiosqlite
    # async with aiosqlite.connect("data.db") as db:
    #     await db.execute(
    #         "INSERT OR REPLACE INTO records (key, value, tags) VALUES (?, ?, ?)",
    #         (key, value, json.dumps(tags))
    #     )
    #     await db.commit()

    # Stub
    return json.dumps({
        "success": True,
        "key": key,
        "tags": tags,
        "message": f"Saved '{key}' — implement real storage here"
    })


# ─────────────────────────────────────────────
# DISPATCH TABLE — maps tool names to handlers
# ─────────────────────────────────────────────

HANDLERS = {
    "hello_world": handle_hello_world,
    "fetch_data": handle_fetch_data,
    "save_record": handle_save_record,
}

# ─────────────────────────────────────────────
# SERVER SETUP — don't touch below this line
# unless you need custom transport
# ─────────────────────────────────────────────

server = Server(SERVER_NAME)


@server.list_tools()
async def list_tools() -> list[Tool]:
    return TOOLS


@server.call_tool()
async def call_tool(name: str, arguments: dict[str, Any]) -> list[TextContent]:
    handler = HANDLERS.get(name)
    if not handler:
        raise ValueError(f"Unknown tool: {name}")

    try:
        result = await handler(arguments)
        return [TextContent(type="text", text=str(result))]
    except Exception as e:
        return [TextContent(type="text", text=f"Error in {name}: {e}")]


async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options(),
        )


if __name__ == "__main__":
    asyncio.run(main())
