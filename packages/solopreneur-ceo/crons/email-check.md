# Cron: Email Check

**Name:** email-check  
**Schedule:** `0 9,13,17 * * *` (9am, 1pm, 5pm — every workday)

## OpenClaw Cron Setup

```
Name: email-check
Channel: telegram (your Telegram DM)
Cron: 0 9,13,17 * * 1-5
Message:
Check email. For each new message:
- Flag anything time-sensitive or from a key contact
- Draft a reply if the answer is clear and low-stakes
- Summarize the rest in 1 line each
Keep total summary under 10 lines. Skip newsletters and auto-notifications.
```

## Prerequisites — Himalaya Setup

Himalaya is a CLI email client that works with IMAP/SMTP.

**Install:**
```bash
brew install himalaya
```

**Configure** (`~/.config/himalaya/config.toml`):
```toml
[accounts.main]
email = "you@yourdomain.com"
display-name = "Your Name"
backend = "imap"
sender = "smtp"

[accounts.main.imap]
host = "imap.yourdomain.com"
port = 993
login = "you@yourdomain.com"
passwd-cmd = "echo YOUR_PASSWORD"

[accounts.main.smtp]
host = "smtp.yourdomain.com"
port = 587
login = "you@yourdomain.com"
passwd-cmd = "echo YOUR_PASSWORD"
```

**Test:**
```bash
himalaya envelope list
```

## What the Agent Will Do

1. Run `himalaya envelope list` to get new messages
2. Read flagged/priority emails
3. Draft replies for simple questions
4. Summarize the inbox state
5. Report to you via Telegram

## Triage Rules (customize these in AGENTS.md or HEARTBEAT.md)

- **Reply autonomously:** Clear questions with obvious answers, confirmations, scheduling
- **Draft and ask:** Anything with nuance, client-facing, or requiring your judgment
- **Flag immediately:** Legal, financial, security, anything from key contacts
- **Skip:** Newsletters, marketing, auto-generated notifications

## Expected Output

```
Email check (3 new):

📌 Sarah Chen — "Contract revision" — needs your sign-off; I've flagged it
✉️ Invoice #224 paid — Stripe notification, logged
📰 Newsletter — Skipped

Draft ready for Sarah's contract question — want me to send?
```

## Troubleshooting

- **himalaya not found:** Install with `brew install himalaya`
- **Auth failing:** Check IMAP credentials, try app-specific passwords for Gmail
- **No new mail:** Himalaya checks INBOX by default; adjust folder if needed
