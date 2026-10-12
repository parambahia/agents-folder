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
