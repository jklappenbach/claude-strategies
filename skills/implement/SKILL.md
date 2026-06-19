---
name: implement
description: Implement an approved spec + plan (docs/specs/<name>-spec.md and agents/<name>-plan.md) by running its tasks through an explicit work stack in STACK.md — test-first, pushing subtasks/blockers and popping back, so the current focus and planned order are never lost. Use after the design skill once the plan is approved and coding begins.
---

# implement — execute the plan as a task stack, test-first, with visible state

Use this **after the spec and plan are approved** (authored by the **design** skill).
It turns `agents/<name>-plan.md`
into working code by driving an explicit **work stack** recorded in `STACK.md`, so the
current focus and the planned order of work are never lost.

## `STACK.md` is a work stack (LIFO), and the developer's dashboard
`STACK.md` at the project root holds the live work stack. Keep it current — it always
shows the stack top-to-bottom, the active plan/spec, and any blockers. Each entry is a
**task reference, not a copy** of the task:

```
[<plan-id>] <outline-id> — <task name>
```

i.e. the **plan's ID**, plus the task's **outline ID** and **name**.

## Starting a plan
Plans are **ordered by dependency**: a body of work that depends on a line item
naturally comes *after* that dependency. When a plan is started, **push its tasks onto
the stack in reverse plan order** — so the **first task popped off the top is the first
task in the plan**.

## Working the stack
Always work the task **on top of the stack**. For a coding task, run it **test-first**
(per the plan's three line-item subsections):

1. **TDD** — write the task's tests *first*; they should fail for the right reason.
2. **Coding** — implement until all the task's tests pass.
3. **Acceptance** — verify every explicit Acceptance item, plus the implicit criterion
   that all tests pass.

### Completing a task
1. Mark the task's checkbox in the **plan doc** with an **`x`** → `- [x]`.
2. **Pop** it from the top of the stack.
3. Commit (a unit of work usually maps to one commit), referencing the task.
4. Update `STACK.md`.

### Interruption → push a subtask
When a **subtask** is identified that must be worked **before** the current task — a
tangent, a higher-priority item, or a blocker — **push it onto the top of the stack**
and work it. When it's done, **pop** it to return to the previous task, exactly where
you left off. This is how we never lose track of what we were working on, or the order
in which we had planned the work.

### Can't finish → mark blocked
When a task **can't be finished due to an unexpected dependency**:
1. Mark its checkbox in the plan with a **`~`** → `- [~]` (instead of `x`).
2. Note a **reference to the blocking task or section** at the **end of the task line**.
3. Typically push that dependency onto the stack as a subtask, then resume the blocked
   task once the dependency clears.

## Plan checkbox states
- `- [ ]` — not started
- `- [x]` — done (tests written first + passing, acceptance met)
- `- [~]` — blocked / can't finish (unexpected dependency; reference noted at line end)

## Rules
- **Traceability:** a stack entry carries `[plan-id] outline-id — name`; use the same
  identifiers in commit messages and `STACK.md` so state traces back to the plan.
- **Never skip TDD:** a task is "done" only when its tests were written first and pass.
- **Keep the documents accurate:** if reality diverges from the plan, update the plan
  (and note it in `STACK.md`) rather than silently drifting; update the spec if the
  *requirements* changed.
- **Report honestly:** `STACK.md` is the dashboard — show the real stack, failing
  tests, and blockers (`~`); never present unverified work as done.
