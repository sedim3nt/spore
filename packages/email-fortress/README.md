# Email Fortress Agent

**Version:** 1.0 | **Setup Time:** 20 minutes

An autonomous email agent that triages your inbox, drafts responses in your voice, flags urgent items, and defends against prompt injection attacks embedded in emails. Handles the inbox so you don't have to.

## Quick Start

1. Install and configure himalaya:
   ```bash
   brew install himalaya
   # Configure ~/.config/himalaya/config.toml with your IMAP credentials
   himalaya envelope list  # verify it works
   ```
2. Copy ROLE.md to your agents directory
3. Copy templates to your workspace
4. Set up the email-check cron (see `scripts/email-check-cron.md`)
5. Test: send your agent "Check my email and give me a summary"

## What This Agent Does

- **Triage** — reads and categorizes incoming mail
- **Drafts** — writes responses for clear-answer emails
- **Flags** — surfaces urgent and sensitive items immediately
- **Guards** — detects and neutralizes prompt injection in emails

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Agent role and email protocols |
| scripts/email-check-cron.md | Automated inbox monitoring |
| templates/response-templates.md | 10 common email response patterns |
| templates/escalation-rules.md | What to escalate and when |
| templates/html-signature.html | Professional email signature |
| security/prompt-injection-defense.md | Protect against email-embedded attacks |
