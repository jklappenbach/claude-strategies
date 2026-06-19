# plugin-marketplace

A [Claude Code](https://claude.com/claude-code) **plugin marketplace** — shareable
skills and memories I'm developing. Its flagship plugin, **`twilight`**, packages a
spec → plan → develop workflow (the **`design`** and **`implement`** skills).

## Layout

```
.claude-plugin/
  marketplace.json   marketplace catalog
  plugin.json        the twilight plugin manifest
skills/              one directory per skill, each with a SKILL.md
  design/            authors a spec + plan
  implement/         executes a plan, test-first
memories/            portable memory files (reference content; see caveats)
install.sh           standalone (non-plugin) installer
```

## Install

### Option 1 — plugin (recommended)

```
/plugin marketplace add jklappenbach/plugin-marketplace
/plugin install twilight@plugin-marketplace
```

Skills then invoke **namespaced**: `/twilight:design`, `/twilight:implement`.
Update later with `/plugin update twilight`.

### Option 2 — install script (bare commands)

Clone and run the installer — it symlinks every skill into `~/.claude/skills/` (so
`git pull` keeps them current); they invoke as bare `/design`, `/implement`:

```sh
git clone https://github.com/jklappenbach/plugin-marketplace.git
cd plugin-marketplace && ./install.sh
# custom location: CLAUDE_SKILLS_DIR=/path/.claude/skills ./install.sh
```

### Option 3 — manual

```sh
mkdir -p ~/.claude/skills
for d in skills/*/; do ln -sfn "$PWD/$d" ~/.claude/skills/"$(basename "$d")"; done
# or per-skill; or copy instead of symlink; or into a project's .claude/skills/
```

> **Invocation differs by method:** the plugin namespaces commands
> (`/twilight:design`); the script/manual symlink keeps them bare (`/design`).

### SKILL.md format

```yaml
---
name: my-skill           # optional; defaults to the directory name
description: One line telling Claude WHEN to use this skill (required)
# disable-model-invocation: true   # optional; manual /my-skill only, no auto-invoke
---

# Skill body — the instructions Claude follows when the skill runs.
```

## The twilight workflow

- **`design`** — authors the spec (`docs/specs/<name>-spec.md`: the *why/what* with
  enumerated use cases) and the outline-numbered, TDD-structured plan
  (`agents/<name>-plan.md`).
- **`implement`** — executes the approved plan **test-first** on a **two-level work
  stack** (a call stack): per-plan task stacks `agents/<name>-stack.md` under one
  cross-plan **focus stack** `agents/focus.md`. Same-plan tangents push on the plan's
  stack; jumps to another plan or free exploration push a frame on `focus.md` — so
  popping always returns you to where you were, within a plan and across plans. Marks
  plan checkboxes `x` (done) / `~` (blocked); completion lives in the plan.

The governing convention lives in `memories/td-project-workflow.md`, which the
`design` skill installs into each project's root (and `@`-imports from `CLAUDE.md`).

## Memories

⚠️ **Memories are not distributable the way skills are.** Claude Code's auto-memory
is **machine-local** and keyed per project (`~/.claude/projects/<project-slug>/memory/`,
slug derived from the git repo). There is no memory registry, plugin channel, or
install command. So the files in `memories/` are shared as **reference content**, with
a few ways to use them:

**A. Carried by the `design` skill (automatic, for the workflow memory).** Since memory
has no native distribution but skills do, the workflow memory rides in the skill:
`design` bundles `td-project-workflow.md` and, on project init, writes it to the
project root and `@`-imports it from `CLAUDE.md` — so installing the plugin/skill is
all that's needed. The same pattern works for other memories: a thin skill copies a
`memories/*.md` into a project and wires the import; keep the facts as data in
`memories/`, not baked into skill logic.

**B. Always-on directives → `CLAUDE.md` / `.claude/rules/`.** A skill only acts when
invoked. For behavior that should *always* apply, use `CLAUDE.md`; for user-global
directives across every project, keep a `CLAUDE.md` here and symlink it to
`~/.claude/CLAUDE.md`.

**C. Copy into a project's memory store** (manual):
```sh
cp memories/<file>.md ~/.claude/projects/<your-project-slug>/memory/
# then add a one-line pointer in that project's memory/MEMORY.md index
```

**D. Point Claude Code at a checkout** via `settings.json`:
```json
{ "autoMemoryDirectory": "~/plugin-marketplace/memories" }
```

Each memory file is markdown with frontmatter:

```yaml
---
name: short-kebab-slug
description: one-line summary used to decide relevance during recall
metadata:
  type: user | feedback | project | reference
---

The fact. Link related memories with [[other-slug]].
```

## License

[MIT](LICENSE) © Julian Klappenbach
