---
name: jj-conventions
description: Project-specific jj conventions. Trigger when working with jj in this repository, or whenever jj/jujutsu version control is mentioned.
---

# JJ Conventions for finance_scraper

This project uses jj colocated with git. These are local conventions that supplement the standard jj workflow.

## CRITICAL: Always Run `jj new` After a Commit

**Whenever a meaningful commit is finalized, immediately run `jj new` to create a fresh empty working copy on top.**

This applies after ANY of these operations:
- `jj describe -m "message"` — sets commit message
- `jj commit -m "message"` — creates a new commit
- `jj squash` — finalizes changes into parent
- `jj absorb` — distributes changes into prior commits

The `jj new` command creates an empty working copy commit ready for the next task. This keeps the stack clean and prevents accidentally adding changes to the wrong commit.

```
# Example: commit is done, immediately create new working copy
jj describe -m "remove crypto and blockchain related code"
jj new                              # ← ALWAYS do this immediately after
```

## Quick Reference

| Operation | Command |
|-----------|---------|
| Describe commit | `jj describe -m "message"` then `jj new` |
| Create commit | `jj commit -m "message"` (already creates new WC) |
| Squash into parent | `jj squash` then `jj new` |
| Start new work | `jj new` |
| Status | `jj status` |
| Push | `jj git push` |

For the full jj reference, see the `using-jj` skill which covers philosophy, revsets, bookmarks, conflict resolution, and advanced workflows.
