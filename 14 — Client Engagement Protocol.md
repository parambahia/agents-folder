# 14 — Client Engagement Protocol

Use this template for paid work inside a client's business. It covers how
we enter, what we build, how we prove value, and how we leave. Copy it to
`.agents/engagement/ENGAGEMENT.md` in the delivery repo.

## Non-negotiable rules
1. Build inside the client's existing tools. Never propose a replacement
   for a system of record the client already pays for.
2. Freeze a dated KPI baseline before you build anything.
3. Write the exit plan in week 1, not at the end.
4. Put an estimated monthly run cost next to every agent.
5. Keep client data out of your other repos and out of any side agent.

## Phase 1 — Map (weeks 1–2)
1. Interview the "human API" for each department in scope.
2. Get read access to the systems of record for 3–4 weeks of history.
3. Collect the working documents (shared drives, chat, email templates).
4. Tag each process fact `observed`, `told` or `inferred`.
5. Write one process map per workflow in `.agents/process-maps/`.

## Phase 2 — Sort and baseline (weeks 2–4)
Sort every step into one bucket:

| Bucket | Rule |
|---|---|
| Delete | The step adds no value. Remove it. |
| Code | The rule is "if X then Y". Write plain code. |
| Agent | The step needs judgment and has history to learn from. |
| Human | Approval, negotiation, signing, payment, or any irreversible act. |

Then freeze the baseline in `.agents/evidence/BASELINE-<YYYY-MM-DD>.md`:
KPI, definition, value, source query, date. Do not edit a frozen baseline.

## Phase 3 — Build (weeks 5–8)
1. Write one spec per workflow (template 02).
2. Benchmark each agent workflow on two models. Pick the cheapest model
   that passes the acceptance criteria.
3. Route every Human-bucket step to a sign-off in the client's own channel.
4. Ship a Tier 0 liveness check for every deployed workflow (template 11).

## Cost line (one row per agent)
| Workflow | Model | Runs/month | Est. cost/month | Human hours replaced/month | Owner of the bill |
|---|---|---|---|---|---|

## Exit plan ("how we leave")
Complete one row per delivered workflow before handover:

| Item | Content |
|---|---|
| Client owner | Named person who runs it after we leave |
| Runbook | Path; written in Simplified Technical English |
| Client may change | Config, prompts, rules, thresholds (list them) |
| Needs us | Changes that require the owner (list them) |
| Breaks if we leave | Known dependencies on the owner's accounts or machines |
| Credentials | Moved to client-owned accounts (yes/no, date) |
| Cost ownership | Model and hosting bills moved to the client (yes/no, date) |
| Unaided week | Client ran it for 7 days without the owner (pass/fail, dates) |

Put a matching handover clause in the SOW.

## Return visits (+3 and +6 months)
1. Book both dates at handover.
2. Re-run the frozen baseline queries.
3. Write `.agents/evidence/RETURN-<+3m|+6m>-<YYYY-MM-DD>.md`: before,
   after, delta, cost line actuals, and one sentence on what changed.
4. Treat a missing return report as a failed liveness check.

## Contract paper (not legal advice)
Use a reviewed NDA, PSA/SOW and DPA. Get a UK solicitor review before the
first use of any template. Record the version used in the engagement file.
