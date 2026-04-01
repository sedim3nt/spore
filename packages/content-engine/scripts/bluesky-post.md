# Bluesky Posting via AT Protocol

Post to Bluesky programmatically using the AT Protocol API. No API key required — uses your handle and app password.

## Setup

### Get an App Password

1. Go to Bluesky Settings → Privacy and Security → App Passwords
2. Click "Add App Password"
3. Name it (e.g., "openclaw-agent")
4. Copy the generated password

Add to your `.env`:
```
BSKY_HANDLE=yourhandle.bsky.social
BSKY_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx
```

## Posting Script

Save as `scripts/bluesky-post.sh`:

```bash
#!/bin/bash
# Post to Bluesky (AT Protocol)
# Usage: bluesky-post.sh "text" [url]

set -euo pipefail

HANDLE="${BSKY_HANDLE:-yourhandle.bsky.social}"
PASSWORD="${BSKY_APP_PASSWORD:-}"

TEXT="${1:?Usage: bluesky-post.sh \"text\" [url]}"
URL="${2:-}"

# Authenticate
AUTH=$(curl -s -X POST 'https://bsky.social/xrpc/com.atproto.server.createSession' \
  -H 'Content-Type: application/json' \
  -d "{\"identifier\":\"$HANDLE\",\"password\":\"$PASSWORD\"}")

ACCESS_JWT=$(echo "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['accessJwt'])")
DID=$(echo "$AUTH" | python3 -c "import sys,json; print(json.load(sys.stdin)['did'])")

NOW=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Build post record with optional link facet
if [ -n "$URL" ]; then
  URL_START=$(python3 -c "
text = '''$TEXT'''
url = '$URL'
idx = text.find(url)
print(len(text[:idx].encode('utf-8')) if idx >= 0 else -1)
")
  URL_END=$(python3 -c "
text = '''$TEXT'''
url = '$URL'
idx = text.find(url)
print(len(text[:idx+len(url)].encode('utf-8')) if idx >= 0 else -1)
")

  if [ "$URL_START" != "-1" ]; then
    RECORD="{
      \"\$type\": \"app.bsky.feed.post\",
      \"text\": $(python3 -c "import json; print(json.dumps('''$TEXT'''))"),
      \"createdAt\": \"$NOW\",
      \"facets\": [{
        \"index\": {\"byteStart\": $URL_START, \"byteEnd\": $URL_END},
        \"features\": [{
          \"\$type\": \"app.bsky.richtext.facet#link\",
          \"uri\": \"$URL\"
        }]
      }]
    }"
  else
    RECORD="{
      \"\$type\": \"app.bsky.feed.post\",
      \"text\": $(python3 -c "import json; print(json.dumps('''$TEXT'''))"),
      \"createdAt\": \"$NOW\"
    }"
  fi
else
  RECORD="{
    \"\$type\": \"app.bsky.feed.post\",
    \"text\": $(python3 -c "import json; print(json.dumps('''$TEXT'''))"),
    \"createdAt\": \"$NOW\"
  }"
fi

# Create post
RESULT=$(curl -s -X POST 'https://bsky.social/xrpc/com.atproto.repo.createRecord' \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H 'Content-Type: application/json' \
  -d "{
    \"repo\": \"$DID\",
    \"collection\": \"app.bsky.feed.post\",
    \"record\": $RECORD
  }")

echo "$RESULT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
uri = d.get('uri', 'ERROR')
if uri != 'ERROR':
    # Convert at:// URI to web URL
    parts = uri.replace('at://', '').split('/')
    did = parts[0]
    rkey = parts[-1]
    print(f'Posted: https://bsky.app/profile/{did}/post/{rkey}')
else:
    print(f'Error: {d}')
"
```

Make executable: `chmod +x scripts/bluesky-post.sh`

## Usage Examples

```bash
# Simple text post
./scripts/bluesky-post.sh "Your post text here"

# Post with link
./scripts/bluesky-post.sh "Read my new article: https://yoursite.com/article" "https://yoursite.com/article"
```

## Python Alternative

For use in larger workflows:

```python
import requests
import json
from datetime import datetime, timezone

def post_to_bluesky(text, url=None, handle=None, password=None):
    """Post to Bluesky. Returns post URL."""
    # Authenticate
    auth = requests.post(
        'https://bsky.social/xrpc/com.atproto.server.createSession',
        json={"identifier": handle, "password": password}
    ).json()
    
    jwt = auth['accessJwt']
    did = auth['did']
    now = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S.000Z')
    
    record = {
        "$type": "app.bsky.feed.post",
        "text": text,
        "createdAt": now
    }
    
    if url and url in text:
        start = len(text[:text.find(url)].encode('utf-8'))
        end = start + len(url.encode('utf-8'))
        record["facets"] = [{
            "index": {"byteStart": start, "byteEnd": end},
            "features": [{"$type": "app.bsky.richtext.facet#link", "uri": url}]
        }]
    
    result = requests.post(
        'https://bsky.social/xrpc/com.atproto.repo.createRecord',
        headers={"Authorization": f"Bearer {jwt}"},
        json={"repo": did, "collection": "app.bsky.feed.post", "record": record}
    ).json()
    
    return result.get('uri', 'error')
```

## Character Limit

Bluesky has a 300-character limit per post. For threads, post sequentially using the `reply` field in the record.
