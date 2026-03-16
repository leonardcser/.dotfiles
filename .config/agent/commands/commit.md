---
description: Create a git commit
bash:
  allow: ["git add *", "git status *", "git log *", "git commit *", "git diff *", "git branch *"]
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

IMPORTANT: Create ONLY a subject line. NO body. NO coauthors. NO description.

- Subject line only
- Focus on the WHY or overall purpose, not WHAT changed

**Good:**

```
feat(auth): add OAuth2 support for Google login
```

**Bad:**

```
feat(auth): add OAuth2 support for Google login

This commit adds OAuth2 authentication flow for Google login. Users can now
sign in with their Google account instead of creating a new password.

- Add GoogleAuthProvider class
- Update login page with Google button
- Store OAuth tokens in session

Co-Authored-By: Claude <noreply@anthropic.com>
```
