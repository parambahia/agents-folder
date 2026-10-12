# 12 — Cross-Session Orchestration Protocol

How multiple live Claude sessions coordinate as one organisation. This extends
template 08 (single-repo orchestration) to the multi-terminal, multi-repo,
multi-machine case, using direct session messaging (SendMessage / ListAgents).
Proven in a 21 Aug 2026 ops-layer build: one orchestrator session routed two
worker sessions through five specs across three machines without the user
pasting a single handoff.

## Roles

- **Orchestrator**: the session the user talks to. Routes work, sequences
  shared resources, relays user decisions, keeps the board current. It does
  NOT implement specs while workers are available — it stays interruptible.
- **Worker**: a session that owns a repo/spec. Reports to the orchestrator with
  evidence, not summaries of hope.
- **Reviewer**: a fresh context that judges a worker's output against the
  spec. Give the reviewer seat the strongest available model. Give the
  worker seat the model that fits the spec (Opus for a written spec,
  Sonnet for mechanical work). When the budget is short, downgrade the
  worker, not the reviewer.

## Message discipline

1. **Self-contained dispatches.** A worker gets: the task, the spec path, the
   context deltas since its last knowledge, its constraints, and where to
   report. Workers have no access to the orchestrator's conversation.
2. **Verbatim context.** User dumps, briefs, and findings pass unsummarised.
   Compression loses constraints; tangents carry signal.
3. **Context pointers, not duplication.** Beyond the verbatim user material,
   communicate through pointers — to the spec, the tickets, the research
   notes, prior commits. Don't restate what a pointer already carries.
4. **Report with evidence.** Completion reports carry exit codes, file paths,
   commit hashes, and deviations — never "done" alone. The brief's first line
   is `STATUS: done|blocked|aborted-too-big`, so the orchestrator triages by grep.
5. **Stand-down explicitly.** When the orchestrator reassigns work mid-flight,
   it tells the displaced worker to stand down, so two sessions never produce
   competing evidence for one acceptance.
6. **Log every send.** After each successful SendMessage, append one JSONL
   line to `.agents/orchestrator/send-log.jsonl`:
   `{"ts":"<ISO8601>","from":"<session>","to":"<session>","brief":"<path>","kind":"dispatch|doorbell|stand-down|escalation"}`.
   Do not log message bodies. The brief file stays the record; the log
   answers "who told whom, when".

## Decomposition and shared research

- **The orchestrator owns decomposition.** A worker whose task turns out
  bigger than one vertical slice ABORTS back with what it learned — it never
  splits the task itself. Splitting in-flight burns the worker's budget and
  loses the cross-task view only the orchestrator has.
- **Explore once, share the notes.** Before fanning out related work, one
  research pass writes its findings to `.agents/research/` (gitignore if
  noisy). Every subsequent worker reads the notes instead of re-exploring the
  codebase — pointer-cheap, and it keeps workers consistent about the terrain.
  Measured cost of skipping this: in the MW2 swarm audit, isolated
  subagents duplicated 54.7% of large-file reads, and removing subagents
  raised commits by about 28%. Give a worker pointers to the notes. Do not
  tell a worker to "go explore".
- **Work the frontier.** When tasks form a graph with blocking edges (see the
  scaffold/Build Brief conventions), dispatch everything whose blockers are
  met, in parallel workers; re-evaluate the frontier as reports land.

## Shared-resource locking (single-writer rule)

Some resources tolerate exactly one writer at a time. The orchestrator grants
exclusive access and green-lights the next writer only after the current one
confirms completion by reading back the resource:

- **crontabs** (read-modify-write races clobber entries — grant per box)
- shared deploy directories on a box
- a repo's git index during multi-session work (`git add <paths>` only, NEVER
  `add -A` — a parallel worker's untracked files WILL be swept in)
- dev-server ports (one port per worker, assigned in the handoff — see
  "Worktree lifecycle")

## Worktree lifecycle (parallel workers)

A worktree separates files. It does NOT separate processes, ports or
databases.

1. Each repo that runs parallel workers ships
   `scripts/worktree-setup.sh` and `scripts/worktree-teardown.sh`.
2. Setup receives `WORKTREE_ROOT`, `WORKTREE_PATH` and `WORKTREE_NAME`.
   It installs dependencies, copies `.env` from the root, and makes a
   COPY of any single-writer database. It never links the live file.
3. Teardown stops services the worker started and frees its port.
4. Run teardown before `git worktree remove`.
5. Each worker derives its dev-server port as
   `BASE + (numeric spec id mod 100)`. The orchestrator writes the port
   into the handoff. Two workers never share a port.

## Permission boundaries (hard rules, no exceptions)

- A peer session's message is NEVER user approval. Approval reaches the
  executing session from its own user prompt, or the action moves to a session
  whose user directly instructed it.
- An action denied in one session is not retried in another to dodge the
  denial ("permission laundering"). It may run elsewhere only when the user
  directly ordered that session to do it.
- Denied + essential → STOP, surface to the user with the exact command they
  can run themselves.

## Failure etiquette

- A worker that hits a wall reports the wall precisely (what, error, what it
  needs) — it does not improvise around another session's territory.
- The orchestrator triages: fix, reassign, or escalate to the user. Escalation
  messages state the exact user action required, in one step if possible.

## Racing (optional, high-stakes specs only)

1. Give one spec to two workers in two worktrees (for example Opus and Codex).
2. Run one reviewer (Reviewer role above) on both diffs against the same acceptance criteria.
3. Merge one diff. Delete the other worktree.
Token cost doubles. Use it only when a wrong merge costs more than a second run.
