---
name: design
description: Author or revise a spec (docs/specs/<name>-spec.md) and its plan (agents/<name>-plan.md) when scoping new work — requirements + enumerated use cases in the spec, an outline-numbered TDD work plan in the plan. Use when starting a new application, feature, or capability. Governs both documents.
---

# design — author the spec and the plan

Use this when **scoping new work**. It governs the authoring of **both** documents:

- the **spec** — the *why* and the *what* (requirements + use cases), and
- the **plan** — the actionable *how* (an outline-numbered, TDD-structured work request).

Work **collaboratively with the developer**: ask questions, propose options with a
recommendation, iterate, and get explicit approval. Do not write the whole thing in
one pass and assume sign-off.

## 0. Ensure the project structure
If any of these are missing, initialize them at the project root first:

```
<root>/
├── td-project-workflow.md       # the governing memory at the root
├── docs/
│   └── specs/                   # specs:  docs/specs/<name>-spec.md
└── agents/                      # plans + work stacks (stacks maintained by implement):
    ├── <name>-plan.md           #   one plan per unit of work
    ├── <name>-stack.md          #   one per-plan task stack (LIFO within a plan)
    └── focus.md                 #   one cross-plan focus stack (which plan you're in)
```

**Install the governing memory.** This skill bundles `td-project-workflow.md`. On
project init, copy it to the project **root** and make it always-loaded by adding an
import line to the project's `CLAUDE.md`:

```
@td-project-workflow.md
```

(When installed as a plugin, the bundled file lives at
`${CLAUDE_PLUGIN_ROOT}/skills/design/td-project-workflow.md`; as a standalone skill
it sits beside this `SKILL.md`.)

## 1. Write the spec → `docs/specs/<name>-spec.md`

A spec (a.k.a. SRD / SRS) focuses on **requirements and use cases — the why and the
what**, never the implementation. Outline-number every section and item so each is
uniquely addressable (1, 1.1, 1.1.1, …).

1. **Definition** — define the application / feature / capability: its purpose and
   scope, the problem it solves, constraints, and explicit non-goals.
2. **Feature subsections** (`2`, `3`, …) — one per decomposed aspect of the design or
   featureset. Each subsection states that aspect's requirements and lists
   **enumerated use cases** (`2.1`, `2.2`, …). Write each use case concretely:
   actor + trigger + expected outcome ("as a X, when Y, then Z").

Drive it as a conversation — surface open questions and trade-offs, recommend, and
converge. **Do not start the plan until the spec is approved.**

## 2. Write the plan → `agents/<name>-plan.md`

The plan converts the approved spec into an **actionable work request**. Lead with:

- **Description** — a basic description of the work.
- **Systems** — the APIs, SDKs, or systems to be used.
- **Deliverables** — what is delivered once the work is complete.

Then a subsection for **each unit of work** (usually one commit). Every unit has
exactly three line-item subsections:

- **TDD** — the tests to write *before* any code. Passing all of them is the implicit
  acceptance criterion for the unit.
- **Coding** — the implementation items.
- **Acceptance** — explicit requirements beyond tests passing.

Outline-number the whole document so every section and line item is uniquely
identifiable (e.g. `3.2.1` = unit 3, TDD, item 1). Trace each unit back to the spec
use case(s) it satisfies.

Render each unit of work (and its line items) as a **markdown checkbox** (`- [ ]`) so
the **implement** skill can track progress against them — it marks `- [x]` when done
and `- [~]` when blocked. Because **implement** loads the plan onto a per-plan task stack
(`agents/<name>-stack.md`) in dependency order, **order the units by dependency**: any
unit that depends on another must come after it.

## 3. Approval and hand-off

Both documents are drafts until the developer approves them. On approval, hand off to
the **implement** skill to build the plan.
