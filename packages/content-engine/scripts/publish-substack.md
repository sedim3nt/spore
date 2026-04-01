# Substack Publishing via API

Publish articles to Substack programmatically using the private Substack API and session cookie authentication.

## Prerequisites

- Active Substack publication
- Your Substack session cookie (`substack.sid`)

## Getting Your Session Cookie

1. Log in to Substack in Chrome
2. Open DevTools → Application → Cookies → `https://yourpub.substack.com`
3. Find `substack.sid` — copy the value
4. Add to your `.env` file:
   ```
   SUBSTACK_SID=your_sid_value_here
   SUBSTACK_PUB=yourpublicationname
   ```

## Using the Publisher Script

Save the script below as `scripts/publish-substack.py` and call it:

```bash
# Create as draft
python3 scripts/publish-substack.py content/drafts/article.md

# Publish immediately
python3 scripts/publish-substack.py content/drafts/article.md --publish
```

## Script

```python
#!/usr/bin/env python3
"""Publish markdown articles to Substack via their private API."""

import sys
import json
import re
import os
import requests
from pathlib import Path
from datetime import datetime

# Config — load from environment or .env
PUBLICATION = os.environ.get("SUBSTACK_PUB", "yourpub")
SID = os.environ.get("SUBSTACK_SID", "")

if not SID:
    env_path = Path.home() / ".openclaw/workspace/.env"
    if env_path.exists():
        for line in env_path.read_text().splitlines():
            if line.startswith("SUBSTACK_SID="):
                SID = line.split("=", 1)[1].strip()

BASE_URL = f"https://{PUBLICATION}.substack.com"
HEADERS = {
    "Content-Type": "application/json",
    "Origin": BASE_URL,
    "Referer": f"{BASE_URL}/publish/post",
}
COOKIES = {"substack.sid": SID}

def md_to_prosemirror(text):
    """Convert markdown to Substack's ProseMirror JSON format."""
    paragraphs = []
    for line in text.split("\n\n"):
        line = line.strip()
        if not line:
            continue
        if line.startswith("# "):
            paragraphs.append({"type": "heading", "attrs": {"level": 1},
                "content": [{"type": "text", "text": line[2:]}]})
        elif line.startswith("## "):
            paragraphs.append({"type": "heading", "attrs": {"level": 2},
                "content": [{"type": "text", "text": line[3:]}]})
        elif line.startswith("### "):
            paragraphs.append({"type": "heading", "attrs": {"level": 3},
                "content": [{"type": "text", "text": line[4:]}]})
        elif line.startswith("---"):
            paragraphs.append({"type": "horizontal_rule"})
        else:
            paragraphs.append({"type": "paragraph",
                "content": [{"type": "text", "text": line}]})
    return {"type": "doc", "content": paragraphs}

def publish(md_file, publish_now=False):
    text = Path(md_file).read_text()
    lines = text.strip().split("\n")
    title = lines[0].lstrip("# ").strip()
    subtitle = lines[1].strip() if len(lines) > 1 and not lines[1].startswith("#") else ""
    body = "\n\n".join(text.split("\n\n")[1:])
    
    body_json = md_to_prosemirror(body)
    
    payload = {
        "draft_title": title,
        "draft_subtitle": subtitle,
        "draft_body": json.dumps(body_json),
        "section_chosen": True,
        "audience": "everyone",
    }
    
    # Create draft
    r = requests.post(f"{BASE_URL}/api/v1/drafts", headers=HEADERS, cookies=COOKIES,
        json=payload)
    
    if r.status_code not in (200, 201):
        print(f"Failed: {r.status_code} {r.text}")
        return
    
    post_id = r.json()["id"]
    print(f"Draft created: {post_id}")
    
    if publish_now:
        pub_r = requests.post(f"{BASE_URL}/api/v1/drafts/{post_id}/publish",
            headers=HEADERS, cookies=COOKIES,
            json={"send": True, "share_automatically": False})
        if pub_r.status_code in (200, 201):
            slug = pub_r.json().get("canonical_url", "").split("/")[-1]
            print(f"Published: {BASE_URL}/p/{slug}")
        else:
            print(f"Publish failed: {pub_r.status_code}")

if __name__ == "__main__":
    publish(sys.argv[1], "--publish" in sys.argv)
```

## Markdown File Format

Structure your articles like this for clean conversion:

```markdown
# Article Title

Optional subtitle — appears below the title

## First Section

Your content here. Keep paragraphs 2-4 sentences.

## Second Section

More content...

---

_Footer or call to action_
```

## Cover Image

To add a cover image:
1. Upload the image to Substack via the editor UI first (or use their image upload API)
2. Add `cover_image` to the payload: `"cover_image": "https://substackcdn.com/..."`

## After Publishing

Always verify:
1. Fetch the live URL: `curl -s "URL" | grep "<title>"`
2. Check formatting renders correctly
3. Send cross-posts per `scripts/cross-post-workflow.md`
