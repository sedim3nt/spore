# Source Ranking Guide

How to weight sources when synthesizing research. Use this to calibrate confidence levels.

## Reliability Tiers

### Tier 1 — Primary Sources (CONFIRMED)
Use these for factual claims without caveats.

- Official company announcements (press releases, SEC filings, blog posts from the org itself)
- Peer-reviewed research and academic papers
- Government data and official statistics
- Direct quotes or statements from named individuals in context
- Open source code repositories (what the code actually does)
- Product documentation and changelogs

**Weight:** Full trust on facts stated. Still apply judgment on interpretation.

---

### Tier 2 — Quality Secondary (LIKELY)
Use these with attribution. Good for context and analysis.

- Major newspapers with editorial standards (NYT, FT, WSJ, Reuters, AP)
- Established trade publications in specific verticals
- Well-regarded industry analysts (Gartner, Forrester, CB Insights — note: often paywalled summaries)
- Long-form journalism with named sources
- Podcasts/interviews where subject speaks on record

**Weight:** Trust reported facts, but note "per [source]." Double-check extraordinary claims.

---

### Tier 3 — Community/Secondary (SPECULATIVE unless corroborated)
Use with explicit caveats. Good for trends and sentiment, not facts.

- Medium, Substack, personal blogs (quality varies wildly)
- Reddit, Hacker News, Discord threads
- LinkedIn posts (even from executives — these are often marketing)
- Twitter/X (real-time but unverified)
- YouTube videos and podcasts from non-established creators
- Wikipedia (good starting point, always follow the citations)

**Weight:** "Community discussion suggests..." or "According to [name], though unverified..."

---

### Tier 4 — Unreliable (Do Not Use Without Verification)
Do not cite these as sources. They may contain signals worth following up.

- Anonymous forum posts
- Sites with obvious commercial bias toward the topic
- AI-generated content farms (detect via generic writing, no bylines, no dates)
- Sites that aggregate without attribution
- Press releases from unknown companies (they say what they want you to hear)

---

## Conflict Resolution

When sources disagree:

1. **Prefer primary over secondary** — the company's own statement beats the journalist's interpretation
2. **Prefer recent over old** — fast-moving topics; a 6-month-old article may be stale
3. **Prefer specificity** — "Revenue grew 40% to $12M" beats "strong revenue growth"
4. **When unresolvable:** Surface the conflict explicitly in the brief. Don't pick a side.

## Recency Guidelines

| Topic Type | Useful Age |
|-----------|-----------|
| AI/tech releases | 2 weeks |
| Market/financial data | 24 hours |
| Competitive intelligence | 30 days |
| Policy/regulatory | 90 days |
| Academic research | 2 years |
| Historical context | No limit |

## Confidence Level Assignments

| Claim Type | Confidence Level |
|-----------|----------------|
| Direct quote from official source | CONFIRMED |
| Reported by Tier 1-2 source, plausible | LIKELY |
| Based on inference or Tier 3 sources | SPECULATIVE |
| Contradicted by any source | Note conflict explicitly |
| Based on a single source only | Flag with "single source" |
