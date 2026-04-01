# Voice Profile Builder

How to extract your authentic brand voice from 10 writing samples and turn it into a profile your AI agent can replicate.

## Why 10 Samples?

One sample gives you tone. Three give you patterns. Ten give you the underlying system — the rules you follow without knowing you're following them.

## Step 1 — Gather 10 Samples

Collect 10 pieces of YOUR best writing:
- Blog posts or articles (best source)
- Long-form emails or newsletters
- Social posts you're proud of
- Forum or community posts
- Documentation you've written

**What NOT to include:**
- Content you collaborated heavily on (others' voice is in there)
- Content written under a style guide you found constraining
- First drafts (find polished pieces)

Save each as a text file: `voice-samples/sample-01.txt` through `sample-10.txt`

## Step 2 — Analyze with Your Agent

Prompt:
```
I'm going to share 10 pieces of my writing. Analyze them for voice and extract a systematic voice profile. Look for:

1. Sentence length distribution (short/medium/long — when does each appear?)
2. Vocabulary patterns (technical vs plain, formal vs casual, recurring words/phrases)
3. Structural patterns (how do I start sections? How do I end them?)
4. Rhetorical moves (do I use analogies? Questions? Specific examples? Lists?)
5. What I DON'T do (what's conspicuously absent?)
6. Signature phrases or verbal tics
7. Emotional register (warm/cool, urgent/measured, confident/questioning)
8. What makes this voice distinctive vs generic writing

Analyze all 10 samples before producing the profile. I want patterns, not impressions.

[Paste samples below, separated by ---]
```

## Step 3 — Validate the Profile

After the agent produces a voice profile:
1. Read it carefully — does it feel true?
2. Have it write a test paragraph in the described voice
3. Read the test paragraph — does it sound like you?
4. Identify what's wrong and iterate

Common issues:
- Profile is too abstract ("direct and clear" describes everyone)
- Misses something central ("I always use a single line after a long section for punch")
- Includes something wrong ("I don't actually use bullet lists much")

## Step 4 — Test Prompts

Test your voice profile with these exercises:

**Rewrite test:**
```
Rewrite this paragraph in my brand voice: [paste generic AI-written text]
```

**From-scratch test:**
```
Write a 3-paragraph intro to an article about [your topic] in my brand voice.
```

**Edit test:**
```
This draft doesn't sound like me. What's off, and can you fix it? [paste draft]
```

## Step 5 — Finalize Profile

Copy the validated profile into your ROLE.md under "Voice Profile."

Update it every 6-12 months — voices evolve.

## Voice Profile Template

Fill this in after the analysis:

```markdown
## Voice Profile

### Sentence Rhythm
[How long are sentences? When do they get longer? When shorter?]

### Vocabulary
[Technical level, formality, recurring words, avoided words]

### Structure
[How do openings work? How do sections transition? How do endings land?]

### Rhetorical Moves
[Analogy? Examples? Data? Questions? Humor? When and how?]

### Register
[Warm/cool? Urgent/measured? Confident/questioning?]

### The X Factor
[What makes this voice specifically yours? The thing that's hard to name?]

### What It's NOT
[Specific things this voice doesn't do]

### Signature Patterns
[Specific recurring moves]
```
