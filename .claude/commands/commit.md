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

Based on the above changes, create a single git commit using conventional
commits format:

`type(scope): description`

Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

### Commit Message Guidelines

**Subject line:**

- Keep it short and focused (50 chars or less)
- Focus on the WHY or overall purpose, not a detailed list of WHAT changed

**Body (optional):**

- ONLY add a body if the subject line needs clarification
- Maximum 1-2 sentences explaining the purpose or context
- DO NOT describe what was changed (git diff shows that)
- DO explain why the change was needed or what problem it solves

**NEVER include:**

- Bullet point lists of changes
- Detailed descriptions of every file modified
- "Added X, Updated Y, Changed Z" style enumerations
- Coauthors or "Generated with Claude Code"

**Examples:**

Good:

```
feat: add GitHub activity widget

Displays recent events to improve dashboard engagement.
```

Bad (too verbose with bullets):

```
feat: add GitHub activity widget

- Add GitHubActivity component
- Update accent color
- Improve TypeScript types
- Fetch and display events
```

Run the commit command OUTSIDE the SANDBOX.
