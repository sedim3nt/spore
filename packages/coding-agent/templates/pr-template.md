# Pull Request Template

Copy this into your PR description for every pull request.

---

## Summary

[1-2 sentences: what changed and why]

## Problem

[What issue does this solve? Link to ticket/spec if available]

## Solution

[How did you solve it? Keep this brief unless the approach is non-obvious]

## What Changed

- `src/auth/session.ts` — added SessionManager class with create/validate methods
- `src/api/routes/auth.ts` — added POST /auth/login endpoint
- `tests/auth.test.ts` — added 8 tests covering auth flow
- [list every file changed + 1-line description of change]

## Testing

**Unit tests:**
```
✓ SessionManager.create() returns valid token
✓ SessionManager.validate() returns null for expired sessions
✓ POST /auth/login returns 200 with valid credentials
✓ POST /auth/login returns 401 with invalid credentials
[8 tests, all passing]
```

**Smoke test:**
```bash
# Test command
curl -X POST http://localhost:3000/auth/login \
  -d '{"email":"test@test.com","password":"test123"}'

# Result
{"token":"eyJ...","expiresAt":"2026-03-19T12:00:00.000Z"}

# Verified session works
curl http://localhost:3000/api/me -H "Authorization: Bearer eyJ..."
# → {"id":"123","email":"test@test.com"}
```

**Deterministic checks:**
- [ ] `tsc --noEmit` ✅ (0 errors)
- [ ] `eslint src/` ✅ (0 warnings)
- [ ] `npm test` ✅ (all passing)

## Screenshots / Demo

[Include if there's a UI change or if a visual helps]

## Notes / Deviations from Spec

[Any places where you did something different from what was specified, and why]

- The spec asked for Redis session storage, but the Redis client wasn't available in the test environment. Used in-memory map for now — marked with TODO for production.

## Known Limitations

[Anything that's NOT handled that might be expected]

- Session invalidation (logout) is not implemented — out of scope per spec
- No rate limiting on login attempts — tracked as follow-up issue

## Reviewers

[Tag anyone who should review this]

---

**Checklist:**
- [ ] Tests added for new functionality
- [ ] Smoke test run and documented above
- [ ] No new TypeScript errors
- [ ] No lint warnings introduced
- [ ] Description explains WHY not just WHAT
