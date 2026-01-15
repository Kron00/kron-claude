---
name: document
description: Generate documentation for code including README files, API documentation, function docs, and project documentation. Use when asked to document, create README, write docs, or explain code for documentation purposes.
---

# Document Generation Skill

Generate comprehensive, well-structured documentation for codebases.

## When This Skill Applies

- User asks to "document" something
- User requests a README file
- User wants API documentation
- User asks for function/module documentation
- User wants to explain code for others

## Documentation Types

### 1. README Generation

For project READMEs, include:

```markdown
# Project Name

Brief description (1-2 sentences)

## Features
- Key feature 1
- Key feature 2

## Installation
Step-by-step setup instructions

## Usage
Code examples showing common use cases

## Configuration
Environment variables and options

## API Reference (if applicable)
Endpoint documentation

## Contributing
How to contribute

## License
License information
```

### 2. API Documentation

For APIs, document each endpoint:

```markdown
## Endpoint Name

**Method:** GET/POST/PUT/DELETE
**Path:** `/api/resource`

### Request
- Headers: Required headers
- Body: Request body schema with examples

### Response
- Success (200): Response schema
- Error (4xx/5xx): Error response format

### Example
curl command or code example
```

### 3. Function/Module Documentation

For code documentation:

```markdown
## Function Name

Brief description of what it does.

### Parameters
- `param1` (type): Description
- `param2` (type, optional): Description. Default: value

### Returns
- (type): Description of return value

### Raises/Throws
- `ErrorType`: When this error occurs

### Example
Code example showing usage
```

## Instructions

1. **Analyze the codebase** first - understand structure, patterns, dependencies
2. **Identify the audience** - developers, end-users, or both
3. **Use existing conventions** - match the project's documentation style if present
4. **Include working examples** - test code snippets before documenting
5. **Be concise** - developers skim documentation
6. **Add badges** for README files (build status, version, license)
7. **Use proper markdown** - headings, code blocks, tables where helpful

## Output Guidelines

- Use clear, direct language
- Start with the most important information
- Include a table of contents for long documents (10+ sections)
- Use mermaid diagrams for architecture (when helpful)
- Syntax-highlight all code blocks with language tags
- Keep examples minimal but complete

## What NOT to Do

- Don't document obvious code (self-documenting names)
- Don't add excessive detail for simple functions
- Don't create documentation files unless explicitly requested
- Don't use jargon without explanation
