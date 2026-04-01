# Pre-Compaction Flush Tuning

## What Is Compaction?

When Claude's context window fills up during a long session, OpenClaw triggers **compaction**: it summarizes the conversation history to free space. This is automatic.

**The problem:** If nothing is flushed to persistent memory before compaction, valuable context from the first half of the session is lost. The summary captures the gist but drops specifics.

**The fix:** Configure pre-compaction flush thresholds so important context is written to memory files *before* the compaction window hits.

## Key Config: `softThresholdTokens`

```json
{
  "memory": {
    "compaction": {
      "softThresholdTokens": 80000,
      "hardThresholdTokens": 160000,
      "flushOnSoftThreshold": true,
      "flushTargets": [
        "memory/YYYY-MM-DD.md",
        "MEMORY.md"
      ],
      "flushStrategy": "summarize-and-append",
      "preserveOnFlush": [
        "decisions",
        "errors",
        "user-preferences",
        "file-paths",
        "credentials-structure"
      ]
    }
  }
}
```

## Threshold Recommendations

| Model | Context Window | softThreshold | hardThreshold |
|-------|---------------|---------------|---------------|
| Claude Sonnet | 200K | 80,000 | 160,000 |
| Claude Opus | 200K | 80,000 | 160,000 |
| GPT-4o | 128K | 50,000 | 100,000 |
| Gemini 1.5 Pro | 1M | 400,000 | 800,000 |

**Rule of thumb:** softThreshold = 40% of context window. This gives the flush operation room to work without hitting the hard limit.

## `flushStrategy` Options

### `"summarize-and-append"`
At soft threshold:
1. Agent summarizes decisions, facts, and state from the current session
2. Appends summary to today's daily log
3. Session continues with compacted context

Best for: general sessions, research, long work sessions.

### `"checkpoint-and-continue"`
At soft threshold:
1. Agent writes a structured checkpoint (key-value format) to `BULLETIN.md`
2. Continues session
3. Next agent reads the checkpoint on startup

Best for: multi-agent workflows where continuity matters across agents.

### `"flush-and-pause"`
At soft threshold:
1. Agent writes full session summary
2. Pauses and prompts user to review before continuing
3. User can add context before session resumes

Best for: sensitive operations, long coding sessions, when you need to review.

## What Gets Preserved on Flush

Configure `preserveOnFlush` to tell the agent what's worth capturing:

```json
{
  "preserveOnFlush": [
    "decisions",          // Choices made, with reasoning
    "errors",             // What broke and why
    "user-preferences",   // Anything learned about the user
    "file-paths",         // Files created or modified
    "credentials-structure", // Account names (not secrets)
    "published-content",  // What was published where
    "api-endpoints",      // URLs and endpoints used
    "blockers"            // Current blockers + context
  ]
}
```

## Manual Flush (Any Time)

Trigger a flush without waiting for threshold:

```bash
openclaw memory flush --target memory/$(date +%Y-%m-%d).md
```

Or ask the agent:
```
Flush your current session context to memory. Preserve decisions, file paths, and any errors.
```

## Flush Output Format

A good flush output looks like:

```markdown
## Session Flush — 2026-03-18 14:32

### Decisions Made
- Chose Supabase over PlanetScale for content storage (cost + existing familiarity)
- Set publish schedule: Tue/Thu for Substack, daily for X

### Files Modified
- /workspace/scripts/publish.sh — added Substack endpoint
- /workspace/n8n/content-flow.json — updated trigger schedule

### Errors Encountered
- Supabase bucket permissions blocked upload — fixed by setting bucket to public
- n8n Substack node requires Substack session cookie, not API key

### Current State
- Publishing pipeline: complete
- Pending: test end-to-end with real content

### Next Session Should
- Verify published article renders correctly
- Check n8n error logs after first automated run
```

## Verifying Flush is Working

After a long session, check your daily log:

```bash
cat memory/$(date +%Y-%m-%d).md | grep "Session Flush"
```

If no flush entries exist after multi-hour sessions, lower `softThresholdTokens` or enable `flushOnSoftThreshold: true`.

## Memory File Size Limits

Daily logs can get large. Keep them manageable:

```json
{
  "compaction": {
    "dailyLogMaxKB": 50,
    "onLogFull": "create-overflow",
    "overflowPattern": "memory/YYYY-MM-DD-overflow-N.md"
  }
}
```

When a daily log hits 50KB, new flushes go to `YYYY-MM-DD-overflow-1.md`, then `-overflow-2.md`, etc.
