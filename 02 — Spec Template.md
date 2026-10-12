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

## Technical Approach

{How should this be implemented? Which files are affected?
Only include if the approach matters — leave blank for obvious tasks.}

### Files to Change
- `path/to/file.py` — {what changes}
- `path/to/other.tsx` — {what changes}

### Dependencies
- {External libraries, APIs, data sources needed}

### Live Surfaces and Negative Knowledge
- Live surfaces touched: {system-map diagram / CONTEXT.md / tours / changelog — or "none"}
- NK entries in scope: {NK-n, … — or "none"}

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
