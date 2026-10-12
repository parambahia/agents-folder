# Multi-Session Orchestration Template

Optional. Add this when work is parallelizable across multiple terminals. The default
single-terminal "standalone" mode needs none of this — reach for it only when you're
genuinely running an orchestrator plus concurrent workers.

The model is hub-and-spoke: one **orchestrator** terminal manages work distribution while
**worker** terminals execute specs concurrently. Communication is via the filesystem
(`.agents/orchestrator/`). The human is the relay — they open terminals, paste handoff
paths, and relay completion notices.

---

## Session Role Detection (checked at the start of EVERY session)

1. **Did the user paste a handoff file path?** → **WORKER** session. Read the handoff, work
   on that spec only.
2. **Does `.agents/orchestrator/STATE.md` exist with active workers?** → likely **ORCHESTRATOR**
   resuming. Confirm with the user.
3. **Neither?** → **Standalone** session (default single-terminal mode).
4. **Ambiguous?** → ASK: "Are you the orchestrator, a worker, or working standalone?"
5. Record Agent / Provider / exact exposed Model / Surface / Role in today's session
   entry and in every assigned spec's Execution Ledger. If the model is hidden, record
   that explicitly instead of guessing.

## Orchestrator Protocol

The orchestrator does NOT write application code. It manages work distribution:
- Reads `BACKLOG.md` to identify parallelizable specs.
- Creates handoff files in `.agents/orchestrator/handoffs/SPEC-{NNN}-worker.md`.
- Maintains `.agents/orchestrator/STATE.md` (living document, updated after every event).
- Processes completion briefs when a worker pings, or when the user relays them.
- On a completion ping (cross-session message): read the named brief FILE and process it.
  The message is a doorbell. The brief file is the record. Never act on message text alone.
- **Fix loop** (a brief needs fixes: review findings, gate failures, failed checks):
  1. Do not fix the worker's branch yourself.
  2. Send the worker a numbered fix list via `SendMessage`. Set the spec to `IN_PROGRESS`.
  3. Repeat until the brief is clean. Then reply "SPEC-{NNN} accepted" and merge.
  4. If the worker session is gone, write the fix list into the handoff file. Ask the user
     to reopen a worker.
- Before re-assigning a spec, run `git branch` and check for an existing spec branch.
- Manages git merges (workers commit to spec branches; orchestrator merges).
- Updates `BACKLOG.md` and `STATE.md` after merges.

## Worker Protocol

Workers are autonomous executors scoped to a single spec:
- Read the handoff file (the ONLY context beyond CLAUDE.md).
- Create a spec branch: `git checkout -b spec/{NNN}-{short-title}`.
- Implement per the handoff; run tests + mandatory adversarial code review.
- Write a completion brief to `.agents/orchestrator/handoffs/SPEC-{NNN}-completion.md`.
- Commit to the spec branch (NEVER merge to main).
- Ping the orchestrator (needs Claude Code ≥ 2.1.224): run `ListAgents`, find the
  orchestrator session, then `SendMessage`: "SPEC-{NNN} complete. Brief at `[path]`."
  Send the path only — never findings, data, or secrets. The message augments the brief;
  it never replaces it.
- Tell the user: "Done. Completion brief at `[path]`." If no orchestrator session is
  found, add: "Paste into orchestrator session." (human relay = the fallback).
- Stay open after the ping. On a fix list, apply the fixes. Re-test and re-review the delta.
  Update the SAME brief file, then re-ping. The spec is finished only on "SPEC-{NNN} accepted".

**A worker NEVER:** merges to main · modifies files outside its handoff scope · touches other
handoff files · updates BACKLOG.md or STATE.md.

## Handoff Document Format

**Main → Worker** (`SPEC-{NNN}-worker.md`):
- Orchestrator execution identity (agent, provider, model, surface, role)
- Context snapshot (2-3 paragraphs of relevant system context)
- Key files to modify (paths + what to change)
- Recent related changes
- Numbered implementation steps
- Acceptance criteria (from the spec)
- Constraints (what NOT to touch), including files that live sibling workers own
- Live-surface impact (template 01) and the NEGATIVE-KNOWLEDGE entries in scope
- Decisions that are NOT the worker's (for example "the flag flip is not yours")
- "When Done" checklist (tests, code review, write completion brief, commit to branch,
  ping, stay open for the fix loop)

Keep the handoff compact: name files as pointers; do not restate their content.

**Worker → Main** (`SPEC-{NNN}-completion.md`):
- First line, exactly: `STATUS: done | blocked | aborted-too-big`
- Worker execution identity (agent, provider, model, surface, role)
- Branch, commits and merge posture (for example "NOT merged; feature flag stays off")
- "Read this first": findings the orchestrator must act on, including out-of-scope ones
- What was done (3-5 bullets)
- Files changed (table: path · change type · description)
- Test results (pass/fail counts)
- Code review summary (severity counts, unresolved items)
- Acceptance criteria status (checkboxes)
- Cross-cutting impacts the orchestrator needs to know
- Merge notes (expected conflicts, post-merge actions)

## Orchestrator State (`.agents/orchestrator/STATE.md`)

A living document containing:
- **Orchestrator Identity** (agent, provider, model, surface, session start)
- **Active Workers** table (spec, branch, status, handoff link)
- **Merge Queue** (ordered list of specs ready to merge)
- **Blocked Items** (spec, what it's blocked on)
- **Recent Completions** (last 5 merged specs)
- **Current Sprint Goal** (1-2 sentences)
- **Decisions Pending** (needs user input)
- **ID Ledger** (reserved and next-free numbers for NK / gap / decision entries)
- **Context Carry-Forward** (max ~10 bullets — ruthlessly compact, delete stale items)

Delete closed sections from STATE at every update. Session logs and git keep the history.

Status values: `ASSIGNED` → `IN_PROGRESS` → `COMPLETION_RECEIVED` → `MERGED` (or `BLOCKED`).

## Environment / Branch Discipline (optional, for staging→prod flows)

When you run a staging environment, target all new feature work at a `staging` branch that
auto-deploys to a staging service with its own database; keep prod frozen except critical
fixes until a reviewed promotion (the cross-model review is the promotion gate). Workers
branch FROM staging; the orchestrator merges spec branches → staging. Maintain a single
staging↔main source-of-truth ledger (divergence table, design decisions, promotion runbook)
and append to it as part of processing every completion brief — a merge not recorded there
didn't happen. Any prod hotfix during a freeze merges back into staging the same day.
