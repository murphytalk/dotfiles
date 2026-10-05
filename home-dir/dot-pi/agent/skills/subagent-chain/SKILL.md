---
name: subagent-chain
description: Coordinate substantial development work through specialized sub-agents using requirements discovery, codebase reconnaissance, research, planning, oracle escalation, specification, GitHub Issues, implementation, TDD, and independent review. Use when a task materially benefits from delegated context gathering, external research, independent reasoning, implementation discipline, or verification.
---
# Subagent Development Workflow

Coordinate substantial development work through specialized sub-agents while keeping the parent agent as supervisor and final decision-maker.

Preferred flow:

```text
clarify/grill → scout → research/plan as needed → spec → tickets when needed
→ oracle if warranted → worker/implement + tdd → fresh reviewer → fixes if needed
```

Do not force every task through every stage.

## Requirements

If no explicit task is provided, read:

```text
for-ai-agents/todo.md
```

Treat the user's request as authoritative; use `todo.md` for additional project constraints.

## Task Isolation

Each workflow gets:

```text
for-ai-agents/<task-slug>/
```

Typical artifacts:

```text
context.md
research.md
evidence.md
spec.md
plan.md
oracle.md
progress.md
```

Never place task artifacts directly under `for-ai-agents/`.

**Do not create a local `tickets/` directory.** When ticketing is enabled, GitHub Issues are the canonical durable tickets. `progress.md` may record issue numbers/URLs, but must not duplicate issue bodies.

Sub-agents must only use the current task's artifacts unless the parent explicitly provides another artifact.

## Roles

| Agent | Purpose |
|---|---|
| `scout` | Fast codebase reconnaissance |
| `researcher` | External research |
| `evidence-auditor` | Verify important research claims |
| `delegate` | Planning, synthesis, bounded reasoning |
| `oracle` | Difficult decisions, root cause, hidden assumptions |
| `worker` | Implementation |
| `reviewer` | Independent implementation review |

`delegate` is not a mandatory planner stage. `oracle` is escalation, not ordinary review.

## Skill Integration

These are workflow disciplines, not additional agents:

| Skill | Use |
|---|---|
| `grill-with-docs` | Requirements discovery |
| `to-spec` | Durable specification |
| `to-tickets` / `to-issue` / `to-ticket` | GitHub Issues |
| `tdd` | Test-first implementation |
| `implement` | Implementation execution |

Follow the installed skill's actual name/instructions.

For substantial work:

```text
grill → scout/research → to-spec → delegate/plan
→ oracle if warranted → to-tickets → implement+tdd → reviewer
```

Skip unnecessary stages.

## Workflow

### 1. Clarify / Grill

Determine behavior, non-goals, constraints, acceptance criteria, external information needed, and decisions requiring approval.

Do not invent requirements. Ask when a material decision cannot be inferred safely.

### 2. Scout

Use for unfamiliar/non-trivial codebases.

Find relevant files/entry points, control/data flow, existing patterns, side effects, tests, risks, and unknowns.

Do not implement.

### 3. Research

Use only when external information matters: APIs, libraries, protocols, versions, compatibility, services, etc.

Prefer primary sources and distinguish facts from inference.

### 4. Evidence Audit

Use only when material decisions depend on research claims. Verify citations, versions, and unsupported assumptions.

### 5. Specification

Use `to-spec` once requirements are clear.

Store the workflow copy as:

```text
for-ai-agents/<task-slug>/spec.md
```

The spec describes agreed behavior and acceptance criteria; it does not replace the implementation plan.

### 6. Plan

For substantial work, `delegate` synthesizes the spec, findings, and relevant source into `plan.md`.

The plan identifies exact files/functions, behavior, dependencies, risks, acceptance criteria, assumptions, and scope boundaries.

For simple work, the parent may plan directly.

### 7. Oracle

Use only when an independent high-reasoning critic can materially reduce risk.

Typical triggers:

- architecture uncertainty
- hidden coupling/state
- competing strategies
- difficult API semantics
- security/concurrency/transaction concerns
- root-cause uncertainty
- expensive or hard-to-reverse decisions
- agent disagreement
- difficult review findings

Oracle challenges the plan and writes:

```text
for-ai-agents/<task-slug>/oracle.md
```

The parent decides what to adopt.

### 8. Approval

Get user approval for material changes to product behavior, scope, architecture, compatibility, irreversible data, security, or significant cost/operations.

Do not ask merely because a plan exists.

### 9. Tickets

When durable issue tracking is wanted, use `to-tickets` / equivalent to create GitHub Issues.

Issues should reflect approved scope, be actionable, contain acceptance criteria, identify dependencies, and reference parent/epic issues.

Use native blocking relationships when supported. Otherwise state dependencies in issue bodies.

Do not expand scope during decomposition.

### 10. Worker

Use `worker` after the direction is settled.

Worker reads:

```text
spec.md
plan.md
oracle.md   # if present
```

plus relevant source and the assigned GitHub Issue.

Use `implement` and `tdd` when applicable.

Worker must implement the approved direction, preserve project patterns, run appropriate tests, and stop/report if an unapproved product or architectural decision is required.

If implementation disproves the plan, report the discrepancy instead of silently redesigning it.

### 11. Review

Run a fresh `reviewer` after substantial implementation.

Review the requirements/spec, plan, Oracle findings, actual diff/state, and tests.

Check correctness, regressions, edge cases, error handling, state/concurrency behavior, tests, consistency, scope, and acceptance criteria.

Classify:

```text
P0 = must fix
P1 = fix before completion
P2 = optional
```

End with:

```text
Merge verdict: BLOCK
Merge verdict: OK
Merge verdict: OK with notes
```

Normal review does not modify files.

### 12. Fix Loop

For P0/P1:

```text
reviewer → parent synthesis → worker fix → fresh reviewer
```

Do not restart unrelated stages.

Escalate to Oracle only for difficult unresolved decisions, root causes, architectural conflicts, hidden invariants, or major trade-offs.

## Workflow Shapes

Simple:

```text
clarify → worker → reviewer
```

Unfamiliar codebase:

```text
clarify → scout → worker → reviewer
```

External dependency:

```text
clarify → scout → researcher → spec → plan → worker → reviewer
```

High-risk change:

```text
grill → scout → research → spec → plan → oracle
→ approval if needed → tickets → worker → reviewer
```

Review-discovered hard problem:

```text
worker → reviewer → oracle → parent decision → worker → reviewer
```

Do not rerun unrelated stages unless their assumptions became invalid.

## Artifact Handoffs

When delegating:

1. Give the exact task directory.
2. Name the artifacts to read.
3. Put critical corrections directly in the prompt.
4. Keep handoffs concise.
5. Pass the exact GitHub Issue when one exists.
6. Do not duplicate complete issue bodies locally.
7. Never use another task's artifacts unless explicitly requested.

Use task artifacts rather than relying on inherited conversation context.

## Context

Use `fresh` when independence matters:

```text
researcher
evidence-auditor
delegate
reviewer
```

Use `fork` when continuity helps:

```text
oracle
worker
```

Explicit artifact handoff is still required.

## Model Strategy

This skill is **model/provider agnostic**.

Never hard-code model names or providers into workflow logic, and never depend on `fallbackModels`.

Configure models by capability:

```text
scout             fast / cheap
researcher        reliable research
evidence-auditor  independent verification
delegate          capable planning/reasoning
oracle            strongest reasoning
worker            cost-effective coding
reviewer          strong independent review
```

Prefer model diversity between planning, implementation, and review when practical, but correctness, reliability, cost, and availability come first.

All concrete model choices belong in Pi/runtime configuration.

### Model Selection and Failure

The parent selects the model for each role according to the active Pi configuration.

If a selected model fails:

1. Retry the same model up to **2 additional times**.
2. If it still fails, identify a model with the **same role/capability name** from another configured provider, if one exists.
3. Present that alternative to the user and **ask for approval before switching**.
4. Never select or switch to another provider/model autonomously.

A model/provider failure must not silently change the configured model strategy.

## Failure / Recovery

If a child fails:

1. Inspect the actual failure.
2. Retry the configured model up to 2 additional times.
3. If retries fail, ask the user before using an alternative configured provider/model.
4. Preserve useful artifacts.
5. Escalate unresolved task decisions to the parent/user.

Do not confuse provider failure with task-quality failure.

## Small Tasks

For trivial changes, bypass the full workflow.

Use only stages that materially improve correctness.

## Compliance

When invoked, the parent must:

- remain supervisor/final decision-maker
- isolate task artifacts
- use appropriate delegation
- synthesize child findings
- obtain approval for material decisions
- review substantial implementation
- keep decisions traceable
- use `spec.md` when applicable
- use GitHub Issues as canonical tickets when ticketing is enabled
- never create a parallel local `tickets/` system

The parent may skip unnecessary stages or combine compatible stages.

## Example

For a substantial feature:

```text
grill
  ↓
scout
  ↓
researcher
  ↓
to-spec → spec.md
  ↓
delegate → plan.md
  ↓
oracle (if warranted)
  ↓
to-tickets → GitHub Issues
  ↓
implement + tdd
  ↓
reviewer
  ↓
worker fix + fresh reviewer if needed
```

The parent supervises the sequence; roles provide specialized work rather than independent authority.
