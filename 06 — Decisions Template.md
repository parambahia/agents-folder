# Architecture Decision Records (ADR) Template

Copy this to `.agents/architecture/DECISIONS.md`. Log every significant decision.

---

```markdown
# Architecture Decisions

Append-only log. Never delete entries.

---

## ADR-001: {Decision Title}

**Date:** {YYYY-MM-DD}
**Decided by:** {person, and where it is in writing}
**Status:** accepted | superseded by ADR-{NNN} | deprecated
**Checked by:** {fitness function path, Tier 0 check, or "review-only"}
**Context:** {What situation prompted this decision?}
**Decision:** {What was decided and why?}
**Alternatives considered:**
- {Option A} — rejected because {reason}
- {Option B} — rejected because {reason}
**Consequences:**
- {Positive consequence}
- {Negative consequence / tradeoff}

---

## ADR-002: {Next Decision}

...
```

An ADR that overrides a standing project rule names the rule, the scope of the
exception and its bounds. Every other rule stands.

Write an ADR when a decision meets one of these tests:
- It is expensive to reverse: data model, storage engine, public API, auth, deploy topology.
- It crosses two or more components or bounded contexts.
- A spec's "Alternative design" line rejected a real option (template 02).
Write an NK entry instead when you only reject an option.
At each milestone, re-read the accepted ADRs. Find each ADR that the code no longer follows.
For each one, restore the code, or write a superseding ADR that states the reason.

---

## Decision Register (only if other people own decisions)

Copy to `.agents/governance/DECISION-REGISTER.md`. Use it when a call belongs to a
stakeholder, not to the builder. It is the sibling of the Gap Register (template 01),
which holds rulings from a policy authority.

```markdown
### D{n} — {question} *(owner: {name}; opened {YYYY-MM-DD})*
- **What this is:** {plain language, in the owner's words}
- **Why we ask:** {why it is theirs to decide}
- **Options:** (A) … (B) …
- **Recommendation:** {option + one-line reason}
- **Running today:** {the default in production now}
- **Answer-by:** {YYYY-MM-DD}
- **DECISION ({date}, {who}):** {answer, verbatim where possible}
```

Rules:
1. Run a sensible default while the item is open. Never block on it.
2. An answer never applies itself. Record it, then apply it in a commit.
3. When the answer-by date passes, the user may decide by default. Record it as
   "decided by default" and inform the owner.
4. Move answered items to a Ratified section. Never delete them.
5. Route each item by an ownership map (`DECISION-OWNERSHIP-MAP.md`: domain → owner).
   Do not guess the owner.

---

## Negative-Knowledge Ledger

Copy to `.agents/governance/NEGATIVE-KNOWLEDGE.md`. It records what was rejected,
reversed or ruled out, so no session re-walks a dead end. Duties: template 01.

```markdown
**NK-{n} · {YYYY-MM-DD} · {scope}** — {what is rejected or forbidden}.
*Why:* {the reason a future session needs}. *Ref:* {spec, review, commit}.
**STANDING** | **SUPERSEDED ({date}: why the reason expired)** · reconsider when: {condition or —}
```

- Number by a whole-repo grep. Parallel workers reserve numbers from the orchestrator.
- Never delete an entry. A SUPERSEDED entry is the history of a "no" that expired.
