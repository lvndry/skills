---
name: assemble-a-team
description: >-
  Compose and run a team of role-specialist subagents instead of reasoning as
  one generalist. Invent whatever roster the task needs — e.g. CEO/CFO/CTO/
  product/GTM for a business, PM plus backend/frontend (splitting further into
  JS/state, CSS, design-system) for a web app, or reproduce/root-cause/fix/
  regression for a hard bug — illustrations, not a fixed menu.
  Each specialist grounds their view in current best practice via web search
  (not stale memory), and the team challenges each other before you converge.
  Re-check the user's goal between layers so the team cannot drift.
  Use WHENEVER a task is substantial and multi-disciplinary — launching a
  product, designing/building an app or feature, planning an architecture or
  migration, or a gnarly bug needing several angles. Also fire it the moment
  the user says "assemble a team", "spawn a team", "build me a team of
  experts", "I want a CEO/CTO/PM take", or asks for specialists to
  collaborate. Use proactively when about to one-shot multi-disciplinary work.
argument-hint: "[the project, build, or problem the team should tackle]"
---

# Assemble a Team

Hard, many-sided work is done by teams for a reason: no single generalist holds deep, current expertise across product, finance, backend, CSS, infra, and risk all at once. When you reason as one voice, you flatten that expertise into an average — competent everywhere, excellent nowhere, and blind to the tradeoffs each specialist would have caught instantly.

This skill assembles the team the task actually needs. You compose a roster of specialists tailored to the domain, brief each with a sharp mandate, make every one of them check current best practice rather than trust memory, and then have them challenge each other before you integrate their work into a coherent result. You play founder / tech lead / coordinator — you don't do all the thinking, you orchestrate people who each think better than you about their slice.

You also hold the user's goal still. Specialists drift toward the problem they are best at. Between every layer, check the work against the goal the user actually stated and put back whatever slipped. A sharp team that ships the neighboring problem has failed.

<task> #$ARGUMENTS </task>

## Principles

1. **The roster follows the task, not a template.** A library of example teams is below, but treat it as inspiration. The right team for *this* task may borrow from several, add a lens nobody listed, and skip roles that don't apply. Compose deliberately.
2. **Specialists are specific.** "An engineer" is weak. "A Postgres query-optimization specialist," "a Tailwind design-system specialist," "a CFO who lives in unit economics" — that's a specialist. Specificity is what makes the output sharper than your own generalist take.
3. **Current beats remembered.** Every specialist searches the web for the latest best practice in their niche and reports what's changed recently. Frameworks, pricing, security advice, and design conventions move fast; a team running on two-year-old memory is worse than useless because it's confidently stale.
4. **Productive friction.** A team that rubber-stamps each other is just one voice wearing hats. Specialists must react to and challenge each other's choices — the backend engineer pushes back on the frontend's API assumptions; the CFO questions the CEO's growth math. The conflicts are where the value is.
5. **You integrate; you don't average.** The synthesis is a judgment call, not a merge. When specialists disagree, pick a side with reasons — don't split the difference into mush.
6. **You are the hub; agents never talk directly.** Subagents run in isolation — there is no peer-to-peer channel between them. Every exchange routes through you: you brief them at spawn, and you relay one specialist's output into another's input. "Specialists challenge each other" always means *you* carried the message. Design the flow knowing that the dependency graph is real but you are the one who walks it. When you relay, carry the locked goal with the message, and drop relayed content that does not serve it.
7. **The goal is frozen; the plan is not.** Write the user's goal down in their words before anyone is spawned, and quote it in every brief. Specialists may change the approach, the sequencing, and the design. They may not change the goal, the constraints the user stated, or what "done" means.

---

## Two modes — choose deliberately

Decide up front whether the team **advises** or **builds**. It changes how you brief them and what they return.

- **Advisory mode** — strategy, planning, architecture, business decisions. Specialists return analysis, recommendations, and tradeoffs. You integrate into a plan or decision. (CEO/CFO/PM-type teams almost always run here.)
- **Build mode** — concrete artifacts: code, configs, schemas, copy, designs. Specialists produce real work. The hazard is parallel edits colliding, so either give each specialist a **non-overlapping area** (frontend touches `src/ui/`, backend touches `src/api/`), have them return **diffs/patches you apply**, or run them with **git worktree isolation** if your tooling supports it. Never let two build agents edit the same files concurrently.

Many real tasks are mixed: a short advisory pass to set direction, then a build pass to execute it. That's fine — run them as distinct phases.

---

## Flow

| Phase | Name       | Goal                                                              |
| ----- | ---------- | ----------------------------------------------------------------- |
| 0     | Scope      | Lock the user's goal, pick the mode, decide it's team-worthy      |
| 1     | Compose    | Build the roster and sketch the dependency graph (a shallow DAG)  |
| 2     | Dispatch   | Run in layers; re-check the goal before starting the next one     |
| 3     | Challenge  | Route outputs along named seams so specialists critique each other|
| 4     | Integrate  | Resolve conflicts, then prove the result meets the locked goal    |

### Phase 0: Scope

State the task in a sentence, pick advisory vs build, and sanity-check that a team is warranted. Small, single-discipline tasks don't need one — assembling five agents to rename a variable is theater. A team earns its cost when the work genuinely spans disciplines or benefits from specialists arguing.

Then lock two things and do not edit them later:

- **Goal** — the user's ask, in their words. Quote it. A paraphrase is how the goal gets replaced by something easier.
- **Done-check** — the few concrete outcomes that mean that goal is met, pulled from what the user actually asked. If you cannot name them, the goal is ambiguous: ask one focused question and wait. Do not invent a substitute goal and run the team against that.

A root who "cuts scope" by dropping a done-check item must surface that cut to the user before anyone builds on it. Silently executing a smaller goal is the usual way this skill misses. Carry the goal quote and the done-check into every brief, verbatim, including challenge respawns.

### Phase 1: Compose the team

Pick the specialists the task demands. Keep it lean — 3 to 6 well-chosen roles beat a crowd; every extra agent is more to brief, read, and reconcile. Add a layer of hierarchy only when a slice is big enough to need its own sub-team: a **Frontend Lead** coordinating JS/state, CSS/layout, and Tailwind specialists; a **CTO** over backend and infra engineers. Flat is the default; nest when it genuinely helps and the work has clean seams.

Then sketch how the roles **depend** on each other — this is what turns a flat roster into a team. Real work has an order: scope before estimate, API contract before the frontend that consumes it, architecture direction before the specialists who build under it. Lay the roles out as a **shallow dependency graph (a DAG), not a single parallel blast**:

- **Roots** — roles whose output everyone else needs (the PM's scope cut, the lead's architecture direction). Usually 1–2 roles. They run first.
- **Fan-out** — the specialists, each fed the roots' output so they build on a shared foundation instead of guessing at each other's assumptions.
- **Seams** — the specific pairs whose interfaces couple them (backend↔frontend contract, product scope↔engineering cost). These become the challenge edges in Phase 3.

Keep the graph shallow — 2 to 3 layers. Depth is latency: every layer is another round you wait on, so don't serialize what could run together. And remember you (the coordinator) are the only one who can move information along an edge; the agents can't hand off to each other.

Tell the user the roster, the dependency sketch, and why you picked it — it makes the reasoning legible and lets them add a specialist or an edge you missed.

**Example rosters** (starting points, not menus):

- *Launching a business / product:* CEO (vision, positioning), CFO (unit economics, funding, runway), CTO (build-vs-buy, tech strategy), Head of Product (users, roadmap, scope), GTM/Marketing lead (channels, pricing), and a Legal/Risk lens when regulation or contracts are in play.
- *Building a web app or feature:* Product Manager (user stories, scope cut), Backend engineer (data model, API, performance), **Frontend Lead** → JS/state-management specialist, CSS/layout specialist, Tailwind/design-system specialist; plus DevOps/infra and a QA/test specialist as the surface area grows.
- *Fixing a hard bug:* Reproduction specialist (make it happen reliably), root-cause investigator (trace it to the line), fix author (smallest correct change), regression/test specialist (lock it shut), and a skeptic who argues the fix is wrong or incomplete.
- *Architecture / migration:* a specialist per system or boundary in play, plus a pragmatist on cost and reversibility and a pre-mortem voice on how the migration fails.

### Phase 2: Dispatch — in layers

Walk the DAG from Phase 1, one layer at a time. Within a layer, spawn everyone as **parallel subagents** (however your runtime launches concurrent agents) — independent specialists give real diversity, and parallelism is free when there's no dependency between them. Between layers, wait: collect a layer's outputs, then feed them into the next layer's briefs so dependents build on what's settled rather than guessing.

Before you spawn the next layer, check the work you are about to hand on. Restate the locked goal — the quote, not your summary of the last layer — and mark each done-check item covered, still open, or dropped. If a root output conflicts with the goal, do not feed that output downstream as settled. Put the goal back in the next briefs, or stop and ask the user about the cut. A layer of sharp specialist work that left a done-check item uncovered has not finished; the next briefs name that gap.

The common shape is just two layers — a small root layer (scope / architecture direction), then a context-fed fan-out of the specialists. Don't add depth you don't need; if two roles don't actually depend on each other, they belong in the same layer.

Give every agent the **shared context** (the task, constraints, what's been decided) plus their **own mandate**. For fan-out roles, the shared context includes the relevant **root outputs** — that's the whole point of layering. In every brief, require three things: current practice and a real position, so the team beats a generalist, and a hard tie back to the locked goal:

- **Ground in current best practice.** "Search the web for the current best way to do this in your specialty as of now. Report what's changed recently and what you'd have gotten wrong from memory. Prefer recent, primary sources and cite them."
- **Take a real position.** "Don't hedge across options — recommend one and defend it. Name the tradeoff you're accepting."
- **Serve the locked goal.** "The goal and done-check below are fixed. Recommend the move that hits them. If your best specialist advice does not, return GOAL MISS and name the neighboring problem you were about to solve — do not solve it."

Ask for a tight, comparable response so integration is fast:

```
ROLE: <specialty>
RECOMMENDATION: <the call you're making, in a sentence>
GOAL FIT: <which done-check items this moves — or GOAL MISS and the neighboring problem you refused>
RATIONALE: <why — grounded in current best practice, with sources>
INTERFACES / DEPENDENCIES: <what you need from, or hand to, other roles>
RISKS & OPEN QUESTIONS: <what could bite; what you're unsure of>
OUT OF SCOPE: <interesting work you are explicitly not doing>
```

In build mode, also specify the exact files/area the specialist owns and the artifact to produce.

### Phase 3: Challenge — along the seams

This is what makes it a team and not a list of consultants. Take the **seams** you identified in Phase 1 — the pairs whose interfaces couple them — and route each specialist's output to its counterpart for critique: "Here's the contract the backend actually specified; as the frontend engineer, where does your plan break, and what do you now change?"

Carry that critique across the seam the way every runtime supports: **spawn a fresh agent in the counterpart's role and hand it both its own prior output and the peer's.** You're the hub, so you control exactly what it sees — give it its earlier position verbatim and tell it to *react from that stance* rather than start over, so it defends or revises instead of drifting into a bland re-answer. (If your runtime can instead *continue* the original agent in place — keeping its full context for free — that's a fine shortcut, but don't count on it; spawning fresh with context works anywhere.)

Critique **along edges, not all-to-all**. Every specialist challenging every other is N² messages, mostly noise, and it drifts back into one averaged voice — the echo-chamber failure mode. Target only the seams that actually carry tension (backend↔frontend contract, product scope↔engineering cost, CEO growth math↔CFO runway). One sharp round on the real seams beats a full mesh.

A critique earns its round only if it changes whether the goal gets met, or breaks an interface the goal depends on. Hand the critic the locked goal along with both positions. A craft objection that leaves the done-check untouched is noise; drop it.

Because you are the hub, *you* carry each message across the seam — there is no direct channel between the two specialists. That's fine; it also means you see every exchange and can stop a round early once the live conflicts are clear.

### Phase 4: Integrate

As coordinator, pull it together — and make the calls the team couldn't. Re-read the user's original message before you do; integrate against that, not against the team's restatement of it. Resolve each conflict by picking a side with reasons, not by averaging.

Open with a **goal ledger**: each done-check item, met or not, and where the evidence is. Unmet items go first. Do not present a coherent plan that misses the goal and call the run complete — either close the gap with another pass, or tell the user plainly what you did not achieve and why.

Then deliver:

**The decision / plan** (advisory) or **the integrated artifact** (build) — coherent, not a stapled-together pile of specialist outputs.

**Where the team disagreed and how you ruled** — the live tensions and your reasoning. This is the most valuable part; don't bury it.

**What current best practice changed** — the things the web search surfaced that the team would have gotten wrong from memory, with sources.

**Open questions and risks** — what the team flagged that still needs a human call.

---

## Failure modes to avoid

- **Goal drift.** The team returns confident, well-sourced work on a problem next door to the one the user asked. It happens when a root rewrites the goal as a "scope cut," when briefs carry a paraphrase instead of the user's words, or when integration rewards coherence over completion. Quote the goal, check it between layers, and refuse to ship a ledger with a silent miss.
- **The crowd.** Ten agents is not better than five good ones — it's more to reconcile and a higher chance of mush. Compose lean; every role must earn its seat.
- **The echo chamber.** If the specialists all agree, you either picked redundant roles or briefed them too softly. Sharpen mandates and force the challenge round.
- **Stale experts.** A specialist who doesn't actually search and just recites memory defeats the point. Insist on current sources; a confident wrong answer from an "expert" is worse than an honest "I'd need to check."
- **The merge that pleases everyone.** Integration is where you decide, not where you avoid deciding. Splitting every disagreement down the middle produces a plan no specialist would endorse.
- **Concurrent edits in build mode.** Two agents writing the same file in parallel corrupt each other's work. Assign non-overlapping areas, collect patches, or isolate — always.
