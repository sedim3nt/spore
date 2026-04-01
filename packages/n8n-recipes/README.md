# n8n Workflow Recipes

**Version:** 1.0 | **Setup Time:** 30–60 minutes

8 pre-designed n8n workflow blueprints for AI agent automation. Each file describes the complete workflow: trigger, nodes, logic, and how to build it. Import or build from scratch.

## Quick Start

1. Install n8n: `npm install -g n8n` or use n8n Cloud
2. Start n8n: `n8n start`
3. Open http://localhost:5678
4. Build workflows using the blueprints in `workflows/`

## n8n + OpenClaw Integration

n8n and OpenClaw work as complementary layers:
- **OpenClaw:** Conversational AI agent tasks, on-demand requests, file operations
- **n8n:** Scheduled automation, webhook triggers, multi-step data pipelines, API integrations

Use n8n for: webhook-triggered workflows, complex multi-step data transformations, integrations with 400+ services.
Use OpenClaw for: AI-driven decisions, content generation, research, anything needing judgment.

## Workflows Included

| Workflow | Trigger | What It Does |
|---------|---------|--------------|
| tweet-poster | Schedule | Posts queued tweets with images |
| substack-publisher | Manual / Webhook | Publishes drafts to Substack |
| instagram-poster | Schedule | Posts images to Instagram |
| daily-digest | Schedule | Aggregates sources into daily brief |
| webhook-handler | Webhook | Routes incoming webhooks to OpenClaw |
| health-monitor | Schedule | Checks services, alerts on failure |
| content-distribution | Webhook | Triggers cross-posting on Substack publish |
| scheduled-tasks | Schedule | Multi-task daily automation |

## Requirements

- n8n (self-hosted or cloud)
- API credentials for relevant platforms
- Optional: OpenClaw webhook endpoint for AI decisions
