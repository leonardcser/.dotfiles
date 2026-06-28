# General guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When making technical decisions, do not give much weight to development cost.
  Instead, preter quality, simplicity, robustness, scalability, and long term
  maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting
  as closely aligned with how an end user would interact with the product. This
  makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be
  obsessed with pixel perfection.
- If something clearly looks off, even if it is not directly related to what you
  are doing, try to get it fixed along
- Apply that same high standard to engineering excellence: lint, test failures,
  and test flakiness. If you see one, even if it is not caused by what you are
  working on right now, still get it fixed.

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
