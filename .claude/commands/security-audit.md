---
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git log:*)
  - Bash(git remote:*)
  - Task
description: Audit the repository for malicious code, data exfiltration, or unwanted software
---

## Context

- Repository root: $ARGUMENTS
- Git remotes: !`git remote -v`

## Your task

Perform a thorough security audit of this repository. Read ALL source files, build scripts, CI/CD configs, and dependency manifests. Check for:

1. **Network activity**: Any HTTP requests, DNS lookups, socket connections, or outbound data transmission
2. **Data exfiltration**: Sensitive file reads (credentials, SSH keys, tokens, env vars), data encoding/obfuscation, or transmission to external services
3. **Unwanted software installation**: Pre/post-install hooks, download scripts, or binary drops
4. **External command execution**: Shell calls, especially to curl, wget, nc, bash -c, or eval-like patterns
5. **Obfuscated code**: Base64-encoded strings, hex-encoded payloads, minified/packed code, or steganography
6. **Dependency supply chain**: Suspicious or typosquatted packages, pinning to specific commits, or unusual registry sources
7. **Build pipeline injection**: CI/CD workflows that download or execute untrusted code, use suspicious actions, or leak secrets
8. **File system access**: Writes outside expected scope, modification of system files, or dotfile manipulation
9. **Credential harvesting**: Reading keychains, browser storage, cloud credentials, or environment variables beyond legitimate needs
10. **Hidden functionality**: Code paths that don't serve the stated purpose of the application

For each category, report either specific findings or confirm no issues were found. List every file you examined.

End with a clear **SAFE** / **SUSPICIOUS** / **MALICIOUS** verdict and a summary of all findings.
