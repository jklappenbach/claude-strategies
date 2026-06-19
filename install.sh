#!/usr/bin/env bash
# Install the skills as standalone (un-namespaced) Claude Code skills.
# Symlinks every skill in skills/ into your user skills dir, so `git pull` keeps them
# current and they invoke as bare /design, /implement.
#
# Plugin alternative (namespaced /twilight:design, /twilight:implement), see README:
#   /plugin marketplace add jklappenbach/plugin-marketplace
#   /plugin install twilight@plugin-marketplace
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST"
echo "Installing skills -> $DEST"
count=0
for d in "$SKILLS_SRC"/*/; do
  [ -f "${d}SKILL.md" ] || continue
  name="$(basename "$d")"
  ln -sfn "${d%/}" "$DEST/$name"
  echo "  linked /$name -> ${d%/}"
  count=$((count + 1))
done
echo "Done: $count skill(s) installed (symlinked; 'git pull' in this repo updates them)."
echo
echo "Invoke with /design and /implement."
echo "The td-project-workflow memory installs per-project: the design skill writes it to"
echo "the project root and @-imports it from CLAUDE.md when it initializes a project."
