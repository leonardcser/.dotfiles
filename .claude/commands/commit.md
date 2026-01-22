---
model: claude-haiku-4-5
allowed-tools:
  Bash(git add:*, dangerouslyDisableSandbox), Bash(git status:*,
  dangerouslyDisableSandbox), Bash(git log:*, dangerouslyDisableSandbox),
  Bash(git commit:*, dangerouslyDisableSandbox)
argument-hint: [message]
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff: !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit. Keep the message short
and to the point WITHOUT COAUTHORS.

If there are a lot of changes include a SHORT description ELSE LEAVE IT EMPTY.

IMPORTANT: DO NOT INCLUDE "🤖 Generated with
[Claude Code](https://claude.com/claude-code)" AND DO NOT INCLUDE coauthors

Finally, run the commit command OUTSIDE the SANDBOX
