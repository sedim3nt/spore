# Failure Model

Where multi-agent systems break, and what to do about it.

_Update this file as new failure patterns emerge. Review monthly._

---

## Known Failure Patterns

### 1. Context Drift
**Symptom:** Output quality degrades after 10+ file reads in a session  
**Root cause:** LLMs have finite attention; late-session context is weighted lower  
**Prevention:** Keep context lean. Pre-fetch at start; don't accumulate mid-task  
**Recovery:** Start a new session with a tighter context window  

### 2. Phantom Success
**Symptom:** Agent reports "done" but the deliverable is broken or missing  
**Root cause:** Agent inferred success from intermediate signals, not actual verification  
**Prevention:** Require smoke tests. "It should work" is not a smoke test.  
**Recovery:** Re-run verification step; add explicit acceptance criteria to the spec  

### 3. Spec Incompleteness
**Symptom:** Agent makes wrong assumptions; output is correct but not what you wanted  
**Root cause:** The handoff was ambiguous or missing constraints  
**Prevention:** Use `templates/handoff.md`. Run the self-containment test.  
**Recovery:** Rewrite spec with explicit constraints; note the assumption that was wrong  

### 4. Agent Overclaiming
**Symptom:** Agent claims to have done something it didn't (or couldn't)  
**Root cause:** Completion pressure; agent optimizes for appearing done  
**Prevention:** Ask for evidence. "Show me the file path" or "paste the test output"  
**Recovery:** Verify all deliverables independently; treat unchecked claims as draft  

### 5. Scope Creep
**Symptom:** Agent modifies files outside the spec; unintended side effects  
**Root cause:** Agent extended spec to "improve" things not in scope  
**Prevention:** Explicit "do NOT touch" constraints in every handoff  
**Recovery:** Git diff to review all changes; revert anything outside spec  

### 6. Memory Fragmentation
**Symptom:** Agent doesn't know about past decisions or contradicts earlier work  
**Root cause:** Session-based memory; context not written to files  
**Prevention:** Daily memory logs. Key decisions go in MEMORY.md.  
**Recovery:** Write a "context restore" file before the next session  

### 7. Model Capability Mismatch
**Symptom:** Task requires deeper reasoning than the model can provide  
**Root cause:** Routing a complex task to a weaker model  
**Prevention:** Use Opus for orchestration; Sonnet for specialized work; have a capability matrix  
**Recovery:** Re-route to stronger model; break task into smaller pieces  

### 8. Publishing Without Verification
**Symptom:** Content published with formatting errors, wrong content, or to wrong target  
**Root cause:** Agent trusted API success response without checking the actual result  
**Prevention:** Verify every publish by fetching the live URL  
**Recovery:** Delete and republish; add explicit verification step to all publish workflows  

---

## Escalation Protocol

When an agent failure is not covered above:

1. **Document it here** — failure name, symptom, root cause, recovery
2. **Add prevention to the relevant ROLE.md** — make it structural
3. **Review after 5 instances** — if a pattern persists, redesign the workflow

---

## Monthly Review Checklist

- [ ] Review failure log from past month
- [ ] Any new patterns not yet documented?
- [ ] Are existing patterns being prevented (or still occurring)?
- [ ] Any ROLE.md updates needed based on failures?
- [ ] Capability matrix still accurate for current models?

_Last reviewed: <!-- YYYY-MM-DD -->_
