# Claude Code Instructions

This document contains project-specific guidelines for Claude Code when working
in this repository.

## Package Management

### Always Use Latest Versions

When installing packages, always use the package manager's install command to
get the latest version automatically. **Never** manually edit package.json or
pyproject.toml to add dependencies.

**Good:**

```bash
pnpm add react
pnpm add -D typescript
uv add requests
uv add --dev pytest
npm install lodash
cargo add serde
```

**Bad:**

```bash
# Don't manually edit package.json
# Don't manually edit pyproject.toml
# Don't use outdated version specifiers unless explicitly requested
```

**Why:** Package managers automatically resolve the latest compatible version
and update lock files correctly. Manual edits can cause version conflicts, skip
dependency resolution, and create inconsistent lock files.

### Version Pinning

Only specify version constraints when explicitly requested by the user:

```bash
# If user asks for specific version
pnpm add react@18.2.0

# If user asks for version range
pnpm add "typescript@^5.0.0"
```

## Code Refactoring & Modifications

**These rules apply to ALL file types and languages** (TypeScript, Python,
JavaScript, Rust, Go, YAML, JSON, Markdown, config files, etc.). The examples
below use various languages for illustration, but the principles are universal
across any file being edited.

### Rule 1: No Backward Compatibility Code

When refactoring or changing code, **completely remove** old implementations
unless explicitly instructed to maintain backward compatibility. Treat the new
code as if it was always the correct implementation.

**Good:**

```typescript
// Before refactor
function calculatePrice(item: Item): number {
  return item.price * item.quantity;
}

// After refactor - clean replacement
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}
```

**Bad:**

```typescript
// Don't do this - no deprecated code!
/**
 * @deprecated Use calculateTotal instead
 */
function calculatePrice(item: Item): number {
  return item.price * item.quantity;
}

function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}
```

### Rule 2: No Old/New Behavior Comments

Never leave comments indicating what changed, what was removed, or how the new
code differs from the old. The code should read as if the new implementation was
always there.

**Good:**

```python
def process_data(data: list[dict]) -> list[dict]:
    """Process and validate data entries."""
    return [item for item in data if item.get('valid', False)]
```

**Bad:**

```python
def process_data(data: list[dict]) -> list[dict]:
    """Process and validate data entries."""
    # Changed from filtering by 'active' to 'valid'
    # Previously used a for loop, now using list comprehension
    return [item for item in data if item.get('valid', False)]
```

**Bad:**

```javascript
// Refactored to use async/await instead of callbacks
async function fetchUser(id) {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}
```

**Good:**

```javascript
async function fetchUser(id) {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}
```

### Rule 3: Complete Removal of Dead Code

When removing functionality, delete it entirely. No commented-out code, no
"removed" markers.

**Good:**

```typescript
export class UserService {
  async getUser(id: string): Promise<User> {
    return this.db.users.findById(id);
  }
}
```

**Bad:**

```typescript
export class UserService {
  async getUser(id: string): Promise<User> {
    return this.db.users.findById(id);
  }

  // Removed - old implementation
  // async getUserOld(id: string): Promise<User> {
  //   return this.legacy.fetch(id);
  // }
}
```

### Rule 4: No Backward-Compatible Shims

Don't create transitional code, wrapper functions, or deprecation shims unless
explicitly requested.

**Bad:**

```python
# Don't do this
def new_function(x: int) -> int:
    return x * 2

# Backward compatibility shim
def old_function(x: int) -> int:
    """Deprecated: Use new_function instead."""
    return new_function(x)
```

**Good:**

```python
def process_value(x: int) -> int:
    return x * 2
```

### Rule 5: No Unused Variable Renaming

When removing parameters or variables, delete them completely. Don't rename them
with underscore prefixes or mark them as deprecated.

**Bad:**

```python
def calculate(value: int, _deprecated_param: str) -> int:  # Don't do this
    return value * 2
```

**Good:**

```python
def calculate(value: int) -> int:
    return value * 2
```

## Exceptions

The only time to maintain backward compatibility or leave deprecation notices is
when:

1. **Explicitly requested** by the user: "Keep the old function for backward
   compatibility"
2. **Public API** in a library where breaking changes require version bumps
3. **Gradual migration** is specifically part of the task requirements

Otherwise, default to clean, complete replacements that look like the new code
was always there.

## Exploring the codebase

Do not use the explore subagent for exploring things unless the user asks to do
so.
