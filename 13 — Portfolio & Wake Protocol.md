# 13 — Portfolio & Wake Protocol

The cross-project state layer. One board rules the portfolio:
`PORTFOLIO.md` at the root of your projects folder (managed by a `/portfolio` skill or by hand). The board
is a registry with pointers — per-project truth stays in each repo's
`.agents/STATE.md`. State is aggregated at read time across machines; it is
never synced between them.

## Board rules

- Every parked project has a **wake condition** (a date, an event, or an
  explicit "pick-up"). No condition = candidate for kill.
- Every deployed surface has a **liveness row** (template 11).
- **Blocked-on-owner items are the briefing payload** — precise and actionable
  ("set ANTHROPIC_API_KEY in <project>/.env", never "needs attention").
- Kill is a verdict, recorded in the Killed section. Park is not kill.
- Start discipline: a new project enters the board in the SAME session that
  creates it, with an explicit first verdict date. Cheap starts must not
  become silent open loops.

## Wake protocol (run at the start of any session picking up a parked project)

1. Read the board row (location, why parked, what changed since).
2. Read the repo's `.agents/STATE.md` / session logs — resume point, gotchas.
3. **Sync the vendored framework**: diff `.agents/framework/` against the
   master (your clone of this repo, or its GitHub remote from a
   box) and copy in new/updated templates. Projects sleep; the framework
   doesn't. This is how parked projects receive framework evolution without
   mass rollouts — they update on wake, when it matters.
   Keep the vendored templates pristine. Put project adaptations in the
   working files (CLAUDE.md, `.agents/*`) or in one `FRAMEWORK-ADAPTATION.md`.
4. Check the Liveness table for the project's surfaces — if a check is FAILing,
   that outranks the planned work.
5. Work. On close: update the board row (`/portfolio` session-close rules).

## Machine placement

The board records WHERE each project lives (laptop, home server, cloud
VPS, external drive). Rules:

- A project that runs continuously lives on an always-on box (home server or VPS), with
  its mac repo as the development origin and git as the sync channel — never
  scp of source trees.
- External-drive projects (T7) note the mount requirement in their row.
- Agent scripts and ops tooling never live on removable drives (F:/T7) — a
  dropped drive must not take the tooling that would report the drop.

## Morning loop (the steady state)

1. Overnight chat digests (Telegram or similar): Tier 0 alerts as they happened; Tier 1 nightly
   briefings, exceptions first.
2. `/portfolio` in a mac session when something needs action: liveness sweep,
   briefing headlines from all boxes, due wake-conditions, blocked-on-owner —
   decisions first.
3. The user's contribution is verdicts. Everything routine belongs to the
   machinery; if the user is doing something twice a week by hand, that is a
   backlog item for automation.
