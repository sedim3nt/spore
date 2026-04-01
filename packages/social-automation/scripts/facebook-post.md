# Facebook Posting Guide

Facebook's Lexical editor loses paragraph breaks with standard keyboard/clipboard input. This guide explains the only reliable method.

## The Problem

Facebook's composer uses the Lexical framework. Standard methods fail:
- `document.execCommand` — deprecated, doesn't work
- Simulated keyboard Enter — Lexical eats it
- Direct DOM manipulation — state not synced

**The only method that works:** HTML clipboard paste via `ClipboardEvent`.

## The Solution

Use the JavaScript helper to paste formatted content:

```javascript
// In browser DevTools console, or via agent browser tool

function pastePost(paragraphs) {
  // paragraphs: array of strings, one per paragraph
  const editor = document.querySelector('[contenteditable="true"][role="textbox"]');
  if (!editor) { console.error('Editor not found'); return; }
  
  editor.focus();
  
  const html = paragraphs.map(p => `<p>${p}</p>`).join('');
  const plain = paragraphs.join('\n\n');
  
  const data = new DataTransfer();
  data.setData('text/html', html);
  data.setData('text/plain', plain);
  
  editor.dispatchEvent(new ClipboardEvent('paste', {
    bubbles: true, cancelable: true, clipboardData: data
  }));
}

// Example usage:
pastePost([
  "First paragraph goes here.",
  "Second paragraph goes here.",
  "Third paragraph with link: https://example.com"
]);
```

## Agent Prompt for Facebook Posting

```
Post this to Facebook (using browser tool):

CONTENT:
[Paste content here]

Steps:
1. Open Facebook in browser
2. Click "What's on your mind?" to open composer
3. Clear any draft: select all → delete
4. Use the pastePost() function from scripts/facebook-post-helper.js to paste with paragraph breaks
5. Take a snapshot to verify formatting (paragraph breaks should be visible)
6. If formatting looks good: click Post
7. Verify the post appears in the feed
8. Report the post URL
```

## Clearing the Editor Between Posts

```javascript
// Clear Facebook composer state (DOM clear isn't enough — must clear Lexical state)
const editor = document.querySelector('[contenteditable="true"][role="textbox"]');
editor.focus();
document.execCommand('selectAll', false, null);
editor.dispatchEvent(new InputEvent('beforeinput', {
  bubbles: true, 
  cancelable: true,
  inputType: 'deleteContentBackward'
}));
```

If that doesn't work:
- Close the dialog
- Click "Delete draft" if prompted
- Reload the page
- Reopen composer

## Verification

After posting:
1. Navigate to your timeline
2. Find the post
3. Verify paragraph breaks are preserved
4. Verify any links are clickable

If formatting is broken: delete and repost using correct method.

## Scheduling

For scheduled posts, set up the facebook-daily cron (see cron-toolkit package).
