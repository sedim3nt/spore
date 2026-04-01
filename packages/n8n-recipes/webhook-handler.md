# Webhook Handler Workflow

Receive and process Stripe payment webhooks, form submissions, or any external event.

## Trigger
- **Webhook node** — listens on `http://localhost:5678/webhook/stripe-events`

## Workflow
1. Webhook receives POST → parse JSON body
2. Route by event type (`checkout.session.completed`, `payment_intent.succeeded`, etc.)
3. Extract customer email + product info
4. Record to database (Supabase, Airtable, or file)
5. Send confirmation (Telegram alert, email, or both)

## Setup
1. In n8n, create new workflow → Add Webhook trigger node
2. Set HTTP Method: POST, Path: `stripe-events`
3. Add Switch node → route by `{{$json.type}}`
4. Add HTTP Request node → POST to your Supabase table
5. Add Telegram node → send alert to your chat

## Example Stripe Event
```json
{
  "type": "checkout.session.completed",
  "data": {
    "object": {
      "customer_email": "buyer@example.com",
      "amount_total": 4900
    }
  }
}
```
