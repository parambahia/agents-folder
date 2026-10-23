# Spec Template

Copy this for each new task. Replace placeholders.

---

```markdown
# SPEC-{NNN}: {Title}

**Status:** pending | active | blocked | done
**Priority:** P0 (critical) | P1 (high) | P2 (medium) | P3 (low)
**Created:** {YYYY-MM-DD}
**Owner:** {who is responsible}
**Blocks:** {SPEC IDs this blocks}
**Blocked by:** {SPEC IDs blocking this}

## Execution Ledger

Append one row whenever responsibility or phase changes. Never overwrite or guess
historical identity. `Model` is the exact identifier exposed by the runtime; use
`unknown (runtime did not expose model)` when unavailable.

| Date | Phase | Agent | Provider | Model | Surface | Role | Session / Handoff | Notes |
|------|-------|-------|----------|-------|---------|------|-------------------|-------|
| {YYYY-MM-DD} | authored | {Claude Code / Codex / …} | {Anthropic / OpenAI / …} | {exact model or unknown} | {CLI / desktop / API / …} | orchestrator | {session log or handoff path} | {scope} |

## Context

{Why does this need to happen? What problem does it solve? Link to any
external requirements (emails, governance docs, user feedback).}

## Requirements

{What exactly needs to be built or changed. Be specific and unambiguous.}

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Acceptance Criteria

{How do we know this is done? These should be testable.}

- [ ] AC1: {Specific, verifiable condition}
- [ ] AC2: {Specific, verifiable condition}
- [ ] AC3: {Specific, verifiable condition}

**Pre-launch rewrite licence (optional):** YES / NO
If YES, all four must hold, and the spec lists each as a fact:
- No real user and no real user data exist. Any rows present are labelled synthetic.
- Every derived table can be rebuilt from its sources (template 05 rebuild check).
- Input validation, error states and provenance fields stay. Only handling for old states is dropped.
- Tests for the acceptance criteria stay green after the rewrite.
The licence ends at the first real user or real row. Record the end date in STATE.md. After that, every schema change needs a migration.

**UI prototype:** for a spec that adds a screen, attach an approved static prototype (HTML or Claude Design) before code starts. The prototype is throwaway and is never merged.

## Altitude

- **Outcome served:** {the goal beyond this spec, as a verb phrase}
- **Expert gap:** {what a top professional would do here that the requirements omit — adopted, deferred, or rejected with reason}
- **External proof:** {an artefact outside the author and the reviewer: test, live metric, backtest, parallel run, third-party check}
- "None found" is a valid answer. A blank on a P0/P1 spec is not.

## Technical Approach

{How should this be implemented? Which files are affected?
Only include if the approach matters — leave blank for obvious tasks.}

**Alternative design:** {one other approach and why it lost — required for multi-file specs. If the choice is hard to reverse, write an ADR (template 06).}

### Files to Change
- `path/to/file.py` — {what changes}
- `path/to/other.tsx` — {what changes}

### Dependencies
- {External libraries, APIs, data sources needed}

### Live Surfaces and Negative Knowledge
- Live surfaces touched: {system-map diagram / CONTEXT.md / tours / changelog — or "none"}
- NK entries in scope: {NK-n, … — or "none"}
- Readiness rows touched: {row names — or "none" — or "no ledger"} (template 11, Production readiness ledger)

## Test Plan

{How to verify the acceptance criteria are met.}

- [ ] Unit test: {description}
- [ ] Integration test: {description}
- [ ] Manual verification: {description}

## Notes

{Anything else relevant — edge cases, risks, open questions.}

## Completion Log

{Filled in when done.}

- **Completed:** {YYYY-MM-DD}
- **Actual approach:** {Brief summary of what was actually done}
- **Tests passed:** {Yes/No + details}
- **Review:** {Codex/peer review outcome}
- **Final provenance check:** {Execution Ledger complete and consistent with session/handoff}
```
