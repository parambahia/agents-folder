# Obsidian Vault Sync Template

Gives every project a notes vault that mirrors the `.agents/` framework. Session logs,
specs, architecture, runbooks, and the backlog get copied into an Obsidian vault so you
can read/search/annotate the project from Obsidian (desktop or phone) as it grows —
without touching the repo.

The vault is created automatically on the first `push`, so the framework "grows an
Obsidian" alongside the code.

## Setup

1. Copy the script below to `scripts/obsidian_sync.sh` and `chmod +x` it.
2. Set ONE config line at the top — `OBSIDIAN_VAULT`. Pick where the vault lives:
   - **Local (default):** `$HOME/ObsidianVaults/{project-name}` — clean, no git pollution,
     opens as a vault in Obsidian on this machine.
   - **In-repo:** `"$(cd "$(dirname "$0")/.." && pwd)/vault"` — self-contained and portable
     with the project. If you use this, add `vault/` to `.gitignore` so the mirror isn't
     committed twice.
   - **iCloud (phone sync):** `"$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/{project-name}"`
     — makes the vault reachable from Obsidian mobile. Note: iCloud doesn't follow symlinks,
     which is why this script rsyncs real files rather than linking.
3. Run `./scripts/obsidian_sync.sh push` once — it creates the vault folder (a bare
   `.obsidian/` so Obsidian recognizes it) and copies the framework in.
4. In Obsidian, "Open folder as vault" → point at `OBSIDIAN_VAULT`.

## Operating rules (bake into CLAUDE.md)

- **Pull at session start:** `./scripts/obsidian_sync.sh pull` — picks up notes you added via
  Obsidian/phone since last session.
- **Push after updating session logs or specs:** `./scripts/obsidian_sync.sh push` — keeps the
  vault current so the project is always readable from your phone.
- `status` shows what's out of sync without copying anything.
- `pull` never uses `--delete` (safety): Obsidian-only notes are preserved.

## Script

```bash
#!/bin/bash
# Obsidian <-> .agents/ bidirectional sync
# Usage: ./scripts/obsidian_sync.sh [push|pull|status]
#
# rsync copies real files (iCloud/Obsidian don't follow symlinks). --update means
# newer-wins per file; pull never deletes, so Obsidian-only notes survive.

set -euo pipefail

# --- Configuration: set the vault location (see Setup for options) ---
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"
AGENTS_DIR="$PROJECT_ROOT/.agents"
OBSIDIAN_VAULT="${OBSIDIAN_VAULT:-$HOME/ObsidianVaults/$PROJECT_NAME}"
OBSIDIAN_TARGET="$OBSIDIAN_VAULT/Agent Framework"

# Mapping: agents_subfolder|Obsidian_subfolder. Add rows as your .agents/ grows.
# Keep folder labels single-word (no spaces) — the loop is space-separated.
PAIRS="specs|Specs sessions|Sessions architecture|Architecture runbooks|Runbooks orchestrator|Orchestrator governance|Governance"

sync_dir() {
  local agents_sub="$1" obsidian_sub="$2" direction="$3"
  if [ "$direction" = "push" ]; then
    [ -d "$AGENTS_DIR/$agents_sub" ] || return 0
    mkdir -p "$OBSIDIAN_TARGET/$obsidian_sub"
    rsync -a --update "$AGENTS_DIR/$agents_sub/" "$OBSIDIAN_TARGET/$obsidian_sub/"
    echo "  $agents_sub -> $obsidian_sub"
  else
    [ -d "$OBSIDIAN_TARGET/$obsidian_sub" ] || return 0
    rsync -a --update "$OBSIDIAN_TARGET/$obsidian_sub/" "$AGENTS_DIR/$agents_sub/"
    echo "  $obsidian_sub -> $agents_sub"
  fi
}

for_each() {
  local direction="$1" pair agents_sub obsidian_sub
  for pair in $PAIRS; do
    agents_sub="${pair%%|*}"; obsidian_sub="${pair#*|}"
    sync_dir "$agents_sub" "$obsidian_sub" "$direction"
  done
}

do_push() {
  echo "Pushing .agents/ -> Obsidian vault ($OBSIDIAN_VAULT)..."
  mkdir -p "$OBSIDIAN_VAULT/.obsidian" "$OBSIDIAN_TARGET"   # first run creates the vault
  for_each push
  [ -f "$AGENTS_DIR/BACKLOG.md" ] && rsync -a --update "$AGENTS_DIR/BACKLOG.md" "$OBSIDIAN_TARGET/BACKLOG.md" && echo "  BACKLOG.md"
  echo "Push complete."
}

do_pull() {
  echo "Pulling Obsidian vault -> .agents/..."
  [ -d "$OBSIDIAN_TARGET" ] || { echo "No vault yet. Run 'push' first."; exit 0; }
  for_each pull
  [ -f "$OBSIDIAN_TARGET/BACKLOG.md" ] && rsync -a --update "$OBSIDIAN_TARGET/BACKLOG.md" "$AGENTS_DIR/BACKLOG.md" && echo "  BACKLOG.md"
  echo "Pull complete."
}

do_status() {
  echo "Sync status: .agents/ vs $OBSIDIAN_TARGET"
  [ -d "$OBSIDIAN_TARGET" ] || { echo "No vault yet. Run 'push' to initialize."; exit 0; }
  local pair agents_sub obsidian_sub out
  for pair in $PAIRS; do
    agents_sub="${pair%%|*}"; obsidian_sub="${pair#*|}"
    if [ -d "$AGENTS_DIR/$agents_sub" ] && [ -d "$OBSIDIAN_TARGET/$obsidian_sub" ]; then
      out=$(diff -rq "$AGENTS_DIR/$agents_sub" "$OBSIDIAN_TARGET/$obsidian_sub" 2>/dev/null || true)
      [ -n "$out" ] && { echo ""; echo "[$agents_sub]"; echo "$out"; }
    fi
  done
  echo "(no output above = in sync)"
}

case "${1:-status}" in
  push)   do_push ;;
  pull)   do_pull ;;
  status) do_status ;;
  *) echo "Usage: $0 [push|pull|status]"; exit 1 ;;
esac
```
