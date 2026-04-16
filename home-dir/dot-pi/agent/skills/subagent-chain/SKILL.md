---
name: subagent-chain
description: Coordinate research → plan → review → implement workflow across multiple sub-agents. Use when a task benefits from specialized agents handling research, planning, review, and implementation in sequence.
---

# Subagent Chain Workflow

Decompose a complex task into a structured pipeline of specialized sub-agents: **researcher → planner → oracle → worker**. Each agent contributes its expertise, then hands off to the next.

This workflow is based on the pattern demonstrated in `update_broker_snapshots` implementation at `api.py` L652–1065.

## When to Use

Use this skill when a task involves:
- **Unknowns** requiring external research (API docs, library behavior, best practices)
- **Multi-step implementation** that benefits from a written plan before coding
- **Risk of correctness issues** that warrant a review step before execution
- **Separation of concerns** where research, planning, review, and implementation should each get focused attention from a specialized agent

Do NOT use for trivial or single-file edits where the overhead outweighs the benefit.

## Workflow

The chain has 5 stages, executed in order. Each stage produces an artifact consumed by the next.

```
Research ──► Plan ──► Review ──► Revise ──► Implement
```

### Stage 1: Research (researcher)

Delegate to `researcher` to gather external information before planning.

```
agent: "researcher"
context: "fresh"
reads: [...relevant files...]
output: "research.md"
task: "Research [specific topic]. Focus on [key questions].
      Write findings to research.md."
```

**When to use:** Tasks that depend on API docs, library behavior, third-party services, or domain knowledge not present in the codebase.

**Output:** `research.md` — structured findings with sources, code snippets, and identified gaps.

### Stage 2: Plan (planner)

Delegate to `planner` to produce a concrete implementation plan.

```
agent: "planner"
context: "fresh"
reads: [relevant files, "research.md"]
output: "plan.md"
task: "Create an implementation plan for [...]. 
      Read the research output at {chain_dir}/research.md first.
      Each task must name exact files, functions, and changes.
      Include dependencies, risks, and acceptance criteria."
```

**Output:** `plan.md` — numbered tasks, files to modify, dependencies, risks.

### Stage 3: Review (oracle)

Delegate to `oracle` to review the plan for correctness, completeness, and consistency.

```
agent: "oracle"
context: "fork"      # preserves inherited project/plan context
reads: ["plan.md", ...relevant files...]
task: "Review the plan at plan.md for [...].
      Check:
      1. Inherited decisions — does the plan honor constraints from codebase?
      2. Drift/contradiction — anything that contradicts requirements?
      3. Off-by-one errors, edge cases, and hidden assumptions
      4. Risk assessment — missing or underestimated risks?
      Provide recommendation + suggested worker execution prompt."
```

**What oracle checks:** index arithmetic (especially 0-based vs 1-based), API parameter correctness, edge cases (empty tables, missing data), alignment with codebase patterns, risk completeness.

### Stage 4: Revise (main agent)

Apply oracle's findings to the plan. This is done by the main agent, not a sub-agent.

```
Updates to plan.md:
- Fix bugs found by oracle (typically off-by-one, missing edge cases)
- Add suggested improvements (basic filter handling, column count derivation, etc.)
- Renumber tasks if inserted/removed
```

**After revision**, confirm with the user or proceed directly to implementation.

### Stage 5: Implement (worker)

Delegate to `worker` to implement the revised plan.

```
agent: "worker"
context: "fork"      # preserves project context
reads: ["plan.md", ...relevant files...]
task: "Implement the plan at plan.md.
      Critical corrections from oracle review:
      [list any bug fixes that differ from plan.md]
      
      Implementation order:
      1. [add constants/helpers]
      2. [implement function body per plan tasks]
      3. [wire up logging, retries, edge cases]
      
      Codebase patterns to follow:
      [key patterns from existing code]
      
      Files to modify:
      [exact file paths]"
```

## Concrete Example (Self-Contained)

Suppose you're asked: *"Add a cache layer using Redis to the `get_user_stats()` function."*

```
Step  Agent        Action
────  ───────────  ───────────────────────────────────────────────────
1     main agent   Read get_user_stats(), understand its DB queries,
                   data shape, and cache requirements

2     researcher   Research redis-py API for connection pools, TTL,
                   serialization patterns. Output: research.md

3     planner      Read get_user_stats() + research.md.
                   Output: plan.md with tasks:
                    - add redis config to settings
                    - init Redis client at module level
                    - wrap get_user_stats() with cache-aside pattern
                    - add invalidation on user update

4     oracle       Review plan.md. Checks:
                    - serialization edge cases (None, datetime)
                    - TTL not too short/long for this data
                    - connection pooling vs single client
                    - invalidation on correct write paths
                   Output: review finding bug (misses error
                   handling when Redis is down) + improvements

5     main agent   Apply oracle fixes: add fallback to DB,
                   try/except around cache ops. Update plan.md.

6     worker       Implement per plan.md (with oracle's
                   corrections baked into task string).
                   Files changed: config.py, db/stats.py
```

### Alternative: Chain the research→plan handoff

For simpler tasks where only research and planning are needed (no review/implement), use a chain:

```python
subagent({
    chain: [
        {"agent": "researcher",
         "task": "Research redis-py connection pooling best practices...",
         "output": "research.md"},
        {"agent": "planner",
         "task": "Design implementation plan based on {chain_dir}/research.md...",
         "output": "plan.md"},
    ]
})
```

## Tips

- **Known unknowns first**: Always start with `researcher` when the task touches an API, library, or service you haven't used recently. It's cheap insurance against planning on wrong assumptions.

- **Chain vs single**: For the research→plan handoff, use `subagent({chain: [{agent:"researcher",...}, {agent:"planner",...}]})` so planner gets `{chain_dir}/research.md` automatically. For review and implementation, use separate single-agent calls since the main agent needs to apply fixes between stages.
- **reads order**: Pass the most important file first. `reads` limits each agent's initial context to those files, so order matters.
- **context: "fork"** for oracle and worker: preserves inherited project context (codebase state, conversation history) while giving a clean reasoning slate. Use `"fresh"` for researcher and planner to avoid context bleed.
- **Be explicit in task strings**: Include the critical bug fixes and codebase patterns directly in the task, don't rely solely on the agent reading them from files.
- **progress: true** on worker: enables `progress.md` tracking during long implementations.
- **When the research reveals a fundamental misunderstanding** (e.g., "it's a Table, not a named range"), update the plan yourself rather than having the planner redo it from scratch — faster and less token waste.

## References

- Built-in agents: `context-builder`, `delegate`, `oracle`, `planner`, `researcher`, `reviewer`, `scout`, `worker`
- Chain mode: `subagent({chain: [...]})` — sequential steps with `{previous}` and `{chain_dir}` variables
- Context modes: `"fresh"` = clean slate, `"fork"` = branched from current session
- Agent output: `output: "filename"` saves to project root; `reads: [...]` loads into agent's initial context
