# CEO Operations Stack

**Version:** 1.0 | **Setup Time:** 30-60 minutes

The complete autonomous AI operations configuration. 5 workspace files that transform your AI from a chatbot into an autonomous operator. Production-tested over 3+ months running 24/7.

## Quick Start

1. Copy all `.md` files to your OpenClaw workspace: `~/.openclaw/workspace/`
2. Open each file and customize the sections marked `<!-- CUSTOMIZE -->`
3. Restart your OpenClaw gateway: `openclaw gateway restart`
4. Your agent will read these files on every session startup

## Files Included

| File | Purpose | Customize? |
|------|---------|-----------|
| SOUL.md | Agent personality, voice, boundaries | Yes — your voice, your boundaries |
| AGENTS.md | Orchestration config, agent roster, protocols | Yes — your agents, your workflows |
| IDENTITY.md | Agent name, codename, emoji, mantras | Yes — your brand |
| HEARTBEAT.md | Health monitoring, alert rules | Yes — your services, your intervals |
| USER.md | Your background, skills, preferences | Yes — about YOU |

## What Makes This Different

These aren't templates with placeholder text. This is the exact configuration running a real business — refined through hundreds of iterations and failures. Every rule in AGENTS.md exists because we hit a bug without it.

## Requirements

- OpenClaw installed and running
- Claude Code subscription ($100-200/mo) or any supported model
- 30-60 minutes to customize
