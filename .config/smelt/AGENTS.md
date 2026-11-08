# General guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When making a final answer to the user, use about 80% of the way ASD-STE100
  and keep it to the point
- Don't commit unless the user explicitly instructs it.

# Design

- Do not give much weight to development cost in technical decisions. Prefer
  quality, simplicity, robustness, scalability, and long term maintainability.
- Build code cleanly and modularly, with sound architecture and separation of
  concerns. Never bolt a feature on only because it was requested.
- If the current structure has no natural place for a feature and a refactor
  would give a cleaner result, stop before you write code. Explain the problem,
  propose the refactor, and wait for the user's decision.

# Quality

- Reproduce bugs and verify fixes through the real user workflow when practical.
- When end-to-end testing a product, be picky about the UI you see and be
  obsessed with pixel perfection.
- Hold lint, test failures, and test flakiness to the same high standard. If
  something clearly looks off, even if it is not caused by or related to your
  current work, get it fixed.
- When formatting, prefer the language or tooling formatter over manual
  formatting.

## Tests

- Favor tests that protect meaningful behavior, but don't add one for every
  change. Add coverage where it reduces a real regression risk, not where it
  merely duplicates existing coverage or restates the implementation. Keep tests
  proportionate to the risk and their long-term maintenance cost.
- Test names and assertions should describe the current behavioral contract, not
  the change history or merely the absence of an old implementation.

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
