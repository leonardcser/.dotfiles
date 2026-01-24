---
allowed-tools:
  Bash(git diff:*, dangerouslyDisableSandbox), Bash(git status:*,
  dangerouslyDisableSandbox), Read, Edit
description: Resolve git merge conflicts
---

## Context

- Current git status: !`git status`
- Conflicted files: !`git diff --name-only --diff-filter=U`

## Your task

Resolve the git merge conflicts in the files listed above:

1. Read each conflicted file
2. Understand both sides of the conflict
3. Resolve the conflict by keeping the appropriate changes
4. Remove all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
