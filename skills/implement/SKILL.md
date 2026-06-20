---
name: implement
description: Implement an approved spec + plan (docs/specs/<name>-spec.md and agents/<name>-plan.md) test-first, driving a two-level focus stack — per-plan task stacks (agents/<name>-focus.md) under one cross-plan focus stack (agents/focus.md) — so tangents within and across plans always pop back to where you were. The plan's checkboxes own completion. Use after the design skill once the plan is approved and coding begins.
---

# implement — execute plans test-first on a two-level work stack

Use this **after the spec and plan are approved** (authored by the **design** skill). It
turns `agents/<name>-plan.md` into working code while keeping the current focus and the
planned order of work visible and recoverable — even across tangents and plan switches.

## The two-level focus stack (a call stack)
Think of it exactly like a runtime call stack: **`agents/focus.md` is the frame stack;
each `agents/<name>-focus.md` is the locals of a frame.**

Both levels share the **`focus`** filename convention — `focus.md` (global) and
`<name>-focus.md` (per-plan) — because both answer *what am I focused on*, at two
granularities: the global file names which **plan**, the per-plan file names which
**task**. Each is still a LIFO stack; only the name is unified.

### Per-plan task stack — `agents/<name>-focus.md` (one per plan)
The LIFO of tasks **within** a plan. It pairs with `agents/<name>-plan.md` (same
`<name>`), is isolated from other plans, and is archived/deleted when the plan closes
(the plan's checkboxes remain the record). While you're away working another plan, this
file is **untouched**, so returning resumes you at the exact task you left.

Each entry is a **task reference, not a copy**:

```
<outline-id> — <task name>
```

the task's **outline ID** and **name** from that plan.

### Focus stack — `agents/focus.md` (one, global, cross-plan)
A **thin** LIFO of **which plan/context you're attending to** — frames, not tasks:

```
[<plan-id>]          # a plan you're working
[explore: <what>]    # an ad-hoc tangent outside any plan
```

It grows with attention **depth** (usually 1–3), not task count. The **top frame names
the plan whose task stack you're currently working.**

## The one rule (push/pop scoping)
- A subtask/blocker **inside the current plan** → push it on **that plan's**
  `<name>-focus.md` (local), work it, pop back.
- A jump to **another plan**, or **free exploration** → push a **frame** on `focus.md`
  and switch to that plan's task stack (creating it if new). When the frame is done,
  **pop `focus.md`** — you're back in the previous plan, and its task stack still holds
  your exact place.

Example `focus.md` while three deep:

```
[explore: net buffer sizing]   ← working now
[cajeta-net]                   ← jumped here from…
[cajeta-ifx]                   ← home; resume when the frames pop
```

## Starting / switching to a plan
Plans are **dependency-ordered**. When you start a plan:

1. Create `agents/<name>-focus.md` and **push its tasks in reverse plan order** — so the
   **first task popped is the first task in the plan**. Push **only uncompleted (`- [ ]`)
   and blocked (`- [~]`) line items**; skip anything already marked done (`- [x]`). When
   resuming a partly-done plan this is what puts you back at the first *remaining* task,
   not the top of a list of finished work.
2. Push a frame `[<name>]` onto `agents/focus.md`.

Switching to an already-started plan is just step 2 — its task stack is where you left it.

## Working the top of the stack
Work the task on top of the **current plan's** task stack (the plan named by the top
focus frame). For a coding task, run it **test-first** (the plan's three line-item
subsections):

1. **TDD** — write the task's tests *first*; they should fail for the right reason.
2. **Coding** — implement until all the task's tests pass.
3. **Acceptance** — verify every explicit Acceptance item, plus the implicit criterion
   that all tests pass.

### Completing a task
1. Mark the task's checkbox in the **plan doc** → `- [x]`. *(Completion lives only here.)*
2. **Pop** it from the current plan's task stack.
3. Commit (a unit of work usually maps to one commit), referencing the task.
4. Update the stack file(s) you touched.

### Interruption → push a subtask
A **subtask** that must be worked **before** the current one — a tangent, a
higher-priority item, or a blocker:

- **In the current plan** → push it on the plan's `<name>-focus.md`, work it, pop back.
- **In another plan, or free exploration** → push a frame on `focus.md` and switch.

When it's done, pop back exactly where you left off — this is how we never lose track of
what we were working on, or the order in which we had planned the work.

### Offered options ARE stack items
When you present the user a set of next-step options, you are **reading off the stack** —
the options and the stack must never diverge. On the user's choice:

1. The **picked** option becomes the active top (work it).
2. **Push every unchosen option onto the stack** (the plan's task stack if it's in-plan,
   a `focus.md` frame if it's another plan/tangent) — into the deferred/discovered
   section, **not** left only in prose. An option you offered but didn't capture is an
   option you lost.

Conversely, when deciding *what* options to offer, **draw them from the stack** so the
"what could I do next" you present and the "what's parked" in the files are the same list.
This is what keeps the dashboard honest: the user is always choosing among real,
recorded stack items, never ephemeral suggestions.

### Completing / abandoning a frame
When a plan is finished (or you drop a tangent), **pop the frame** from `focus.md`. On
plan completion, archive or delete its `<name>-focus.md` — the checked plan is the record.

### Can't finish → mark blocked
When a task **can't be finished due to an unexpected dependency**:

1. Mark its checkbox in the plan with `- [~]` (instead of `x`).
2. Note a **reference to the blocking task or section** at the **end of the task line**.
3. Push the dependency — on the same plan's stack if it's in-plan, or as a new `focus.md`
   frame if it lives in another plan — then resume the blocked task once it clears.

## Plan checkbox states
- `- [ ]` — not started
- `- [x]` — done (tests written first + passing, acceptance met)
- `- [~]` — blocked / can't finish (unexpected dependency; reference noted at line end)

## Where the files live
Plans and both stack levels live under **`agents/`**. In split public/private repos
`agents/` is often gitignored or a separate repo — commit the plan + stacks wherever
`agents/` is versioned, not with the code. `focus.md` is deliberately **not**
branch-isolated: your attention spans branches. On a fresh clone without `agents/`,
degrade gracefully — work from whatever's present rather than erroring.

## Rules
- **Traceability:** `focus.md` frames carry `[plan-id]`; per-plan entries carry
  `outline-id — name`. Use the same identifiers in commit messages so state traces back
  to the plan.
- **Never skip TDD:** a task is "done" only when its tests were written first and pass.
- **Keep the documents accurate:** if reality diverges from the plan, update the plan
  (and reflect it in the stack) rather than silently drifting; update the spec if the
  *requirements* changed.
- **Keep the stacks thin:** they hold *doing* and *discovered*, never *done* — completion
  lives in the plan's checkboxes. If a task stack starts looking like a second plan,
  promote those items into the plan instead. There is **no** separate completed-log file.
- **Options track the stack:** every next-step option you offer is a stack item; the
  unchosen ones get pushed (deferred), and the options you present are read off the stack.
  Offered choices and recorded stack never diverge.
- **Report honestly:** the stacks are the dashboard — show the real frames, the real task
  stack, failing tests, and blockers (`~`); never present unverified work as done.
