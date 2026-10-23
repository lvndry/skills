---
name: investigate-bug
description: >-
  Investigates whether a reported bug or issue actually exists by navigating the
  codebase like a detective — building evidence, forming theories, and
  collaborating with the user when expected behavior is ambiguous. Use when the
  user reports a bug or unexpected behavior that isn't clearly reproducible,
  when the root cause isn't obvious, when the bug might be a misunderstanding
  of intended behavior, or when the user says "I think there might be a bug",
  "something feels off", "investigate this", "look into this issue", or
  "could this be a bug?"
argument-hint: "[description of the suspected issue or unexpected behavior]"
---

# Investigate Bug

Navigate the codebase like a detective. The issue may be real, subtle, or nonexistent — your job is to find out which, with evidence.

<suspected_issue> #$ARGUMENTS </suspected_issue>

## Detective Principles

1. **The bug might not exist.** Treat reports as leads, not facts. A confirmed bug requires evidence.
2. **Expected behavior is a variable.** When you are unsure what correct behavior looks like, ask the user — do not assume.
3. **Follow the evidence, not the heuristics.** Don't reach for common bug patterns before reading the actual code.
4. **One theory at a time.** Test theories one by one. Do not rewrite multiple theories into a single fix attempt.
5. **Collaboration over assumption.** When the investigation hits genuine ambiguity — in intent, in design, in expected output — surface it immediately rather than guessing.

---

## Execution Flow

| Phase | Name        | Goal                                                                     |
| ----- | ----------- | ------------------------------------------------------------------------ |
| 0     | Brief       | Understand the report and establish what "correct" looks like            |
| 1     | Orient      | Map the terrain — identify relevant files, modules, and entry points     |
| 2     | Investigate | Follow the code path, gather evidence, form and test theories            |
| 3     | Collaborate | Surface ambiguities; confirm expected behavior with the user             |
| 4     | Verdict     | Declare findings with evidence: confirmed bug / not a bug / inconclusive |

---

### Phase 0: Brief

Parse the suspected issue and establish ground truth.

**Extract from the report:**
- What behavior was observed
- What behavior was expected
- Any reproduction steps, error messages, or stack traces provided
- The environment or conditions where it occurs

**Determine if expected behavior is clear.** If it isn't — for example, the report says "this feels wrong" without specifying what right looks like — ask one focused question before proceeding:

> "What would correct behavior look like here?"

Do not ask more than one question at a time. If expected behavior is clear enough to proceed, do so and revisit ambiguity in Phase 3 if it surfaces during investigation.

**If the report references an issue tracker** (GitHub `#123`, Linear ID, Jira key, URL): fetch the issue before proceeding.
- GitHub: `gh issue view <number> --json title,body,comments,labels`
- Other trackers: use available MCP tools, or ask the user to paste the relevant content if fetching fails.

---

### Phase 1: Orient

Build a map of the relevant codebase terrain before diving in.

1. **Identify the surface area** — which files, modules, or packages are most likely involved based on the report
2. **Understand the expected flow** — read entry points, key functions, or the public API around the reported behavior
3. **Check recent changes** in relevant files:
   ```
   git log --oneline -10 -- [file]
   ```
   Regressions often have a clear git trail.
4. **Note any tests** that cover the reported behavior — they encode what the author intended

Keep this phase lightweight. You are building a map to navigate by, not doing the full investigation yet.

---

### Phase 2: Investigate

Follow the code path from the trigger to the symptom — or to the point where the expected symptom *doesn't* appear.

**Reading strategy:**
- Start where the behavior is observed or reported
- Ask: "Where does this value come from?" and "Who calls this?"
- Trace upstream until you find the point where state diverges from expectation
- Do not stop at the first suspicious-looking code — that may be a symptom, not the cause

**Theory formation:**
For each theory, state:
- What is wrong (or suspected to be wrong) and where (`file:line`)
- The causal chain: how the trigger leads to the observed behavior
- What evidence would confirm or refute this theory

**Ruling out theories:**
Before forming a new theory, explicitly state why the previous one was ruled out. This prevents circular investigation.

**If the behavior does not reproduce:**
- Document what was tried and what conditions appear to be required
- Consider: does the bug exist only under specific state, config, or timing?
- Do not declare "not a bug" solely because it doesn't reproduce immediately

**Evidence gathering:**
- Check for relevant logs, error messages, or test output
- Use observability tools available in the project (Sentry, application logs, test output)
- Look for related issues in git history: `git log --oneline --all --grep="[keyword]"`

---

### Phase 3: Collaborate

Surface ambiguities to the user before drawing conclusions.

**When to ask:**
- Expected vs. actual behavior is still unclear after reading the code
- The code does exactly what it appears designed to do, but it's unclear if the design is correct
- Multiple valid interpretations of "correct" exist
- The investigation reveals something that *could* be intentional

**How to ask:**
Ask one specific question with context. Don't list all ambiguities at once.

> Example: "I can see `calculateTotal` skips negative items. Is that intentional, or do you expect them to be included?"

After the user responds, continue investigation with the new context.

**Do not ask about:**
- Things you can determine by reading the code
- Implementation details the user is unlikely to know
- Clarifications that don't materially change the investigation

---

### Phase 4: Verdict

Present findings with evidence. One of three outcomes:

#### Bug Confirmed

```
## Investigation Findings
**Verdict**: Bug confirmed
**Observed**: [What the code actually does]
**Expected**: [What it should do, per the user / spec / tests]
**Location**: [file:line — where the root cause lives]
**Causal chain**: [Step-by-step from trigger to symptom]
**Evidence**: [Code references, test output, git history, etc.]
**Confidence**: High / Medium / Low
```

#### Not a Bug

```
## Investigation Findings
**Verdict**: Not a bug — working as intended
**Behavior**: [What the code does and why it is correct]
**Evidence**: [Code references, tests, design decisions found]
**What may have caused the report**: [Misunderstanding, outdated docs, etc.]
**Confidence**: High / Medium / Low
```

#### Inconclusive

```
## Investigation Findings
**Verdict**: Inconclusive
**What was investigated**: [Files, paths, theories explored]
**What was ruled out**: [Theories tested and eliminated, with reason]
**Remaining unknowns**: [What would be needed to reach a verdict]
**Best hypothesis**: [Most likely explanation given current evidence]
**Confidence**: Low
```

---

### Next Steps

After presenting the verdict, offer options (use platform question tool, or present numbered options and wait):

**If bug confirmed:**
1. Fix it now — hand off to `ce-debug` Phase 3 (fix phase) or implement directly
2. Open an issue with the findings
3. Document and defer — capture the causal chain for later

**If not a bug:**
1. Update documentation to prevent future confusion
2. Add a test that encodes the intended behavior
3. Done

**If inconclusive:**
1. Gather more context — describe what specific information is needed
2. Add logging / observability to surface the behavior at runtime
3. Escalate — flag to a team member who may have more context on the original design

---

## Anti-Patterns

- **Fixing before confirming** — never change code before the verdict
- **Assuming the bug exists** — "I think this causes it" is a theory, not a finding
- **Asking too many questions up front** — investigate first, ask only when code doesn't answer
- **Declaring "not a bug" from a quick read** — absence of obvious problems ≠ correct behavior
- **Changing multiple files to "test"** — one change, one theory
