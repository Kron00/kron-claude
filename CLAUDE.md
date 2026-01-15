# CLAUDE.md

This file provides guidance to Claude Code when working with code.

<critical-rules>

## CRITICAL: Plan Mode Requirement

**YOU MUST use EnterPlanMode before starting ANY task that involves:**
- Writing or editing code
- Creating or modifying files
- Multi-step operations
- Anything that changes the codebase

**The ONLY exceptions (direct action allowed):**
- Single-line typo fixes
- Reading a specific file the user named
- Answering a pure question with no action required

If uncertain whether plan mode is needed: **USE PLAN MODE.**

</critical-rules>

<question-policy>

## Question Policy - IMPORTANT

**DO NOT ask excessive questions.** Assume reasonable defaults and act.

**Only ask questions when:**
- Requirements are genuinely ambiguous with multiple valid interpretations
- A decision has significant, hard-to-reverse consequences
- The user explicitly asked for options or input
- Critical information is missing that cannot be reasonably inferred

**NEVER ask about:**
- Formatting preferences (use project conventions or sensible defaults)
- Standard patterns (just use them)
- Things inferrable from context, codebase, or common sense
- Edge cases that can be handled with reasonable defaults
- Confirmation of obvious next steps

**When uncertain about minor details:** Make the sensible choice, proceed, and mention what you chose. The user can correct if needed.

**Default behavior:** Act decisively. A wrong guess that's quickly corrected is better than endless clarification questions.

</question-policy>

<agent-usage>

## IMPORTANT: Parallel Agent-First Workflow

Preserve main context window by delegating to specialized agents. The main conversation is for coordination and synthesis only.

### Parallel Execution - ALWAYS USE 5 AGENTS

**YOU MUST launch up to 5 Task agents in parallel whenever possible.**

- Use a SINGLE message with multiple Task tool calls for parallel execution
- Split work into independent dimensions that can run concurrently
- Only run sequentially when one agent's output is required for another's input
- More agents = faster results

**Example parallel patterns:**
- Research: 5 agents exploring different aspects simultaneously
- Codebase exploration: 5 agents searching different directories/patterns
- Implementation: 5 agents working on independent files/components

### Agent Selection Table

| Task Type | Agent to Use |
|-----------|--------------|
| Codebase exploration | Task + Explore agent (quick/medium/thorough) |
| Multi-faceted research | Task + deep-research agent |
| Implementation planning | Task + Plan agent |
| Complex multi-step work | Task + general-purpose agent |
| Git operations | Task + Bash agent |

### Parallel Research Pattern

For questions requiring information gathering:
1. Identify 5 distinct research dimensions immediately
2. Launch ALL 5 Task agents in a SINGLE message
3. Each agent uses different search strategies/sources
4. Synthesize findings in main context after all agents complete

### When NOT to Use Agents

- Reading a specific file the user explicitly named → direct Read tool
- Single trivial operation → direct tool call
- Information already in current context → no delegation needed

</agent-usage>

<memory-system>

## Memory & Knowledge System

Claude uses a persistent knowledge system to remember services, track changes, and maintain context.

### Knowledge File
Location: `~/.claude/KNOWLEDGE.md`

This file contains:
- **Services Registry**: All services, their tech stacks, ports, and paths
- **Environment Variables**: Documented env vars across projects
- **Recent Changes Log**: Auto-logged changes from hooks
- **Decisions Made**: Architectural decisions and their rationale

### Updating Knowledge

When you discover new information about the user's setup:
1. Update KNOWLEDGE.md with the new information
2. Keep entries concise and structured
3. Include timestamps for changes

### Auto-Logging

PostToolUse hooks automatically log changes to KNOWLEDGE.md when files are edited or created.

</memory-system>

<skills-system>

## Skills System

Skills are self-contained instruction sets Claude automatically loads when relevant.

### Skill Locations
- **Global:** `~/.claude/skills/skill-name/SKILL.md`
- **Project:** `.claude/skills/skill-name/SKILL.md`

### Installed Skills
- `/document` - Generate documentation, READMEs, API docs
- `/code-review` - Review code for bugs, security, performance
- `/test-runner` - Run tests and fix failures
- `/git-workflow` - Handle git operations safely

### Creating Skills
- Keep SKILL.md under 500 lines
- Write trigger-rich descriptions for semantic matching
- 90% deterministic scripts, 10% LLM instructions
- Include examples of good and bad patterns

</skills-system>

<hooks-system>

## Lifecycle Hooks

Hooks automate actions in response to Claude Code events.

### 9 Hook Events
1. **SessionStart** - Session begins
2. **UserPromptSubmit** - User sends message
3. **PreToolUse** - Before tool executes
4. **PostToolUse** - After tool completes
5. **Notification** - Claude sends alert
6. **Stop** - Agent finishes response
7. **ToolError** - Tool execution fails
8. **SessionEnd** - Session terminates
9. **SkillInvoke** - Skill activated

### Active Hooks
- **PostToolUse (Edit|Write)**: Logs changes to KNOWLEDGE.md

</hooks-system>

<mcp-integration>

## Model Context Protocol (MCP)

MCP connects Claude to external tools, databases, and APIs.

### Recommended MCP Servers
- **claude-mem**: Auto-capture and inject context across sessions
- **mcp-memory-keeper**: Simple persistent storage
- **mcp-memory-service**: Semantic search with AI embeddings

### Adding MCP Servers
```bash
claude mcp add --transport http <name> <url>
```

</mcp-integration>

<sandboxing>

## Security Sandboxing

Enable with `/sandbox` command for untrusted codebases.

### Isolation Boundaries
- **Filesystem:** Restrict to specific directories
- **Network:** Whitelist allowed domains

</sandboxing>

<code-changes>

## Code Changes

- Make minimal, focused changes - only what was explicitly requested
- Never add features, refactoring, or "improvements" beyond the ask
- Read files before editing - never assume contents
- Follow existing patterns in the codebase
- No unnecessary abstractions - three similar lines beat a premature helper
- Delete unused code completely - no backwards-compatibility hacks

## What NOT to Add

- No docstrings/comments/type annotations to code you didn't change
- No new documentation files unless explicitly requested
- No error handling for scenarios that can't happen
- No feature flags or configuration for one-time changes

</code-changes>

<project-settings>

## Project Location

- New projects go in `~/Documents/projects/`
- Use lowercase for project directory names

## Communication

- Keep responses brief and concise
- Use markdown formatting sparingly
- Be specific about file paths and line numbers

</project-settings>

<mistakes-log>

## Mistakes to Avoid

Document recurring issues here so they don't repeat:
- (Add mistakes as they occur)

</mistakes-log>

<workflow>

## Workflow Summary

1. **Enter plan mode** (EnterPlanMode) for any non-trivial task
2. **Launch 5 parallel agents** for research/exploration
3. **Assume reasonable defaults** - don't over-question
4. **Execute with TodoWrite tracking**
5. **Update KNOWLEDGE.md** with new discoveries
6. **Document mistakes** in mistakes-log section

</workflow>
