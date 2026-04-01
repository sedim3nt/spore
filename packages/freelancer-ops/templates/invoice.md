# Invoice Template

---

**INVOICE**

---

**From:**  
[Your Name / Company]  
[Address]  
[City, State, ZIP]  
[Email]  
[Phone — optional]

**To:**  
[Client Name / Company]  
[Client Address]  
[Client City, State, ZIP]

---

**Invoice Number:** INV-[YYYY]-[NNN]  
**Invoice Date:** YYYY-MM-DD  
**Due Date:** YYYY-MM-DD (Net [15/30])  
**Project:** [Project Name]

---

## Line Items

| Description | Qty / Hours | Rate | Amount |
|-------------|-------------|------|--------|
| [Service description] | [X hrs / 1] | $[rate]/hr or flat | $[amount] |
| [Service description] | | | $[amount] |
| [Expenses, if applicable] | | | $[amount] |

---

**Subtotal:** $[amount]  
**Tax ([X]% — if applicable):** $[amount]  
**Total Due:** $**[TOTAL]**

---

## Payment Instructions

**Preferred method:** [Bank transfer / PayPal / Stripe / Venmo / Check]

**Bank transfer:**  
Bank: [Bank Name]  
Routing: [routing number]  
Account: [account number]

**[Or Stripe payment link]:** [url]

---

**Please reference Invoice #INV-[YYYY]-[NNN] with your payment.**

Payment is due by [due date]. For questions, contact [email].

---

_Late payments: [X]% per month after [X] days — or per your contract terms_

---

## For Agent Use

To generate a new invoice:
```
Create an invoice for [Client Name] for [project/work description].
Hours: [X] at $[rate]/hr (or flat fee: $[amount]).
Expenses: [any reimbursables].
Invoice number: INV-[YYYY]-[NNN].
Due: Net [15/30] from today.
Save to: invoices/INV-[YYYY]-[NNN]-[client-slug].md
```
