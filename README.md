# claude-strategies

Shareable [Claude Code](https://claude.com/claude-code) **skills** and **memories** I'm
developing — reusable strategies for working with Claude Code, packaged so others
(and other machines) can pick them up.

## Layout

```
skills/      one directory per skill, each with a SKILL.md (+ any supporting files)
memories/    portable memory files (markdown w/ frontmatter) — reference content; see caveats
```

## Installing a skill

Each skill is a standard Claude Code skill: a directory containing a `SKILL.md`.
Install it at the **user level** (available in every project) or **project level**
(scoped to one repo). Clone this repo first, then symlink (recommended — picks up
changes when you `git pull`) or copy:

```sh
# user-level: available everywhere
mkdir -p ~/.claude/skills
ln -sfn "$PWD/skills/<skill-name>" ~/.claude/skills/<skill-name>

# project-level: scoped to one repo (commit it there if you like)
ln -sfn "$PWD/skills/<skill-name>" /path/to/project/.claude/skills/<skill-name>

# copy instead of symlink (frozen snapshot)
cp -r skills/<skill-name> ~/.claude/skills/
```

Install **all** skills at once:

```sh
mkdir -p ~/.claude/skills
for d in skills/*/; do ln -sfn "$PWD/$d" ~/.claude/skills/"$(basename "$d")"; done
```

Invoke a skill in Claude Code with `/<skill-name>` (or let Claude auto-invoke it
based on its `description`).

### SKILL.md format

```yaml
---
name: my-skill           # optional; defaults to the directory name
description: One line telling Claude WHEN to use this skill (required)
# disable-model-invocation: true   # optional; manual /my-skill only, no auto-invoke
---

# Skill body — the instructions Claude follows when the skill runs.
```

## Memories

⚠️ **Memories are not distributable the way skills are.** Claude Code's auto-memory
is **machine-local** and keyed per project (it lives in
`~/.claude/projects/<project-slug>/memory/`, where the slug derives from the git
repo). There is no memory registry, plugin channel, or install command. So the
files in `memories/` are shared as **reference content**, and there are a few ways
to actually put them to use:

**A. Seed via a skill (recommended for distributing memory content).**
Because skills *are* distributable, the cleanest way to ship memory content is a
small installer skill that copies the curated files in `memories/` into the active
project's memory store and updates its `MEMORY.md` index. Keep the facts as data in
`memories/` (reviewable, diff-able) and let the skill be the thin installer — don't
bake the facts into the skill body.

**B. Always-on directives → `CLAUDE.md` / `.claude/rules/`, not a skill.**
A skill only acts when invoked. For behavior that should *always* apply, use
`CLAUDE.md` (always in context). For **user-global** directives across every
project, keep them here and symlink:
```sh
ln -sfn "$PWD/CLAUDE.md" ~/.claude/CLAUDE.md   # global, always-loaded, repo-tracked
```
For **project-wide** facts, commit them to that repo's `CLAUDE.md` / `.claude/rules/`.

**C. Copy into a project's memory store** (manual, one-off):
```sh
cp memories/<file>.md ~/.claude/projects/<your-project-slug>/memory/
# then add a one-line pointer for it in that project's memory/MEMORY.md index
```

**D. Point Claude Code at this checkout** via `settings.json` (makes it the live
store for a project — note Claude will then *write* here too):
```json
{ "autoMemoryDirectory": "~/claude-strategies/memories" }
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
