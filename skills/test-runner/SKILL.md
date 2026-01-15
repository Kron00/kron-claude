---
name: test-runner
description: Run tests, analyze failures, and fix broken tests. Use when asked to test, run tests, fix tests, or debug test failures.
---

# Test Runner Skill

Execute tests and systematically resolve failures.

## Test Frameworks Detection

Detect framework from project files:
- `package.json` → Jest, Vitest, Mocha, Playwright
- `pytest.ini` / `pyproject.toml` → pytest
- `Cargo.toml` → cargo test
- `go.mod` → go test
- `*.test.ts/js` files → JavaScript testing

## Workflow

### 1. Run Tests
```bash
# JavaScript/TypeScript
npm test
npm run test -- --watch=false

# Python
pytest -v
python -m pytest

# Go
go test ./...

# Rust
cargo test
```

### 2. Analyze Failures
For each failing test:
1. Identify the assertion that failed
2. Compare expected vs actual values
3. Trace back to the source of the discrepancy
4. Check if it's a test bug or implementation bug

### 3. Fix Strategy
- **Test bug:** Update test expectations
- **Implementation bug:** Fix the code, re-run tests
- **Flaky test:** Identify race condition or timing issue

### 4. Verification Loop
1. Make fix
2. Run failing test only: `npm test -- --testNamePattern="test name"`
3. If passes, run full suite
4. Repeat until all green

## Output Format

```markdown
## Test Results

**Status:** X passing, Y failing

### Failures
1. `test name` - [reason for failure]
   - Expected: X
   - Actual: Y
   - Fix: [what needs to change]

### Actions Taken
- [Fix 1]
- [Fix 2]

### Final Status
All tests passing / X tests still failing
```

## Instructions

1. Always run tests before claiming they pass
2. Fix one test at a time
3. Re-run after each fix to verify
4. Don't modify tests just to make them pass (unless test is wrong)
