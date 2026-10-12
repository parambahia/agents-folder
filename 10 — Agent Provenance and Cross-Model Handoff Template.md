# Agent Provenance and Cross-Model Handoff

Projects may move between Claude Code, Codex, and other coding agents. The agentic
framework is the shared memory, so it records execution identity at the two places
future runtimes already read: session logs and specs.

## Identity Rules

Record five fields:

| Field | Meaning | Example |
|-------|---------|---------|
| Agent | Product/runtime identity | `Codex`, `Claude Code` |
| Provider | Model provider | `OpenAI`, `Anthropic` |
| Model | Exact identifier exposed by the runtime | `claude-opus-4-1`, `GPT-5` |
| Surface | Where it ran | `Codex desktop`, `Claude Code CLI`, `API` |
| Role | Responsibility in this work | `orchestrator`, `implementer`, `reviewer` |

Never infer an unexposed model or point release from the product name. Write:

```text
unknown (runtime did not expose model)
```

Do not retroactively attribute old work from writing style, commit authorship, or
memory. If a legacy spec is resumed and its author is unknown, add one baseline row
with `legacy / unknown`, then append known work normally.

## Session Log Header

Every new session entry begins with:

```markdown
## Session {YYYY-MM-DD HH:MM}

**Agent:** {Codex / Claude Code / …}
**Provider:** {OpenAI / Anthropic / …}
**Model:** {exact exposed identifier, or unknown (runtime did not expose model)}
**Surface:** {Codex desktop / Claude Code CLI / API / …}
**Role:** {orchestrator / implementer / reviewer / standalone}

**Objective:** {one sentence}
```

If multiple agents work on the same calendar day, give each its own headed entry
in the same daily file. Do not replace the earlier agent's identity.

## Spec Execution Ledger

Every worked spec contains:

```markdown
## Execution Ledger

| Date | Phase | Agent | Provider | Model | Surface | Role | Session / Handoff | Notes |
|------|-------|-------|----------|-------|---------|------|-------------------|-------|
| 2026-07-27 | authored | Codex | OpenAI | GPT-5 | Codex desktop | orchestrator | `.agents/sessions/2026-07-27.md` | Initial spec |
```

Allowed phases are descriptive, not restrictive: `authored`, `orchestrated`,
`implemented`, `reviewed`, `revised`, `merged`, `promoted`, and `verified`.
Append a row whenever the phase or responsible runtime changes.

## Handoff Gate

Before one runtime hands work to another, ensure:

1. The spec status and acceptance criteria reflect reality.
2. The Execution Ledger contains the outgoing runtime's latest phase.
3. Today's session log records completed work, tests, open findings, and next action.
4. Any worker/completion handoff identifies its own execution identity.
5. Architecture and backlog files reflect user decisions made during the session.
6. No hidden model version has been guessed.

The receiving runtime reads the project instructions, latest session entry, active
spec, and system map. It should not need the preceding chat transcript.

## Right-Sizing

- Spec work: session identity plus spec ledger are required.
- Inline work: session identity plus commit metadata are sufficient.
- Review: always add a distinct review ledger row, even when the same provider is
  used; independence is about context as well as model family.
- Cross-model milestone review remains recommended, but provenance is required
  whether or not a different model is available.
