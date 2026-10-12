# dotagents

**The `.agents/` folder for AI-assisted software projects.** An overview and fourteen Markdown templates
that give a coding agent (Claude Code, Codex, or any other) the same thing a good engineer
has on day one: a resume point, written specs, a decisions ledger, runbooks, a review policy,
provenance for every session, and an ops layer that proves the deployed thing is alive.

No framework code. No lock-in. Copy the templates you need into `.agents/` and edit them.

## Why

Agent sessions forget. Projects drift. The expensive failures are not bad code; they are a
session that resumed from the wrong state, a "fix" nobody recorded as rejected, a deployed
surface that froze for three weeks while the watchdog said "a run happened". These templates
exist because each of those happened once and should not happen again.

## Start here

1. Read [00 — Framework Overview](./00%20%E2%80%94%20Framework%20Overview.md). It explains the
   right-sizing rule: standalone operation is the default; specs, orchestration, governance and
   the notes-vault sync are added only when the project benefits.
2. Create `.agents/` in your project. Copy in `STATE.md` (the single resume point) and a
   `CLAUDE.md` from template 01.
3. Add the rest as the project earns them.

## Templates

Numbers match the file names.

- 00 — Framework overview and right-sizing
- 01 — `CLAUDE.md` (the agent's standing instructions)
- 02 — Task specifications with an append-only execution ledger
- 03 — Prioritised backlog
- 04 — Architecture system map (living flow diagram, context maps)
- 05 — Testing strategy (tests encode failure modes)
- 06 — Decisions: ADRs, stakeholder decision register, negative-knowledge ledger
- 07 — Deployment, review and debugging runbooks
- 08 — Multi-session orchestration (orchestrator + workers in worktrees)
- 09 — Notes-vault synchronisation (Obsidian)
- 10 — Agent and model provenance; cross-model handoff
- 11 — Ops and liveness (data-freshness monitors, unattended-run rules)
- 12 — Cross-session orchestration protocol (multi-terminal, multi-machine)
- 13 — Portfolio and wake protocol (the board, framework sync, the morning loop)
- 14 — Client engagement protocol (paid work inside a client's business)

`proposals/` holds change proposals and their approval status. They are not templates.

## Principles the templates enforce

- **Live sources beat narrative docs.** A status claim comes from the running system.
- **Rejections are logged, never deleted.** The negative-knowledge ledger is read before a
  change and superseded, not edited.
- **The reviewer gets the artifact and the contract, never the author's claim.**
- **Every session records agent, provider, exact model, surface and role.** If the runtime hides
  the model, write `unknown`; never infer a point release.
- **A deployed surface without a data-freshness check is not deployed.**
- **Headless runs have a cost cap and a permission floor.**

## Changelog

### 2026-10-12
- First public release, as `dotagents`. Project-specific names and paths removed.

### 2026-10-06
- 01: session-start pickup, live sources beat narrative docs, live-surface currency,
  negative-knowledge ledger duties, end-of-session diff review, review fan-outs only at
  milestone gates, ops/orchestration/framework-sync section.
- 02: "Live Surfaces and Negative Knowledge" lines in every spec.
- 04: co-located `CONTEXT.md` maps. 05: tests encode failure modes; gates prove they looked.
- 06: decision register, ownership map, NK entry format, "Decided by" and override bounds.
- 07: cross-model gate verdicts. 08: fix loop, worker stays open, compact handoffs, "Read this
  first" briefs, ID ledger in STATE, check for an existing spec branch before re-assigning.
- 11: untrusted tool output, cheap caps, deny-rule floor, evidence pre-collection, skill trust
  tiers. 12: reviewer seat, explore-once evidence, send-log, `STATUS:` line, worktree lifecycle
  and ports, racing. 13: vendored templates stay pristine; adaptations live in working files.
- 14: new client engagement protocol. 00: governance files, `research/`, `evidence/`,
  `engagement/`, `send-log.jsonl`; `.agents/STATE.md` as the single resume point.

### 2026-09-01
- 04: living Mermaid flow diagram.

### 2026-08-21 to 2026-08-23
- 11 to 13 added; unattended-run resilience (11); decomposition ownership, shared research,
  frontier dispatch (12).

## Licence

MIT. See [LICENSE](./LICENSE).
