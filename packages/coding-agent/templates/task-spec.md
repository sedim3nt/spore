# Task Specification Template

Use this template when delegating coding tasks. A well-written spec reduces back-and-forth by 80%.

The test: could a competent engineer complete this task without asking a single question? If no, the spec is incomplete.

---

# Task: [Task Name]

**Assigned to:** Coding Agent  
**Priority:** HIGH / MEDIUM / LOW  
**Estimated complexity:** Small (< 2h) / Medium (2-4h) / Large (> 4h)  
**Due:** YYYY-MM-DD or "ASAP"

---

## Problem Statement

[What problem does this solve? 2-3 sentences. Why does it need to be done?]

---

## Acceptance Criteria

Every criterion must be independently verifiable by a third party:

- [ ] [Specific, testable criterion — e.g., "POST /auth/login returns 200 with a valid JWT when credentials are correct"]
- [ ] [Another criterion — e.g., "POST /auth/login returns 401 when password is wrong"]
- [ ] [Another criterion — e.g., "Sessions expire after 24 hours"]
- [ ] [Another criterion — e.g., "All TypeScript checks pass with `tsc --noEmit`"]
- [ ] [Another criterion — e.g., "Unit tests achieve > 80% coverage on auth module"]

---

## Technical Requirements

**Files to create or modify:**
- `src/auth/session.ts` — [what changes]
- `src/api/routes/auth.ts` — [what changes]
- `tests/auth.test.ts` — [what changes]

**Technologies / libraries:**
- [Framework/library + version if important]
- [External API, if any]

**Data shapes (if applicable):**
```typescript
// Input
interface LoginRequest {
  email: string;
  password: string;
}

// Output
interface AuthToken {
  token: string;
  expiresAt: Date;
}
```

---

## Constraints

What the agent must NOT do:
- [ ] Do not modify `src/database/schema.ts` — schema is frozen
- [ ] Do not use `any` types
- [ ] Do not add new npm dependencies without approval
- [ ] [Other constraints]

Preferences among valid approaches:
- Prefer [approach A] over [approach B] because [reason]
- When in doubt, [decision rule]

---

## Context

**Relevant files to read first:**
- `src/auth/` — existing auth code
- `tests/auth.test.ts` — existing test patterns
- `docs/api.md` — API contract documentation
- [Other files]

**External docs:**
- [Library docs URL]
- [API reference URL]

**Related work:**
- [Link to related PR, issue, or task]

---

## Deliverables

1. Working implementation meeting all acceptance criteria
2. Tests with coverage of happy path and main error cases
3. PR with description following `templates/pr-template.md`
4. Smoke test result in the PR description

---

## Out of Scope

Explicitly excluded from this task (prevents scope creep):
- [Thing that might seem related but isn't in scope]
- [Another thing]
