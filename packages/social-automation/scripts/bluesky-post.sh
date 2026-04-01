#!/bin/bash
# Post to Bluesky (AT Protocol)
# Usage: bluesky-post.sh "text" [url]
# If URL provided, creates a link card facet
#
# Setup: Add to .env
#   BSKY_HANDLE=yourhandle.bsky.social
#   BSKY_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx

set -euo pipefail

# Load .env if available
ENV_FILE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}/.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  set -a && source "$ENV_FILE" && set +a
fi

HANDLE="${BSKY_HANDLE:-${1:?Set BSKY_HANDLE in .env or pass as arg}}"
PASSWORD="${BSKY_APP_PASSWORD:-}"

if [[ -z "$PASSWORD" ]]; then
  echo "Error: BSKY_APP_PASSWORD not set. Add to .env or export."
  exit 1
fi

TEXT="${1:?Usage: bluesky-post.sh \"text\" [url]}"
URL="${2:-}"

# Authenticate
AUTH=$(curl -s -X POST 'https://bsky.social/xrpc/com.atproto.server.createSession' \
  -H 'Content-Type: application/json' \
  -d "{\"identifier\":\"$HANDLE\",\"password\":\"$PASSWORD\"}")

ACCESS_JWT=$(echo "$AUTH" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('accessJwt',''))")
DID=$(echo "$AUTH" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('did',''))")

if [[ -z "$ACCESS_JWT" ]]; then
  echo "Authentication failed: $AUTH"
  exit 1
fi

NOW=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Build record
if [[ -n "$URL" ]] && echo "$TEXT" | grep -qF "$URL"; then
  URL_START=$(python3 -c "
t = '''$TEXT'''
u = '$URL'
i = t.find(u)
print(len(t[:i].encode('utf-8')) if i >= 0 else -1)
")
  URL_END=$(python3 -c "
t = '''$TEXT'''
u = '$URL'
i = t.find(u)
print(len(t[:i+len(u)].encode('utf-8')) if i >= 0 else -1)
")

  RECORD=$(python3 -c "
import json
record = {
    '\$type': 'app.bsky.feed.post',
    'text': '''$TEXT''',
    'createdAt': '$NOW',
}
if '$URL_START' != '-1':
    record['facets'] = [{
        'index': {'byteStart': int('$URL_START'), 'byteEnd': int('$URL_END')},
        'features': [{'\\$type': 'app.bsky.richtext.facet#link', 'uri': '$URL'}]
    }]
print(json.dumps(record))
")
else
  RECORD=$(python3 -c "
import json
print(json.dumps({
    '\$type': 'app.bsky.feed.post',
    'text': '''$TEXT''',
    'createdAt': '$NOW'
}))
")
fi

# Post
RESULT=$(curl -s -X POST 'https://bsky.social/xrpc/com.atproto.repo.createRecord' \
  -H "Authorization: Bearer $ACCESS_JWT" \
  -H 'Content-Type: application/json' \
  -d "{\"repo\": \"$DID\", \"collection\": \"app.bsky.feed.post\", \"record\": $RECORD}")

python3 -c "
import sys, json
d = json.load(sys.stdin)
uri = d.get('uri', 'ERROR')
if uri != 'ERROR':
    parts = uri.replace('at://', '').split('/')
    did = parts[0]
    rkey = parts[-1]
    print(f'Posted: https://bsky.app/profile/{did}/post/{rkey}')
else:
    print(f'Error: {d}')
" <<< "$RESULT"
