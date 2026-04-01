# Spaced Repetition Schedule

Review material before you forget it — not after. This schedule maximizes retention with minimum review time.

## How Spaced Repetition Works

Your brain forgets in a predictable curve. If you review just before the forgetting threshold, you rebuild the memory stronger each time. The intervals grow with each successful review.

**Standard intervals:**
- First review: 1 day after initial study
- Second review: 3 days later
- Third review: 7 days later
- Fourth review: 14 days later
- Fifth review: 30 days later
- Maintenance: every 60-90 days

---

# Spaced Repetition Schedule: [Topic]

**Started:** YYYY-MM-DD

---

## Review Schedule

| Unit / Concept | Learned | Review 1 | Review 2 | Review 3 | Review 4 | Review 5 |
|----------------|---------|----------|----------|----------|----------|----------|
| [Concept 1] | YYYY-MM-DD | MM-DD | MM-DD | MM-DD | MM-DD | MM-DD |
| [Concept 2] | | | | | | |
| [Concept 3] | | | | | | |

*If review goes poorly (< 70% recall): reset interval — review again in 1 day.*

---

## Today's Reviews

Generated daily by agent when review is due.

**Agent prompt:**
```
Check my spaced repetition schedule at learning/[topic]/review-schedule.md.
Which concepts are due for review today?
For each due concept: generate 3-5 recall questions.
After I answer, tell me which I got right/wrong and update the schedule.
```

---

## Review Question Types

For each concept, prepare questions in multiple formats:

**Recall:** "What is [concept]? Explain it without looking at notes."

**Recognition:** "True or false: [statement about concept]. Explain why."

**Application:** "How would you use [concept] to solve [specific problem]?"

**Connection:** "How does [concept A] relate to [concept B]?"

**Edge case:** "What happens when [unusual condition]? Does [concept] still apply?"

---

## Flashcard Bank

Generate flashcards for dense factual material:

| Front | Back |
|-------|------|
| [Question or term] | [Answer or definition] |
| | |

---

## Review Log

| Date | Concepts Reviewed | Score (recall %) | Notes |
|------|-----------------|-----------------|-------|
| YYYY-MM-DD | [list] | [X]% | |

---

## Retirement Criteria

Retire a concept from active review when:
- You've passed 5 reviews with > 90% recall each
- You use it regularly in practice (real-world repetition replaces scheduled review)
- Move to `learning/[topic]/retired-concepts.md` with final review date
