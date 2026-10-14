# Testing Framework Template

Copy this to `.agents/testing/TEST-PLAN.md`. Defines the testing strategy.

---

```markdown
# Test Plan

## Testing Strategy

Every spec must define its own test criteria. This document defines the
overall testing approach and standards.

## Test Levels

### 1. Unit Tests
- **Scope:** Individual functions/methods
- **Runner:** {pytest / jest / etc}
- **Location:** `tests/unit/`
- **Naming:** `test_{module}_{function}_{scenario}.py`
- **Coverage target:** {percentage} of business logic

### 2. Integration Tests
- **Scope:** API endpoints, database queries, service interactions
- **Runner:** {pytest + httpx / supertest / etc}
- **Location:** `tests/integration/`
- **Naming:** `test_{endpoint}_{scenario}.py`

### 3. End-to-End Tests (if applicable)
- **Scope:** Full user workflows via headless browser
- **Runner:** {Playwright / Cypress / etc}
- **Location:** `tests/e2e/`

### 4. Validation Tests
- **Scope:** Data quality, pipeline output correctness
- **Runner:** Custom scripts
- **Location:** `tests/validation/`

## Tests Encode Failure Modes, Not Code

- Every test names the defect it catches. Delete a test that cannot name one.
- Delete tautological and change-detector tests. They block change and catch nothing.
- For a unit in isolation: write the failure modes first, then the code, then one test per mode.
- A bug fix gets a regression test only when it closes a real behaviour gap.
- Keep integration tests that encode failure modes. E2E does not replace them.

## Gates Prove They Looked

- Branch on exit codes, never on grepped output. `cmd | tail` hides a failing exit code.
- Assert a non-zero collected or scanned count. "No tests ran" exits 0 and looks green.
- Prefer an executed predicate over a source grep.

## Pre-Commit Checks

Before any code is committed:
- [ ] All existing tests pass
- [ ] New tests written for new functionality
- [ ] No regressions in adjacent functionality
- [ ] Linting passes

## Test Data

- **Fixtures:** `tests/fixtures/`
- **Factory pattern:** Use factories for test data, not hardcoded values
- **Database:** Use isolated test database or in-memory equivalent

## Continuous Validation

For data pipelines and ML systems:
- [ ] Output schema validation (columns, types, ranges)
- [ ] Row count sanity checks
- [ ] Metric boundary checks (WAPE < 1.0, bias within ±100%)
- [ ] Freshness checks (data not stale)

## Agent Testing Workflow

When an agent completes a spec:
1. Run spec-defined tests
2. Run full test suite to check for regressions
3. Log results in spec's Completion Log
4. If tests fail, fix before marking done — never skip
```

## Measured optimisation loop (goal-loop)

Use this section when an agent must move ONE number (page load, build time, test time, cost per run)
by trying changes on its own. Source: a Claude Code `/goal` pattern seen in an intake review,
adapted 14 Oct 2026 to the caps in template 11.

WARNING: Run this loop only in a git worktree on a new branch.
WARNING: Do not run it on main. Do not give it deploy rights.

Before you start:
1. Write the goal as ONE number and ONE command. Example: median mobile LCP <= 2000 ms.
2. Write the measure script `measure.sh`. It prints one number.
3. Set the budget: `--max-budget-usd 5` and `timeout 2h`. Set a turn clause in the goal text.
4. Set `--allowedTools` to Read, Grep, Glob, Edit/Write in the worktree, and the measure script.
5. Deny: `git push`, `git merge`, deploy commands, `rm -rf`, secret files, and Edit/Write outside
   the worktree.
6. Prove one deny rule works before the run. Record the proof.

Each cycle:
1. Change ONE thing.
2. Run `measure.sh` three times. Record the median.
3. If the median beats the best by 5% or more AND the guard checks pass, commit. Else revert.
4. Add one line to `.progress/log.csv`: turn, change, median, kept or reverted.
5. Rewrite `.progress/chart.html` from the log.

Guard checks (a script, not the model, runs them): build passes, tests pass, route list unchanged.

Kill rule: stop when the goal is met, when 50 turns pass, when the budget cap hits, or when 8 cycles
in a row are reverted. A cap hit is BLOCKED, not FAILED.

Human gate: the loop never merges. A human reads `log.csv`, `chart.html` and `git diff main`,
runs the measure script once, then merges. Then remove the worktree (worktree hygiene sweep).
