---
description: commit, rebase, land, and clean up a managed worktree
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

1. If there are uncommitted relevant changes, commit them first.
2. Review the commits that will be landed. Confirm they are relevant to the
   requested work. If something still needs to be addressed, address it,
   validate it, and commit the follow-up.
3. Rebase the worktree branch onto `main` when the branch is behind `main` or
   when rebasing is needed to create a clean fast-forward landing.
4. Resolve any conflicts carefully. After conflict resolution, rerun the
   relevant validation and commit or continue the rebase as needed.
5. Fast-forward `main` to the rebased worktree branch. Do not create a merge
   commit.
6. Switch Smelt's cwd back to the base checkout before removing the worktree.
7. Remove the managed worktree.
8. Delete the finished local branch.
9. Just stop and answer with a sentence.

Do not push or publish anything remotely unless I explicitly ask.
