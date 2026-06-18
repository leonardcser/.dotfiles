---
description: Commit, rebase, land, and clean up a managed worktree
bash:
  allow:
    [
      "git status *",
      "git diff *",
      "git log *",
      "git branch *",
      "git add *",
      "git commit *",
      "git rebase *",
      "git checkout *",
      "git switch *",
      "git merge --ff-only *",
      "git worktree remove *",
      "git branch -d *",
      "cargo fmt *",
      "cargo test *",
      "cargo nextest *",
      "cargo clippy *",
    ]
---

## Context

- Current git status: !`git status --short --branch`
- Current branch: !`git branch --show-current`
- Relationship to main: !`git rev-list --left-right --count main...HEAD`
- Commits not on main: !`git log --oneline --decorate main..HEAD`
- Diff from main: !`git diff --stat main...HEAD`

## Your task

Finish this worktree and land it on `main`.

1. Inspect the current branch, status, diff, and recent commits.
2. If there are uncommitted relevant changes, commit them first. Match the repository's existing commit-message style.
3. Review the commits that will be landed. Confirm they are relevant to the requested work. If something still needs to be addressed, address it, validate it, and commit the follow-up.
4. Rebase the worktree branch onto `main` when the branch is behind `main` or when rebasing is needed to create a clean fast-forward landing.
5. Resolve any conflicts carefully. After conflict resolution, rerun the relevant validation and commit or continue the rebase as needed.
6. Fast-forward `main` to the rebased worktree branch. Do not create a merge commit.
7. Switch Smelt's cwd back to the base checkout before removing the worktree.
8. Remove the managed worktree.
9. Delete the finished local branch.
10. Report what was landed, what validation ran, and whether cleanup completed.

Do not push or publish anything remotely unless I explicitly ask.
