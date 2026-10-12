# Agentic Project Framework

A structured markdown system for AI-assisted software development. Claude Code (or any LLM agent) reads these files as context and executes against them systematically.

## Principles

Based on Karpathy's guidelines + agentic architecture patterns:

1. **Every task has a spec before code is written** — No ambiguous instructions
2. **Every spec has acceptance criteria** — "Done" is defined upfront
3. **Every change is tested before merge** — Automated validation
4. **Agents read specs, not conversations** — Context is structured, not conversational
5. **Simplicity first** — Minimum code that solves the problem, nothing speculative
6. **Execution provenance is explicit** — Every session and spec records which agent,
   provider, model, surface, and role performed each phase

## How It Works

```
Agent reads spec file → Plans approach → Implements → Tests → Marks complete
```

Each spec file is a self-contained contract. The agent doesn't need conversation history — the file contains everything needed to execute.

## Directory Structure

```
project-root/
├── CLAUDE.md                    # Agent behavior rules (loaded every session)
├── .agents/                     # Agentic framework (this system)
│   ├── framework/               # Vendored copy of these templates (pristine; re-sync on wake)
│   ├── STATE.md                 # Resume point for a single-session project (read first on wake)
│   ├── BACKLOG.md               # All pending work, prioritised
│   ├── ACTIVE.md                # Currently in-progress specs
│   ├── DONE.md                  # Completed specs (audit trail)
│   ├── specs/                   # Individual task specifications
│   │   ├── SPEC-001-title.md
│   │   ├── SPEC-002-title.md
│   │   └── ...
│   ├── sessions/                # Daily session logs (persistent cross-session memory)
│   │   └── YYYY-MM-DD.md
│   ├── orchestrator/            # Multi-session hub (only if running parallel workers)
│   │   ├── STATE.md             # Living orchestration state
│   │   ├── send-log.jsonl       # One line per cross-session send (template 12)
│   │   └── handoffs/            # Main↔worker handoff + completion briefs
│   ├── testing/                 # Test plans and validation
│   │   ├── TEST-PLAN.md
│   │   └── test-results/
│   ├── architecture/            # System architecture decisions
│   │   ├── DECISIONS.md         # ADRs (Architecture Decision Records)
│   │   └── SYSTEM-MAP.md        # Current system state
│   ├── governance/
│   │   ├── NEGATIVE-KNOWLEDGE.md   # What was rejected or ruled out, and why
│   │   ├── GAP-REGISTER.md         # Only if an external policy authority exists
│   │   └── DECISION-REGISTER.md    # Only if stakeholders own decisions
│   ├── research/                # Shared exploration notes (template 12)
│   ├── forge/                   # Idea → kickoff trails: verbatim dumps + RESUME-HERE.md
│   ├── engagement/              # Client engagement file (template 14)
│   ├── evidence/                # Frozen baselines, gate evidence, return reports
│   ├── skills/                  # Vendored load-on-demand reference docs (not always-on)
│   └── runbooks/                # Reusable procedures
│       ├── DEPLOY.md
│       ├── DEBUG.md
│       └── REVIEW.md
├── src/                         # Source code
├── tests/                       # Test code
└── docs/                        # User-facing documentation
```

## Operating Model

- **Standalone** (default): one terminal, works exactly as the workflow below describes.
- **Multi-session** (optional): one orchestrator distributes work to concurrent worker
  terminals via `.agents/orchestrator/`. See the Orchestration Template. Use only when work
  is genuinely parallelizable.
- **Right-sizing:** the framework is not ceremony. Small, low-risk fixes (≤ ~30 lines, single
  concern) are done inline and noted in the session log — no spec required. Specs are for
  multi-file, parallelizable, or audit-trail work.
- **Sessions are disposable; the framework is the memory.** Session logs, STATE.md, and
  handoffs carry continuity — not a long-lived mega-context terminal.
- **Notes vault mirror (optional):** `.agents/` syncs into a local Obsidian vault (created on
  first run) so the project is readable/annotatable from Obsidian as it grows. See the Obsidian
  Vault Sync Template.

## File Naming Convention

- Specs: `SPEC-{NNN}-{kebab-case-title}.md`
- Tests: `TEST-{NNN}-{kebab-case-title}.md`
- Architecture: `ADR-{NNN}-{kebab-case-title}.md`
- All caps for framework files, kebab-case for titles

## Agent Workflow

1. Agent reads `BACKLOG.md` to find next priority task
2. Agent reads the linked spec file for full requirements
3. Agent reads `SYSTEM-MAP.md` for current architecture context
4. Agent implements against the spec's acceptance criteria
5. Agent runs tests defined in the spec
6. Agent moves spec from `ACTIVE.md` to `DONE.md`
7. Agent updates `SYSTEM-MAP.md` if architecture changed

## Agent / Model Provenance

Claude Code, Codex, and other coding agents may hand a project between one another.
The filesystem must therefore remember not only *what* happened, but *which runtime
performed each phase*:

- Every session log records `Agent`, `Provider`, `Model`, `Surface`, and `Role`.
- Every worked spec carries an append-only Execution Ledger for authorship,
  orchestration, implementation, review, and merge/promotion.
- Use the exact model identifier exposed by the runtime. If it is not exposed, write
  `unknown (runtime did not expose model)`; never infer a point release from the
  product name.
- Historical work is not guessed or rewritten. Mark it `legacy / unknown` only when
  a resumed spec needs an explicit baseline.

See `10 — Agent Provenance and Cross-Model Handoff Template.md` for the canonical
schema and handoff rules.

## Governance

- Specs are never deleted, only moved to DONE
- Every spec has a unique ID that never gets reused
- Changes to CLAUDE.md require explicit approval
- Architecture decisions are logged in DECISIONS.md with rationale
- Rejections are logged in NEGATIVE-KNOWLEDGE.md with reasons (template 06)
- Status claims come from the live system; docs are dated snapshots (template 01)
