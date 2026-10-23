# Runbook Templates

Reusable procedures the agent follows for common operations.

---

## Deploy Runbook

```markdown
# DEPLOY

## Pre-Deploy Checklist
- [ ] All specs in current sprint are status: done
- [ ] Full test suite passes
- [ ] No P0 or P1 specs in BACKLOG are blocked by this deploy
- [ ] SYSTEM-MAP.md is current
- [ ] Environment variables are set in target environment

## Deploy Steps
1. {Step 1}
2. {Step 2}
3. {Step 3}

## Post-Deploy Verification
- [ ] {Health check endpoint returns 200}
- [ ] {Core user flow works end-to-end}
- [ ] {Monitoring shows no error spike}

## Rollback
If any post-deploy check fails:
1. {Rollback step 1}
2. {Rollback step 2}
3. Create P0 spec for the failure
```

---

## Review Runbook

```markdown
# REVIEW

## Code Review Process

### Before Review
- [ ] Read the spec this change implements
- [ ] Understand the acceptance criteria
- [ ] Record reviewer Agent / Provider / Model / Surface / Role in the spec Execution Ledger
- [ ] Give the reviewer the diff and the acceptance criteria, never the author's claims

### During Review
- [ ] Changes trace directly to the spec: no unrequested feature, option or fallback
- [ ] No test is deleted, skipped, weakened or marked expected-fail without a reason in the spec
- [ ] Each commit is structure only or behaviour only (template 01, Surgical Changes)
- [ ] No new shallow module: an interface almost as complex as the code behind it
- [ ] Tests cover the acceptance criteria
- [ ] No security vulnerabilities introduced
- [ ] No hardcoded secrets
- [ ] Existing patterns are followed
- [ ] No unnecessary complexity

### After Review
- [ ] Run Codex review in read-only sandbox mode
- [ ] Compare Claude and Codex findings
- [ ] Present disagreements to user for decision
- [ ] Address all legitimate findings
- [ ] Record each WONTFIX or disagreed finding in NEGATIVE-KNOWLEDGE.md (same commit)

### Cross-Model Gate (milestones and promotions)
1. Write the verdict to `.agents/orchestrator/CODEX-GATE-{YYYY-MM-DD}-{PASS|FAIL}.md`.
2. Use one verdict: `PROMOTE` · `PROMOTE WITH FIXES` · `DO NOT PROMOTE`.
3. On a fix verdict, send the findings to a worker as a numbered fix list (template 08).
4. Re-run the gate on the fix delta. Promote only on a satisfied gate.
5. The promotion is the user's call. The gate informs it; it does not make it.
6. Count findings raised, fixed and WONTFIX per reviewer. Write the counts in the Completion Log. Compute the fix rate: fixed divided by raised.
7. Put the stable part of the review prompt first (acceptance criteria, repo rules, diff) and any focus text last, so repeated passes share a cached prefix.
8. Ask the reviewer to rate a finding critical or warning only when it can name the input that triggers it. Mark any other finding UNVERIFIED.

### Lens Review (optional, milestone gates only)
1. Use at most 3 lenses. Each lens is one expert card: `.agents/review-cards/<name>.md`, at most 40 lines.
2. A card has: who and sources (URLs, date read); 5 principles in your own words; 5 checkable "flag if" items; one line, "Out of scope for this lens".
3. Build a card only from material you opened. Mark a point from memory as RECALLED. Do not use a card with more than 2 RECALLED points.
4. Send every lens the same contract and diff first. Put the card last.
5. Each lens returns findings as file:line plus the "flag if" item it matched. Reject any finding without both.
6. Count findings raised and fixed per lens (Cross-Model Gate, step 6). Drop a lens with a fix rate under 20% after three milestones.

### Completion
- [ ] Review outcome logged in spec's Completion Log
- [ ] Implementation and review provenance rows are complete; no model identity was guessed
- [ ] Spec moved to DONE.md
```

---

## Debug Runbook

```markdown
# DEBUG

## When Something Breaks

1. **Identify** — What exactly is broken? What's the user-visible symptom?
2. **Reproduce** — Can you trigger it consistently? Write a test that fails.
3. **Isolate** — Is it data, code, config, or infrastructure?
4. **Fix** — Minimum change that resolves the issue.
5. **Verify** — Failing test now passes. No regressions.
6. **Document** — Create spec with root cause + fix for audit trail.

## Agentic Debugging (the code is not known)

Use this section when an agent debugs code that nobody has read in full. Source: Sridharan,
"How to effectively debug when you no longer understand the code" (Oct 2026); adapted 13 Oct 2026.

Warning: do not read the code first. Code shows what can happen. It does not show what did happen.
Warning: do not change a fact. If a fact looks wrong, collect it again.

1. Collect facts: bug report, logs, telemetry, config. Collect from many instances of the bug.
2. Pick a control: a working run, or a run that fails in a different way.
3. Check that the control does not have the same bug. If it does, pick a new control.
4. Mark each fact. A fact only in the failing run is a signal. A fact in both runs is noise.
5. Write a matrix: hypotheses in rows, signals in columns. Count the hypotheses that fit each signal.
6. One fit is a strong signal. Many fits is a weak signal. SLOs and averages are weak.
7. Test only the hypothesis that the strong signal supports. A reproduction is a hypothesis.
8. Check the hypothesis against every fact, noise included. One contradicting fact removes it.
9. If no hypothesis fits all facts, do these steps in order. Rebuild the matrix after each step.
   a. Collect the facts again. Check host, time window and tool version.
   b. Split a hypothesis that is too coarse.
   c. Merge hypotheses that are too fine.
   d. Combine two hypotheses that each fit part of the facts.
   e. Write a new hypothesis from the existing facts only.
10. If every signal is weak, collect facts one layer down: logs, then traces, then process state.
    Stop at the first strong signal.
11. State a root cause only when exactly one hypothesis fits every fact. Cite the fact for each claim.
12. Start a fresh reviewer after steps 4, 7 and 11. Use a different model family if you can.
    The reviewer finds noise in the signals, a weak signal, a skipped step 9, and one fact the root
    cause fails.
13. Warning: a reviewer cannot find a fact that is missing. Add the missing source to the logs.
14. Write the number of human interventions in the session log. Each one is a gap in the runbook or
    the logs.

## Changing Code Nobody Has Read

Sources: Feathers, *Working Effectively with Legacy Code* (2004); Willison, *Agentic Engineering Patterns* (2026).

Warning: do not edit untested code before you pin its current behaviour.

1. Ask the agent for a linear walkthrough of the code path. Read it before you plan the change.
2. Find a seam: a point where you can test or replace behaviour without editing the code there.
3. Write characterisation tests at the seam. They assert what the code does now, not what it should do.
4. Commit the tests alone. Make the change in a separate commit.
5. When a characterisation test fails, decide: bug fixed (update the test) or regression (fix the code).
6. Record that decision in the commit message.

## Common Patterns
- Data stale? → Check pipeline schedule + last run log
- API returning errors? → Check health endpoint, then logs
- Frontend showing wrong data? → Check API response first, then component
- Pipeline silently failing? → Check error handling in orchestrator
```
