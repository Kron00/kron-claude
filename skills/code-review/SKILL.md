---
name: code-review
description: Review code for bugs, security issues, performance problems, and style. Use when asked to review, audit, check, or critique code.
---

# Code Review Skill

Perform thorough code reviews focusing on correctness, security, and maintainability.

## Review Checklist

### 1. Correctness
- Logic errors and edge cases
- Off-by-one errors
- Null/undefined handling
- Error handling completeness
- Race conditions (async code)

### 2. Security (OWASP Top 10)
- Injection vulnerabilities (SQL, command, XSS)
- Authentication/authorization flaws
- Sensitive data exposure
- Insecure deserialization
- Missing input validation

### 3. Performance
- N+1 queries
- Unnecessary re-renders (React)
- Memory leaks
- Inefficient algorithms
- Missing caching opportunities

### 4. Maintainability
- Code duplication
- Complex conditionals
- Missing error messages
- Unclear naming
- Dead code

## Output Format

```markdown
## Code Review: [file/component name]

### Critical Issues
- [Issue]: [Location] - [Explanation and fix]

### Warnings
- [Issue]: [Location] - [Explanation]

### Suggestions
- [Improvement]: [Location] - [Rationale]

### Summary
[1-2 sentence overall assessment]
```

## Instructions

1. Read the entire file/PR before commenting
2. Prioritize: Critical > Warnings > Suggestions
3. Explain WHY something is an issue
4. Provide concrete fix suggestions
5. Acknowledge good patterns found
6. Be constructive, not nitpicky
