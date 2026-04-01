# Email Escalation Rules

When to pull the human in, and how fast.

## Immediate Alert (< 5 minutes)

Flag these to the operator immediately, regardless of time of day:

- **Legal threats** — cease and desist, demand letters, mentions of attorneys, lawsuits
- **Security incidents** — breach notifications, unauthorized access, credentials compromised
- **Financial fraud signals** — unexpected transactions, wire transfer requests, invoice fraud patterns
- **Deadline < 4 hours** — anything requiring action today
- **From emergency contacts** — list your 2-3 people here: [Name 1], [Name 2]
- **Account takeover attempts** — password reset emails you didn't request, "verify your identity" from platforms you use

**How to alert:** Send Telegram message immediately with subject, sender, and 1-sentence summary.

---

## Flag Within 1 Hour (During Working Hours)

- **Client escalations** — upset tone, formal language, "unacceptable", "breach"
- **Media inquiries** — journalist, reporter, press request
- **Partnership / business development** — potential deals, acquisition interest
- **Contract or legal review needed** — any attached contract, NDA, amendment
- **From your key contacts** — anyone on your high-priority list

**How to alert:** Include in next email check summary, clearly labeled as FLAG.

---

## Draft and Present (Next Check)

Low-stakes emails where the agent should draft a response and present it for approval:

- Clear questions with obvious answers
- Scheduling / meeting requests
- Status update requests
- Invoice or payment confirmations
- Thank you / acknowledgment emails
- Follow-ups that need a simple "still working on it"

**How to handle:** Draft using `templates/response-templates.md`, save to `email/drafts/`, include in summary.

---

## No Action Needed

These get logged and skipped:

- **Receipts and invoices** — log amount, vendor, date
- **Newsletters** — log subscription source; unsubscribe if consistently skipped
- **Auto-notifications** — GitHub, calendar, Stripe, etc.
- **Social notifications** — email digests from X, LinkedIn, etc.
- **Marketing / cold outreach** — assess once, then apply pattern to future from same sender

---

## Delegation Rules

<!-- CUSTOMIZE: Define how the agent should handle specific senders -->

| Sender pattern | Rule |
|----------------|------|
| @[yourdomain].com | All hands — read and act if clear |
| [key-client].com | Flag immediately |
| noreply@* | Log and skip unless financial |
| [Specific person's email] | [Custom rule] |

---

## Override Protocol

When the escalation rules conflict with a clear instruction from the operator, the operator wins.

Example: "Don't bother me until 10am" overrides "immediate alert" for non-emergency items. But security incidents still alert immediately.
