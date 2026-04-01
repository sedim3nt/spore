# Instagram Poster — n8n Workflow

Posts images to Instagram via the Facebook Graph API. Supports single images and carousels. Requires a Facebook Business account connected to the Instagram account.

## Prerequisites

- Instagram Professional account (Creator or Business)
- Facebook Page linked to the Instagram account
- Facebook App with `instagram_basic`, `instagram_content_publish`, `pages_read_engagement` permissions
- Long-lived access token (~60 days)

## Step 1: Get Instagram Credentials

### Create Facebook App
1. [developers.facebook.com](https://developers.facebook.com) → My Apps → Create App
2. Type: Business
3. Add products: Instagram Graph API

### Get Access Token
1. [developers.facebook.com/tools/explorer](https://developers.facebook.com/tools/explorer)
2. Select your app
3. Generate token with permissions:
   - `instagram_basic`
   - `instagram_content_publish`
   - `pages_show_list`
   - `pages_read_engagement`
4. Get Long-Lived Token (via API):
```bash
curl "https://graph.facebook.com/v19.0/oauth/access_token?grant_type=fb_exchange_token&client_id=YOUR_APP_ID&client_secret=YOUR_APP_SECRET&fb_exchange_token=SHORT_LIVED_TOKEN"
```

### Get Instagram Business Account ID
```bash
curl "https://graph.facebook.com/v19.0/me/accounts?access_token=YOUR_TOKEN"
# Get page_id from response

curl "https://graph.facebook.com/v19.0/PAGE_ID?fields=instagram_business_account&access_token=YOUR_TOKEN"
# Get instagram_business_account.id
```

Store in n8n credentials:
```
IG_ACCESS_TOKEN=your_long_lived_token
IG_BUSINESS_ACCOUNT_ID=17841XXXXXXXXX
```

## Workflow: Single Image Post

### Step 1: Create Media Container
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "POST",
    "url": "https://graph.facebook.com/v19.0/{{ $env.IG_BUSINESS_ACCOUNT_ID }}/media",
    "body": {
      "image_url": "={{ $json.image_url }}",
      "caption": "={{ $json.caption }}",
      "access_token": "={{ $env.IG_ACCESS_TOKEN }}"
    }
  }
}
```

Response: `{ "id": "17858700000000000" }` — this is your `creation_id`.

**Image URL Requirements:**
- Must be publicly accessible (use Supabase storage or S3)
- JPG or PNG
- Minimum 320px, maximum 1440px width
- Aspect ratios: 1:1, 4:5, 1.91:1

### Step 2: Wait for Processing
Add a **Wait node**: 10 seconds (container needs time to process).

Or poll until ready:
```javascript
// Code node — poll until status FINISHED
let status = 'IN_PROGRESS';
let attempts = 0;

while (status !== 'FINISHED' && attempts < 10) {
  await new Promise(r => setTimeout(r, 5000));
  const response = await $http.get(
    `https://graph.facebook.com/v19.0/${creationId}?fields=status_code&access_token=${token}`
  );
  status = response.body.status_code;
  attempts++;
}

if (status !== 'FINISHED') throw new Error('Media processing timeout');
return [{ json: { creationId, ready: true } }];
```

### Step 3: Publish
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "POST",
    "url": "https://graph.facebook.com/v19.0/{{ $env.IG_BUSINESS_ACCOUNT_ID }}/media_publish",
    "body": {
      "creation_id": "={{ $('Create Container').item.json.id }}",
      "access_token": "={{ $env.IG_ACCESS_TOKEN }}"
    }
  }
}
```

Response: `{ "id": "17896000000000000" }` — this is the published post ID.

### Step 4: Update Supabase
```json
{
  "fieldsUi": {
    "fieldValues": [
      { "fieldId": "status", "fieldValue": "published" },
      { "fieldId": "instagram_post_id", "fieldValue": "={{ $json.id }}" },
      { "fieldId": "published_at", "fieldValue": "={{ $now.toISO() }}" }
    ]
  }
}
```

## Carousel Posts

Carousels require creating child containers first, then a parent.

### Create child containers (one per image):
```javascript
// Code node — create all children in parallel
const images = $input.first().json.images; // array of image URLs
const token = process.env.IG_ACCESS_TOKEN;
const igId = process.env.IG_BUSINESS_ACCOUNT_ID;

const children = await Promise.all(images.map(async (url) => {
  const resp = await $http.post(
    `https://graph.facebook.com/v19.0/${igId}/media`,
    { image_url: url, is_carousel_item: true, access_token: token }
  );
  return resp.body.id;
}));

return [{ json: { children } }];
```

### Create carousel parent:
```bash
POST /ACCOUNT_ID/media
{
  "media_type": "CAROUSEL",
  "children": "CHILD_ID_1,CHILD_ID_2,CHILD_ID_3",
  "caption": "Your caption",
  "access_token": "TOKEN"
}
```

Then publish the carousel's `creation_id` same as single image.

## Image Upload to Supabase (Pre-step)

Instagram requires public image URLs. Store images in Supabase:

```javascript
// Code node — upload image buffer to Supabase storage
const imageBuffer = $binary.data; // from previous node
const filename = `ig-${Date.now()}.jpg`;

const response = await $http.post(
  `${process.env.SUPABASE_URL}/storage/v1/object/images/${filename}`,
  imageBuffer,
  {
    headers: {
      'apikey': process.env.SUPABASE_SERVICE_KEY,
      'Authorization': `Bearer ${process.env.SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'image/jpeg',
      'x-upsert': 'true'
    }
  }
);

const publicUrl = `${process.env.SUPABASE_URL}/storage/v1/object/public/images/${filename}`;
return [{ json: { image_url: publicUrl } }];
```

## Rate Limits

- 50 API calls per Instagram account per hour
- 25 posts per 24 hours (creation limit)
- Carousels count as 1 post regardless of image count

## Token Refresh

Long-lived tokens expire in ~60 days. Refresh before expiry:

```bash
curl "https://graph.facebook.com/v19.0/oauth/access_token?grant_type=ig_refresh_token&access_token=CURRENT_TOKEN"
```

Add a weekly workflow to refresh and update the stored token.
