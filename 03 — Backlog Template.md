# Backlog Template

Copy this to `.agents/BACKLOG.md` in your project.

---

```markdown
# Backlog

Prioritised list of all pending work. Agent reads this to determine next task.

## Priority Legend
- **P0 — Critical:** Blocking production or pilot. Do immediately.
- **P1 — High:** Required for next milestone. Do this sprint.
- **P2 — Medium:** Important but not urgent. Schedule soon.
- **P3 — Low:** Nice to have. Do when capacity allows.

---

## P0 — Critical

| Spec | Title | Blocked By | Notes |
|------|-------|------------|-------|
| [[SPEC-001]] | {title} | — | {context} |

## P1 — High

| Spec | Title | Blocked By | Notes |
|------|-------|------------|-------|
| [[SPEC-002]] | {title} | SPEC-001 | {context} |

## P2 — Medium

| Spec | Title | Blocked By | Notes |
|------|-------|------------|-------|

## P3 — Low

| Spec | Title | Blocked By | Notes |
|------|-------|------------|-------|

---

## Recently Completed (last 5)

| Spec | Title | Completed | Review |
|------|-------|-----------|--------|

> Move completed specs to [[DONE]] after verification.
```
