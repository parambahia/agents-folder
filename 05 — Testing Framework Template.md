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
- For a unit in isolation: list the failure modes first. Then write one failing test per mode before its code.
- A bug fix gets a regression test only when it closes a real behaviour gap.
- Keep integration tests that encode failure modes. E2E does not replace them.

## Gates Prove They Looked

- Branch on exit codes, never on grepped output. `cmd | tail` hides a failing exit code.
- Assert a non-zero collected or scanned count. "No tests ran" exits 0 and looks green.
- Prefer an executed predicate over a source grep.

## Architecture Fitness Functions

A fitness function is a script that checks one architecture rule. It exits non-zero when the rule breaks.
Source: Ford, Parsons, Kua, Sadalage, *Building Evolutionary Architectures*, 2nd ed. (2022).

1. Write a fitness function for each architecture rule that a script can check.
2. Name the rule it guards (ADR, NK entry or CLAUDE.md law) in its first comment line.
3. Run build-time fitness functions in the pre-commit or CI gate.
4. Treat Tier 0 checks (template 11) as the runtime fitness functions.
5. Keep each function fast and deterministic. Fix or delete a flaky one within one week.
6. A rule that no script can check stays prose. Mark it "review-only" in its ADR.

Examples:
- Dependency direction: policy modules never import adapters, the UI or the web framework.
- Honesty law: every endpoint that returns a figure also returns its provenance fields.
- Single writer: no script outside the service opens the production database file.

## UI Copy Discipline

- Ask first: should this string exist? Do not polish copy that should be cut.
- Cut a caption that repeats its label, field or value.
- Cut copy that rules out a failure the user never saw ("never loses your files"). Fix the bug; do not describe the fix.
- If a screen needs a caption to make sense, change the layout, not the caption.
- Never cut an input's visible label or an error message. Both are required for accessibility.
- Keep: a consequence before a destructive action, a scope fact the user cannot see, an empty-state next step, units on a bare value.
- Never write "does X — never Y" lines or self-praise in labels.
- Review in context (label, value, button). List each cut as file:line in the completion note beside "Placeholders".

## Pre-launch Synthetic Users

- Before launch, run 5 persona agents in a real browser from landing page to first success: impatient, skeptic, 375 px on slow 3G, non-native reader, breaker.
- Each agent saves a screenshot at every stall and one line on why it stalled.
- Run a 3-account attack pass (A, B, admin) on the same build: each account tries to read, change or delete the others' data, and every attack is a saved script.
- Prove each protection can fail: show the attack succeeding with the control switched off, then failing with it on.
- Rank findings by how many agents hit them. Security findings rank first.
- Fix through normal specs. Then run the same agents and scripts again; save both runs as evidence.
- Use a staging branch and test accounts only. Never run against production data.

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
- [ ] Rebuild check: recompute one derived table from its sources and compare it with the stored copy

## Agent Testing Workflow

When an agent works a spec:
1. Before you change code, run the full suite. Record pass, fail and skip counts as the baseline.
2. For a behaviour change, list its failure modes. Write the test for the next mode. See it fail for the expected reason.
3. Implement. Run the spec-defined tests.
4. Run the full suite. Compare the counts with the baseline. A new skip or a lower collected count is a failure.
5. Log results in the spec's Completion Log.
6. If tests fail, fix them before you mark the spec done. Never skip a failing test.
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
