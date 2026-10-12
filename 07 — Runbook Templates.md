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
- [ ] Changes trace directly to the spec (no scope creep)
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

## Common Patterns
- Data stale? → Check pipeline schedule + last run log
- API returning errors? → Check health endpoint, then logs
- Frontend showing wrong data? → Check API response first, then component
- Pipeline silently failing? → Check error handling in orchestrator
```
