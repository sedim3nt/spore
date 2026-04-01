# Cron: Quarterly Tax Prep Reminder

**Name:** tax-prep-reminder  
**Schedule:** `0 9 1 1,4,6,9 *` (January 1, April 1, June 1, September 1 — quarterly)

US estimated tax due dates: April 15, June 15, September 15, January 15.
Set this cron to run ~2 weeks before each due date.

## OpenClaw Cron Setup

```
Name: tax-prep-q1  
Channel: telegram
Cron: 0 9 1 4 *
Message:
Tax prep reminder. Estimated Q1 taxes due April 15.

Help me compile what I need:
1. Total income this quarter (check invoices/YYYY/ folder)
2. Total expenses this quarter (check expenses/ folder if maintained)
3. Estimated tax owed (income × 25-30% self-employment estimate)
4. Prior quarterly payments made this year

Generate a summary I can send to my accountant.
```

Repeat with adjusted cron for each quarter:
- Q2: `0 9 1 6 *` (June 1 reminder, June 15 due)
- Q3: `0 9 1 9 *` (September 1 reminder, September 15 due)  
- Q4/Annual: `0 9 1 1 *` (January 1 reminder, January 15 due)

## Tax Categories to Track

Track these throughout the year so quarterly prep is fast:

**Income:**
- Client invoices paid (log to `invoices/YYYY/`)
- Other income (royalties, product sales, etc.)

**Deductible Expenses:**
- Home office (square footage method or actual)
- Equipment and software
- Professional subscriptions (OpenClaw, Claude, GitHub, etc.)
- Internet (business percentage)
- Phone (business percentage)
- Professional development (courses, books)
- Business meals (50% deductible)
- Travel for business
- Health insurance premiums
- Professional services (accountant, lawyer)
- Marketing and advertising

## Income Tracking Template

The agent can generate this quarterly:

```
Quarterly Income Summary — Q[X] YYYY

Invoices paid this quarter:
| Invoice # | Client | Amount | Date Paid |
|-----------|--------|--------|-----------|
| INV-001 | [Client] | $X,XXX | YYYY-MM-DD |

Total invoiced: $X,XXX
Total received: $X,XXX
Outstanding: $X,XXX

Estimated taxes owed (25%): $X,XXX
Prior payments this year: $X,XXX
Remaining to pay: $X,XXX
```

## Accountant Summary Prompt

```
Compile a quarterly tax summary for my accountant:
- Read all invoices in invoices/YYYY/
- Read any expense logs in expenses/YYYY/
- Calculate total income received this quarter
- List categories of expenses with totals
- Note any large one-time items
- Format as a clean summary I can email

Save to: taxes/YYYY-Q[X]-summary.md
```

## Disclaimer

This is a reminder and organizational tool, not tax advice. Consult a licensed accountant or CPA for tax advice specific to your situation.
