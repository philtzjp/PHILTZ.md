---
description: git commit、コミットメッセージ作成を扱うとき
alwaysApply: false
---

# Commit Messages

1. MUST use the format `type: description (in Japanese, short sentence)`
2. MUST perform a dry run (`git commit --dry-run`) before committing, present the commit message to the user, and MUST only execute after receiving approval
3. NEVER add `Co-Authored-By`

| Prefix | Usage |
|---|---|
| `feat` | Adding a new feature |
| `fix` | Bug fix |
| `perf` | Performance improvement |
| `refactor` | Code improvement without functional changes |
| `docs` | Documentation changes |
| `style` | Code style fixes |
| `test` | Adding or modifying tests |
| `chore` | Miscellaneous tasks |
| `ci` | CI/CD configuration changes |
| `build` | Build configuration changes |
