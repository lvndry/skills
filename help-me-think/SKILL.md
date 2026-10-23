---
name: help-me-think
description: >-
  Spin up a team of perspective-diverse subagents that challenge the current
  idea, expose blind spots and unexamined assumptions, search the web for prior
  art and contradicting evidence, and surface options that aren't on the table —
  then synthesize it all into clearer, unstuck thinking. Use this WHENEVER you
  feel genuine doubt: a plan that feels shaky, a decision that's hard to reverse,
  an assumption you've been taking for granted, a recommendation you're about to
  give but aren't sure of, or when you're simply stuck. Also use it the moment
  the user says "help me think", "challenge this", "what am I missing", "poke
  holes in this", "red-team this", "am I wrong?", "is this a good idea?", or asks
  for a second opinion / devil's advocate. Reach for it proactively — the cost of
  a few minutes of structured challenge is far lower than the cost of confidently
  shipping a flawed idea.
argument-hint: "[the idea, plan, or decision you want challenged]"
---

# Help Me Think

When you are in doubt, the worst thing you can do is reason in a single voice. One line of thought compounds its own blind spots — it rationalizes, it anchors on the first plausible answer, it defends the status quo because the status quo is what it already believes. This skill breaks that loop by convening a team of independent thinkers, each with a sharp and *different* mandate, and forcing the idea to survive contact with all of them.

The goal is not a committee report. The goal is to change what you believe — to come out the other side with a clearer view, a stronger plan, or a genuinely new option you couldn't see before.

<idea_under_examination> #$ARGUMENTS </idea_under_examination>

## Principles

1. **Doubt is the trigger, not failure.** Noticing you're unsure is a strength. The moment you catch yourself rationalizing, hedging, or defending a choice you haven't really examined — convene the team.
2. **A crisp proposition beats a vague topic.** The team can only challenge what's stated clearly. "Should we use a queue?" is weak. "We should add a Redis-backed job queue to handle webhook spikes instead of processing inline" is something a team can actually attack.
3. **Diversity is the entire point.** Five agents that agree are worth less than two that genuinely conflict. Each perspective must be given a distinct, even adversarial, mandate — and permission to disagree with you and with each other.
4. **Challenge serves a decision.** This isn't deliberation for its own sake. Every round ends with you taking a position: what you now believe, what changed, and what you'd do.
5. **Timebox, then decide.** The team exists to unlock thinking, not to stall it. One round is usually enough. Don't let infinite challenge become its own form of paralysis.

---

## Flow

| Phase | Name      | Goal                                                                    |
| ----- | --------- | ----------------------------------------------------------------------- |
| 0     | Frame     | State the proposition crisply and name the kind of doubt                |
| 1     | Assemble  | Pick the team: fixed core + adaptive lenses chosen for this doubt       |
| 2     | Dispatch  | Run the team in parallel, each with a sharp distinct mandate            |
| 3     | Synthesize| Collect, weigh, and form a new position with explicit confidence        |

---

### Phase 0: Frame

Before spawning anyone, get the proposition into one or two sentences a stranger could attack. If the user handed you something vague, sharpen it — and if the core decision is genuinely ambiguous, ask one focused question rather than guessing.

State two things to yourself (and briefly to the user):
- **The proposition** — the specific claim, plan, or choice on the table.
- **The kind of doubt** — which of these is it? It shapes who you recruit:
  - *Is this direction right?* (a decision or tradeoff)
  - *What am I not seeing?* (blind spots in an otherwise-settled plan)
  - *Is there a better option?* (the solution space feels too narrow)
  - *Is this assumption actually true?* (something is being taken on faith)
  - *I'm stuck* (no clear path forward at all)

---

### Phase 1: Assemble the team

Always include the **core two** — they cover the failure modes that bite hardest, defending against your own confidence and against your own stale knowledge:

- **Devil's Advocate** — Makes the strongest possible case that the proposition is *wrong*. Not nitpicks — the load-bearing objection. Hunts the unexamined assumption, the ignored cost, the failure mode under load, the reason smart people would reject this. Defaults to disagreement and has to work to be convinced.
- **Researcher** — Goes and finds out what's actually true out there rather than trusting memory. Searches the web for how others solved this, prior art, recent developments, and especially *contradicting* evidence. Reports what the world knows that you don't. (Uses whatever web-search and page-fetch tools your platform exposes — e.g. `web_search` / `fetch_url`.)

Then add **2–3 adaptive lenses** chosen to fit the specific doubt. Don't run all of these — pick the ones that bite:

- **First-Principles thinker** — Strips away convention and "how it's usually done," rebuilds from what must actually be true. Best when the status quo is the thing in doubt.
- **Lateral / Creative** — Generates genuinely different options, the ones not currently on the table. Best when the solution space feels too narrow.
- **Pragmatist** — Asks what's the simplest thing that works, what the cost of being wrong is, and whether the decision is reversible. Best for big or expensive choices.
- **Pre-mortem / Future Self** — It's six months later and this failed. Narrates *why*. Best for plans that feel fine right now.
- **Domain lens** — A specific expert angle the situation demands: security, cost, scale, UX, maintainability, legal, data integrity, team dynamics. Pick the one that's actually at stake.
- **Steelman** — Builds the strongest case *for* the proposition, so the synthesis weighs a real defense and not just a pile of objections.

Tell the user who you recruited and why — it makes the reasoning legible and lets them add a lens you missed.

---

### Phase 2: Dispatch in parallel

Spawn the team as **parallel subagents** — launch them concurrently, however your runtime does that, so none can see the others' work while they think. That independence is what buys you real diversity; running them in sequence just lets later voices anchor on the earlier ones.

Give every agent the same shared context (the proposition, the relevant background, and what you're unsure about) plus its *own* distinct mandate. Insist on substance over politeness — an agent told to challenge must actually challenge.

Ask each agent to return a tight, structured response so synthesis is fast:

```
PERSPECTIVE: <role>
BOTTOM LINE: <one sentence — does this hold up, from your angle?>
STRONGEST POINTS:
  - <point + why it matters; for the Researcher, cite sources>
WHAT YOU'D CHANGE: <concrete alternative or fix, if any>
CONFIDENCE: <how sure are you, and what would change your mind>
```

Keep mandates sharp. A weak prompt ("review this plan") produces a weak agent. Examples of the difference:

- Devil's Advocate — *not* "any concerns?" but: "Argue that this proposition is a mistake. Find the assumption it rests on that might be false, the cost being ignored, and the conditions under which it fails badly. I want your best refutation, not a balanced take."
- Researcher — *not* "look into this" but: "Search the web for how others have approached this exact problem, what the current best practice is, and any evidence that contradicts the proposition. Prioritize recent, primary sources. Report what I'm likely getting wrong from memory."

---

### Phase 3: Synthesize

This is where thinking actually unlocks — and it's *your* job, not delegated. Read every response, weigh them against each other (especially where they conflict), and form a new position. Resist the urge to just summarize; the point is what *changed*.

Report back to the user with:

**What changed** — The belief, plan, or decision that's different now than before the team ran. If nothing changed, the team confirmed the direction *and* you can say why with more confidence — that's a real outcome too.

**The strongest surviving objection** — The one challenge that held up under scrutiny, even if you're proceeding anyway. Naming it is how you stay honest.

**New options on the table** — Anything the team surfaced that wasn't being considered before.

**Recommendation + confidence** — Where you land, how sure you are, and the single thing that would most change your mind. Hand the decision back to the user with the reasoning laid bare, not buried.

Keep it crisp. The team did the divergent work; the synthesis should converge.

---

## Failure modes to avoid

- **The yes-man team.** If every agent agrees with you, you assembled them wrong — soften no mandates, sharpen the adversarial ones, and consider whether the proposition was framed to invite agreement.
- **Mush in, mush out.** A vague proposition yields vague challenge. Spend the time in Phase 0; it pays back many times over.
- **Synthesis-as-stenography.** Listing what each agent said is not thinking. The value is in the weighing and the position you take afterward.
- **Endless rounds.** If a second round isn't surfacing genuinely new ground, stop. Decide. The skill is a lever, not a treadmill.
