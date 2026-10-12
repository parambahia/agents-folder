# System Map Template

Copy this to `.agents/architecture/SYSTEM-MAP.md`. Keep it updated as architecture evolves.

---

```markdown
# System Map

Current state of the system architecture. Updated whenever significant changes are made.

**Last updated:** {YYYY-MM-DD}

## System Overview

{One paragraph describing the system at a high level.}

## Architecture Diagram

```
{ASCII diagram of major components and data flow}

[Frontend] → [API Layer] → [Business Logic] → [Database]
                 ↓
           [External APIs]
```

## Component Registry

| Component | Location | Purpose | Owner |
|-----------|----------|---------|-------|
| {name} | `path/to/dir` | {what it does} | {who maintains} |

## Data Flow

{How data moves through the system. Source → Processing → Storage → Display.}

## Key Tables / Models

| Table/Model | Purpose | Updated By |
|-------------|---------|------------|
| {name} | {what it stores} | {pipeline/API/manual} |

## External Dependencies

| Service | Purpose | Auth Method | Rate Limits |
|---------|---------|-------------|-------------|
| {name} | {what we use it for} | {API key/OAuth/etc} | {limits} |

## Scheduled Jobs

| Schedule | Job | What It Does |
|----------|-----|-------------|
| {cron} | {name} | {description} |

## Environment Variables

| Variable | Purpose | Required |
|----------|---------|----------|
| {name} | {what it controls} | Yes/No |

## Known Constraints

- {Constraint 1}
- {Constraint 2}

## Technical Debt

| Item | Impact | Effort | Spec |
|------|--------|--------|------|
| {description} | {H/M/L} | {H/M/L} | {linked spec if exists} |
```

## Living flow diagram (added 01 Sep 2026)

Beside the component inventory, the system map carries a Mermaid flow diagram
of every backend process end to end — sources → transforms → stores →
consumers, with failure paths marked. Rules:

- **It updates in the same session as the change.** A merged change to any
  mapped flow updates the diagram before the session closes — same ritual as
  updating docs at milestone close. A diagram that lags reality is worse than
  none.
- Keep it at process altitude (what calls what, what writes where), not code
  altitude. One diagram per major flow; link, don't merge, when it grows.
- Purpose: the middle ground between reading every generated line and flying
  blind — and the fastest onboarding surface for a collaborator or a fresh
  session. Use `/show-me`-style structural diffs when explaining a change to
  the flow.

## Co-located context maps (optional, added 06 Oct 2026)

A large subsystem can carry its own `CONTEXT.md` beside the code. It holds the
invariants, hazards and security boundary a worker must know before editing.

- Stamp each map with `verified_at` and `verified_sha`.
- A spec that changes a mapped subsystem updates its map in the same spec
  (template 01, Live-Surface Currency). The handoff names the map.
- Delete a map that nobody keeps current. A stale map misleads.
