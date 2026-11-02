# General guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When making technical decisions, do not give much weight to development cost.
  Instead, preter quality, simplicity, robustness, scalability, and long term
  maintainability.
- Reproduce bugs and verify fixes through the real user workflow when practical.
- Favor tests that protect meaningful behavior, but don't add one for every
  change. Add coverage where it reduces a real regression risk, not where it
  merely duplicates existing coverage or restates the implementation. Keep tests
  proportionate to the risk and their long-term maintenance cost. Test names and
  assertions should describe the current behavioral contract, not the change
  history or merely the absence of an old implementation.
- When end-to-end testing a product, be picky about the UI you see and be
  obsessed with pixel perfection.
- If something clearly looks off, even if it is not directly related to what you
  are doing, try to get it fixed along
- Apply that same high standard to engineering excellence: lint, test failures,
  and test flakiness. If you see one, even if it is not caused by what you are
  working on right now, still get it fixed.
- When formatting, prefer using the language or tooling to format instead of
  manually formatting
- When making a final answer to the user, use about 80% of the way ASD-STE100
  and keep it to the point

# Commit messages

`type(scope): summary`, subject at most 60 characters.

- For breaking changes, use `type(scope)!: summary` and add a brief
  `BREAKING CHANGE: ...` footer explaining what changed.
- Otherwise, use the subject only.
- Imperative. No articles, possessives or filler words.
- One change. No "and", "so ..." or "by ..." clauses.
- Say what changed for users, not how.

Example: `perf(test): cut suite time 4x`, not `perf(test): cut suite time 4x by
optimizing the test profile and removing real-time waits`.

# Exploration

When exploring a thirdparty dependency or an external GitHub repository,
shallow-clone it into `/tmp` to keep things clean:

```bash
git clone --depth 1 https://github.com/<owner>/<repo>.git /tmp/<repo>
```

# Tasks

If the user asks your to address a task and provides you and id like
`20260331-010713`, use the task cli: `task --help`. If your are in a worktree,
your should look in the root project original path. You should update it when
you start working on it and if you complete it.
