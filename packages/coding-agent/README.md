# Coding Agent

**Version:** 1.0 | **Setup Time:** 10 minutes

An AI coding agent configured with the Blueprint Pattern — a structured 8-step process that catches bugs in CI before they ship. Production-tested for complex multi-file builds.

## Quick Start

1. Copy ROLE.md to your agents directory:
   ```bash
   cp ROLE.md ~/.openclaw/workspace/agents/builder/ROLE.md
   ```
2. Copy templates to your workspace:
   ```bash
   cp -r templates/ ~/.openclaw/workspace/templates/coding/
   ```
3. When delegating a coding task, use `templates/task-spec.md` to write the spec
4. The agent follows the Blueprint Pattern automatically

## The Blueprint Pattern

8 steps. Non-negotiable. Every coding task.

```
1. PRE-FETCH  — gather all files, docs, context before writing a line
2. LLM LOOP   — generate code
3. DETERMINISTIC — lint, typecheck, test (no AI in this step)
4. LLM LOOP   — interpret results, fix issues
5. DETERMINISTIC — lint, typecheck, test again
6. CAP        — max 2 rounds; if still failing, escalate
7. SUBMIT     — PR or report results
8. SMOKE TEST — verify one real data sample flows end-to-end
```

## Files Included

| File | Purpose |
|------|---------|
| ROLE.md | Agent role with Blueprint Pattern |
| BLUEPRINT-PATTERN.md | Detailed pattern with examples |
| templates/task-spec.md | How to write good task specs |
| templates/pr-template.md | Pull request template |

## Requirements

- OpenClaw with exec capability
- Git access to your repositories
- `gh` CLI for GitHub operations (optional but recommended)
