---
name: subagent-chain
description: Coordinate substantial development work through specialized sub-agents using scout, research, planning, oracle escalation, implementation, and independent review. Use when a task materially benefits from delegated context gathering, external research, independent reasoning, or implementation verification.
---

# Subagent Development Workflow

Coordinate substantial development work through specialized sub-agents while keeping the main agent as the supervisor and final decision-maker.

The preferred development loop is:

**clarify → scout → research/plan as needed → oracle escalation when warranted → worker → fresh reviewer → worker fixes if needed**

Do not force every task through every role.

Use the smallest workflow that materially improves correctness, evidence, specialization, or review quality.

---

## Requirements Source

When invoked without an explicit task, the main agent MUST read:

```text
for-ai-agents/todo.md
```

in the project root before proceeding.

If the task is explicit, treat the user's current request as authoritative and use `todo.md` only for additional project constraints.

---

# Task Isolation

Each workflow MUST have its own task-specific directory under:

```text
for-ai-agents/
```

Before starting a workflow, create:

```text
for-ai-agents/<task-slug>/
```

The `<task-slug>` MUST be:

- short and descriptive
- filesystem-safe
- derived from the current task
- unique enough to avoid collision with another active task

Examples:

```text
for-ai-agents/add-redis-cache/
for-ai-agents/fix-order-duplication/
for-ai-agents/migrate-schwab-api/
```

Never place workflow artifacts directly under:

```text
for-ai-agents/
```

except for pre-existing project-level files such as:

```text
for-ai-agents/todo.md
```

Typical task structure:

```text
for-ai-agents/
├── todo.md
├── add-redis-cache/
│   ├── context.md
│   ├── research.md
│   ├── evidence.md
│   ├── plan.md
│   ├── oracle.md
│   └── progress.md
└── another-task/
    └── ...
```

ALL SUB-AGENTS MUST HONOR THIS CONSTRAINT.

A sub-agent MUST NOT read or modify artifacts belonging to another task unless the parent explicitly identifies that artifact as an input.

The parent MUST pass the current task directory explicitly when delegating.

---

# When to Use

Use this skill when a task materially benefits from one or more of:

- unfamiliar or complex codebase exploration
- external API/library/service research
- multi-step implementation
- architectural or behavioral uncertainty
- hidden state or side effects
- difficult implementation decisions
- independent implementation review
- long-running implementation
- separation between planning, implementation, and verification

Do not use the full workflow for trivial changes such as:

- obvious one-line fixes
- simple renames
- formatting-only changes
- isolated typo corrections
- changes whose behavior is already completely established

For small tasks, use the smallest useful child handoff or work directly when appropriate.

---

# Core Principles

## 1. Parent remains the supervisor

The main agent owns:

- task interpretation
- user-facing decisions
- scope and product decisions
- approval of architectural changes
- synthesis of child findings
- final acceptance

Sub-agents provide:

- reconnaissance
- research
- evidence verification
- planning
- technical advice
- implementation
- review

Sub-agents MUST NOT silently make unapproved product or architectural decisions.

## 2. Prefer the smallest useful delegation

Use the built-in roles according to their actual purpose:

| Agent | Primary purpose |
|---|---|
| `scout` | Fast codebase reconnaissance |
| `researcher` | External research |
| `evidence-auditor` | Verify important research evidence |
| `delegate` | Lightweight planning, synthesis, or bounded reasoning |
| `oracle` | Difficult decision/root-cause/hidden-assumption escalation |
| `worker` | Implementation |
| `reviewer` | Independent implementation review |

Do not invoke an agent merely because it exists.

## 3. Do not confuse planning with Oracle review

`delegate` is appropriate for producing a concrete implementation plan.

`oracle` is appropriate for challenging an existing direction when the consequences of being wrong are significant.

The normal relationship is:

```text
delegate
    ↓
implementation plan
    ↓
oracle, if warranted
    ↓
corrected direction
```

Do not use Oracle as the default planning agent.

---

# Workflow

## Stage 0: Clarify

Before delegating, determine:

1. What exactly must change?
2. What must remain unchanged?
3. What are the acceptance criteria?
4. Is external research necessary?
5. Is implementation required, or only analysis/planning?
6. Is there an architectural or behavioral decision requiring escalation?

If an essential product or scope decision is unresolved, ask the user.

Do not manufacture requirements to avoid asking.

## Stage 1: Create Task Directory

Create a task-specific directory before producing workflow artifacts:

```text
for-ai-agents/<task-slug>/
```

Record the path and use it consistently throughout the workflow.

All subsequent workflow documents MUST live there.

## Stage 2: Scout

For non-trivial implementation work, use `scout` when the relevant codebase is not already sufficiently understood.

Typical task:

```text
agent: "scout"
context: "fresh"

task:
"Inspect the codebase relevant to this task.

Current task directory:
for-ai-agents/<task-slug>/

Identify:
- relevant files and entry points
- current control/data flow
- existing patterns to preserve
- dependencies and side effects
- tests covering the behavior
- likely implementation locations
- important unknowns or risks

Do not implement changes.

Write findings to:
for-ai-agents/<task-slug>/context.md"
```

The scout establishes facts. It should NOT attempt to produce a complete implementation plan unless explicitly asked.

If the parent already has sufficient reliable codebase context, skip scout.

## Stage 3: Research — Only When Needed

Use `researcher` when the task depends on information outside the repository:

- API behavior
- library/framework documentation
- protocol specifications
- third-party service behavior
- recent version changes
- compatibility requirements
- external best practices
- current technical information

Typical task:

```text
agent: "researcher"

task:
"Research [specific topic].

Current task directory:
for-ai-agents/<task-slug>/

Answer:
- what is officially supported
- relevant constraints
- important version differences
- implementation implications

Prefer primary sources.
Record URLs and source evidence.
Distinguish documented facts from inference.

Write findings to:
for-ai-agents/<task-slug>/research.md"
```

Do not use researcher merely to make a task look sophisticated.

## Stage 4: Evidence Audit — Only When Needed

Use `evidence-auditor` when important decisions depend on claims made in `research.md`.

Typical task:

```text
agent: "evidence-auditor"

task:
"Audit:
for-ai-agents/<task-slug>/research.md

For every material claim:
- verify that the cited source supports it
- identify unsupported or ambiguous claims
- distinguish facts from inference
- flag stale or version-sensitive evidence

Write the audit to:
for-ai-agents/<task-slug>/evidence.md"
```

Use this when incorrect external information could materially invalidate the implementation.

Do not automatically run it after every research task.

## Stage 5: Plan

Planning is conditional.

For simple changes, the parent may formulate implementation steps directly.

For substantial changes, use `delegate` to synthesize the available context into a concrete plan.

`delegate` is a lightweight general-purpose delegate, not a mandatory planner role.

Typical task:

```text
agent: "delegate"
context: "fresh"

task:
"Create an implementation plan for the requested change.

Current task directory:
for-ai-agents/<task-slug>/

Read:
- for-ai-agents/<task-slug>/context.md
- for-ai-agents/<task-slug>/research.md, if present
- for-ai-agents/<task-slug>/evidence.md, if present
- relevant source files

The plan must:
- identify exact files/functions to change
- describe intended behavior
- preserve existing project patterns
- identify dependencies
- identify risks and edge cases
- define acceptance criteria
- distinguish confirmed facts from assumptions
- avoid unnecessary scope expansion

Write the plan to:
for-ai-agents/<task-slug>/plan.md"
```

The plan should be concrete enough that a worker can implement it without rediscovering the entire problem.

## Stage 6: Decide Whether Oracle Is Necessary

Do NOT automatically invoke `oracle`.

Ask:

> Would an independent high-reasoning critic materially reduce the risk of choosing the wrong implementation direction?

Use Oracle when there is:

- architectural uncertainty
- hidden state or side effects
- non-obvious data flow
- competing implementation strategies
- difficult API semantics
- potential behavior regression
- root-cause uncertainty
- hidden coupling
- high-cost or difficult-to-reverse decisions
- security-sensitive behavior
- significant concurrency or transaction semantics
- uncertainty that a helper is actually side-effect-free
- disagreement between agents
- a reviewer finding that requires deeper reasoning

Do NOT use Oracle for routine implementation review.

Oracle is an escalation mechanism, not a mandatory workflow stage.

## Stage 7: Oracle

When Oracle is warranted, use a forked context.

Typical task:

```text
agent: "oracle"
context: "fork"

task:
"Act as an adversarial technical advisor.

Current task directory:
for-ai-agents/<task-slug>/

Review:
for-ai-agents/<task-slug>/plan.md

Also inspect relevant source files.

Challenge the current direction:

1. Identify important assumptions.
2. Trace hidden side effects and coupling.
3. Look for contradictions with existing behavior.
4. Identify edge cases and failure modes.
5. Check whether the proposed changes preserve existing invariants.
6. Compare plausible alternatives where relevant.
7. Identify risks that the plan underestimates.
8. Identify decisions that require user approval.
9. Recommend concrete corrections.

Do not modify implementation files.

Write findings to:
for-ai-agents/<task-slug>/oracle.md"
```

Oracle should be especially suspicious of apparently harmless helper calls, shared state, implicit mutation, transaction boundaries, caching, retries, and other behavior that may not be visible from the immediate call site.

Oracle is advisory. The parent remains responsible for deciding whether and how to apply its findings.

## Stage 8: Synthesize Oracle Findings

The parent MUST review Oracle's findings before implementation.

If Oracle finds no material issue, the plan remains valid.

If Oracle identifies corrections, the parent applies them to the plan and passes the corrected direction to the worker.

Do not blindly copy Oracle's recommendation into the plan.

If Oracle exposes a material product or architectural choice, ask the user before implementation.

## Stage 9: User Approval

User approval is required when the workflow reaches a material decision involving:

- product behavior
- scope expansion
- irreversible data changes
- architectural trade-offs
- compatibility-breaking changes
- significant security implications
- significant operational/cost implications
- an Oracle finding that changes the proposed direction

Do NOT force approval merely because a plan exists.

For a straightforward implementation whose requirements and direction are already established, proceed without unnecessary confirmation.

When approval is needed, present:

1. current decision
2. alternatives considered
3. material risks
4. proposed direction
5. consequences of approval

Then wait.

## Stage 10: Worker

Use `worker` after the implementation direction is sufficiently settled.

Typical task:

```text
agent: "worker"
context: "fork"

task:
"Implement the approved change.

Current task directory:
for-ai-agents/<task-slug>/

Read:
- for-ai-agents/<task-slug>/plan.md
- for-ai-agents/<task-slug>/oracle.md, if present
- relevant source files

Requirements:
[requirements]

Important corrections from Oracle:
[only if applicable]

Implementation requirements:
[concrete implementation sequence]

Files expected to change:
[exact paths]

Preserve:
[existing patterns and constraints]

Validate the implementation with appropriate tests/checks.

Do not invent product or architectural decisions.
If an unapproved decision is required, stop and ask the parent."
```

The worker should execute the approved direction rather than independently redesigning it.

If implementation reveals that the plan is incorrect, the worker should report the discrepancy rather than silently changing architecture.

For long-running implementation, use progress tracking where appropriate:

```text
for-ai-agents/<task-slug>/progress.md
```

## Stage 11: Fresh Review

After implementation, use `reviewer` for the normal review gate.

The reviewer should inspect the actual implementation and diff, not merely reread the plan.

Use fresh context for independence.

Typical task:

```text
agent: "reviewer"
context: "fresh"

task:
"Review the current implementation.

Current task directory:
for-ai-agents/<task-slug>/

Inspect:
- original requirements
- approved plan
- Oracle findings, if present
- actual repository state
- actual diff
- relevant tests

Check:
1. correctness
2. regressions
3. edge cases
4. error handling
5. concurrency/state behavior where relevant
6. tests
7. consistency with existing patterns
8. unnecessary complexity
9. accidental scope changes
10. whether the implementation actually satisfies the acceptance criteria

Report concrete findings with file/function evidence.

Classify findings as:
- P0: must fix
- P1: should fix before completion
- P2: optional improvement

End with:
Merge verdict: BLOCK
or
Merge verdict: OK
or
Merge verdict: OK with notes

Do not modify files unless explicitly asked to perform a fix pass."
```

Reviewer is the normal post-implementation verification role.

## Stage 12: Fix Review Findings

If Reviewer finds P0/P1 issues:

```text
reviewer
    ↓
parent synthesizes findings
    ↓
worker fixes
    ↓
fresh reviewer
```

Do not restart the entire workflow unnecessarily.

Do not automatically invoke Oracle for normal reviewer findings.

Escalate to Oracle only if the review exposes:

- unresolved root cause
- architectural conflict
- conflicting reviewer conclusions
- hidden invariant
- major product decision
- difficult trade-off
- uncertainty that cannot be resolved by ordinary implementation work

Continue the review loop until:

- no P0/P1 issues remain
- remaining P2 items are optional or explicitly deferred
- an unresolved user decision blocks progress
- a reasonable review-round limit is reached

---

# Recommended Workflow Shapes

## A. Simple implementation

```text
clarify
  ↓
worker
  ↓
reviewer
```

## B. Unfamiliar codebase

```text
clarify
  ↓
scout
  ↓
worker
  ↓
reviewer
```

## C. External API/library work

```text
clarify
  ↓
scout
  ↓
researcher
  ↓
delegate / plan
  ↓
worker
  ↓
reviewer
```

Add `evidence-auditor` when important external claims need verification.

## D. High-risk architecture or behavior change

```text
clarify
  ↓
scout
  ↓
researcher
  ↓
delegate / plan
  ↓
oracle
  ↓
👤 approval if direction changes
  ↓
worker
  ↓
fresh reviewer
  ↓
worker if needed
```

This replaces the previous mandatory researcher → delegate → oracle → worker chain.

## E. Review discovers a hard problem

```text
worker
  ↓
fresh reviewer
  ↓
material unresolved issue
  ↓
oracle
  ↓
parent decision
  ↓
worker
  ↓
reviewer
```

Do not rerun unrelated earlier stages unless their assumptions have become invalid.

---

# Artifact Handoff Rules

When passing work between agents:

1. Tell the child exactly which artifact to read.
2. Use the current task directory explicitly.
3. Put the most important files first in `reads`.
4. Put critical corrections directly in the task prompt.
5. Do not assume inherited conversation context contains all required facts.
6. Keep generated artifacts under the current task directory.
7. Prefer concise handoff documents over dumping the entire repository into every child.
8. Never use another task's artifacts unless explicitly requested.

Do NOT use ambiguous paths such as:

```text
for-ai-agents/plan.md
for-ai-agents/research.md
```

for task-specific artifacts.

---

# Context Strategy

Use:

```text
fresh
```

when independence matters:

- researcher
- evidence-auditor
- delegate
- normal reviewer

Use:

```text
fork
```

when the child should understand the parent's current trajectory:

- oracle
- worker
- difficult implementation handoff

A forked context provides continuity but should not replace explicit artifact handoff.

The important plan, corrections, and requirements MUST still be identified explicitly.

---

# Model Strategy

Model selection belongs to configuration, not workflow logic.

This skill MUST NOT depend on `fallbackModels`.

If another model is required after a failure, launch a separate explicit subagent with that model.

Recommended capability tiers:

```text
scout
  fast / cheap

researcher
  reliable research model

evidence-auditor
  independent evidence-oriented model

delegate
  lightweight but capable reasoning model

oracle
  strongest available reasoning model
  used selectively

worker
  cost-effective capable coding model

reviewer
  strong independent coding/review model
```

Do not automatically assign the strongest model to every role.

Model diversity is useful when practical:

```text
delegate → model A
oracle   → model B
reviewer → model C
```

This reduces the chance that the same model reproduces the same blind spot across planning and review.

---

# Failure and Recovery

If a child fails:

1. Inspect the actual failure.
2. Determine whether the task itself remains valid.
3. Retry the same role only when retrying is meaningful.
4. If a different model is needed, explicitly launch another child with that model.
5. Do not silently substitute a different role for the failed role.
6. Preserve useful artifacts from the failed run.
7. If the failure exposes an unresolved decision, escalate to the parent/user.

Do not claim successful completion merely because a child process ended.

A provider/model failure is not the same thing as a task-quality failure.

Do not switch models merely because a child produced a result the parent dislikes; first determine whether the issue is model failure, insufficient context, unclear instructions, or an actual disagreement.

---

# Trivial Task Handling

If this skill is explicitly invoked for a trivial task, the parent MAY bypass the full workflow.

The parent should briefly explain the bypass when useful and use direct implementation when the change clearly does not benefit from delegation.

Do not force unnecessary researcher, planning, Oracle, or reviewer calls simply to satisfy a rigid stage sequence.

---

# Compliance

When this skill is explicitly invoked, the parent MUST:

- remain the workflow supervisor
- isolate artifacts under the current task directory
- use delegation where the task materially benefits from it
- avoid silently bypassing an explicitly requested specialist stage
- synthesize child findings before changing direction
- obtain user approval for material product/scope/architecture decisions
- ensure substantial implementation is reviewed before declaring completion
- keep implementation decisions traceable through the task artifacts

The parent MAY:

- skip unnecessary stages
- combine research and planning when appropriate
- omit Oracle for ordinary tasks
- omit research when required facts are already established
- use direct worker → reviewer loops for straightforward implementation
- ask the user for clarification before launching children
- escalate directly to Oracle when a difficult decision appears before a formal plan exists

---

# Example

Task:

> Add Redis caching to `get_user_stats()`.

Normal flow:

```text
scout
  ↓
identifies get_user_stats(), DB access, write paths, tests

researcher
  ↓
checks redis-py pooling, TTL, serialization

delegate
  ↓
produces implementation plan

worker
  ↓
implements approved plan

reviewer
  ↓
checks cache correctness, invalidation, failures, tests

worker
  ↓
fixes reviewer findings if necessary

reviewer
  ↓
final verification
```

Artifacts:

```text
for-ai-agents/add-redis-cache/
├── context.md
├── research.md
├── plan.md
└── progress.md
```

## Example: Oracle discovers hidden side effect

```text
delegate
  ↓
plan proposes modifying shared helper

oracle
  ↓
discovers helper mutates global state
  ↓
identifies unrelated callers affected

parent
  ↓
updates plan to use local handling

worker
  ↓
implements corrected plan

reviewer
  ↓
verifies actual diff
```

The important property is that Oracle challenges the direction before implementation, rather than acting as a second ordinary code reviewer.

## Example: Reviewer discovers root-cause problem

```text
worker
  ↓
reviewer
  ↓
finds race condition
  ↓
root cause unclear
  ↓
oracle
  ↓
explains state transition problem
  ↓
parent chooses correction
  ↓
worker
  ↓
reviewer
```

Do not restart research or planning unless the Oracle finding invalidates their assumptions.

---

# Current Built-in Roles

Use the current builtin vocabulary:

```text
scout
researcher
evidence-auditor
delegate
oracle
worker
reviewer
```

Do not assume that a separate builtin `planner` exists.

The installed runtime is authoritative if its available agents differ from documentation.

---

# References

Current pi-subagents documentation:

- Agents and builtin roles
- Workflows and orchestration
- Prompting and role selection
- Oracle and execution controls
- Review loops
- Model configuration

The workflow should follow the behavior of the installed pi-subagents version rather than relying on older `planner`, persistent fallback, or mandatory-chain semantics.
