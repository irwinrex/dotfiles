---
description: Build a compact repo/task context map before implementation
agent: context-scout
---

Build a compact context map for: $ARGUMENTS

Use the smallest useful inspection set. Prefer `git status`, `rg`, `fd`, and short file slices. Do not load dependency, generated, cache, state, lock, or log files unless directly relevant.

Return:

1. Goal
2. Relevant files
3. Build/test/deploy commands discovered
4. Risks or missing context
5. Next action
