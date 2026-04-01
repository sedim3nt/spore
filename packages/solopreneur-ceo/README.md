# Solopreneur CEO Stack

**Version:** 1.0 | **Setup Time:** 20–30 minutes

Your AI assistant, configured for solo operators. One agent, five files, fully autonomous morning briefings, email triage, and weekly review — while you focus on the work.

## Quick Start

1. Copy all files to your OpenClaw workspace:
   ```bash
   cp -r solopreneur-ceo/* ~/.openclaw/workspace/
   ```
2. Edit each file — search for `<!-- CUSTOMIZE -->` blocks
3. Restart your gateway:
   ```bash
   openclaw gateway restart
   ```
4. Set up your crons in OpenClaw (see `crons/` folder)
5. Send your agent a message: "Good morning" — it should respond with a brief

## 7-Day First-Week Playbook

### Day 1 — Personalize
- Edit `USER.md` with your name, background, goals
- Edit `IDENTITY.md` with your agent's name and personality
- Edit `SOUL.md` — read every line and adjust to your voice

### Day 2 — First Cron
- Add the morning-brief cron (see `crons/morning-brief.md`)
- Test it: send your agent "Give me my morning brief"
- Iterate on what you want in that brief

### Day 3 — Email
- Connect your email via himalaya (see `crons/email-check.md` for setup)
- Run first email check manually
- Set the cron to run every 4 hours

### Day 4 — Weekly Review
- Configure `crons/weekly-review.md`
- Set what "done" means for your week
- Test: "Give me a weekly review"

### Day 5 — Memory
- Create `memory/` directory in your workspace
- Your agent will start writing daily logs automatically
- Check `memory/YYYY-MM-DD.md` after a few sessions

### Day 6 — Iterate
- Review your `HEARTBEAT.md` — is the agent checking the right things?
- Adjust cron schedules to fit your actual rhythm
- Add anything to `USER.md` the agent needs to know

### Day 7 — Lock In
- Run a full week's worth of morning briefs
- Tighten any prompts that are off
- You're operational. Keep evolving.

## Files Included

| File | Purpose |
|------|---------|
| SOUL.md | Agent personality and boundaries |
| AGENTS.md | Single-agent config + protocols |
| IDENTITY.md | Your agent's name and voice |
| HEARTBEAT.md | Health monitoring schedule |
| USER.md | About you — your background, goals, preferences |
| crons/ | Automated task templates |

## Requirements

- OpenClaw installed and running
- Claude subscription (Sonnet is sufficient for solo ops)
- Email configured via himalaya (optional but recommended)
