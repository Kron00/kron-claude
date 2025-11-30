# kron-claude

A portable Claude Code tools repository for quickly setting up AI-powered development environments on any machine.

## What is this?

This repository contains a curated set of Claude Code slash commands that help you:

1. **Discover** the best subagents for your project type
2. **Install** and configure them with project-specific customizations
3. **Maintain** and update your Claude Code setup over time

## Quick Start

```bash
# Clone this repo
git clone https://github.com/Kron00/kron-claude.git

# Copy the commands to your project
cp -r kron-claude/.claude/commands /path/to/your/project/.claude/

# Or use it directly - cd into your project and run:
claude
# Then use: /buildwithagents
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/buildwithagents` | Interactive wizard to install subagents tailored to your project |
| `/init-project` | Initialize a new project with CLAUDE.md and configuration |
| `/list-agents` | Browse all available subagents from the community repository |
| `/sync-agents` | Update installed agents while preserving customizations |
| `/update` | Update Claude Code to the latest version |
| `/quick-start` | Display the quick start guide |

## How It Works

### 1. Project Analysis
When you run `/buildwithagents`, Claude will ask you about:
- What type of project you're building
- Your tech stack
- Your main concerns (performance, security, testing, etc.)
- Whether it's a new or existing project

### 2. Agent Recommendations
Based on your answers, Claude recommends agents from 10 categories:

```
01-core-development     → fullstack, frontend, backend, API designers
02-language-specialists → language-specific experts
03-infrastructure       → DevOps, cloud, Kubernetes, Terraform
04-quality-security     → testing, security, code review
05-data-ai              → ML, data engineering, LLM architecture
06-developer-experience → docs, refactoring, tooling
07-specialized-domains  → domain-specific experts
08-business-product     → product and business agents
09-meta-orchestration   → coordination agents
10-research-analysis    → research-focused agents
```

### 3. Customization
Each agent is fetched from the [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) repository and customized for your specific:
- Tech stack
- Project conventions
- Team preferences

### 4. Installation
Agents are saved to your project's `.claude/agents/` directory, ready to use.

## Directory Structure

```
kron-claude/
├── README.md
└── .claude/
    └── commands/
        ├── buildwithagents.md   # Main setup wizard
        ├── init-project.md      # Project initialization
        ├── list-agents.md       # Agent directory browser
        ├── sync-agents.md       # Agent updater
        ├── update.md            # Claude Code updater
        └── quick-start.md       # Help guide
```

## Example Usage

### Setting up a new React + Node.js project:

```
> /buildwithagents

Claude: What type of project are you building?
You: A full-stack web app with React frontend and Node.js backend

Claude: What's your tech stack?
You: React 18, TypeScript, Express, PostgreSQL, Jest

Claude: What are your main concerns?
You: Performance, testing coverage, and clean architecture

Claude: Here are my recommendations:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Core:     fullstack-developer, frontend-developer, backend-developer
Quality:  code-reviewer, test-automator, performance-engineer
DevOps:   devops-engineer
Optional: documentation-engineer, security-auditor

Would you like me to install these agents?
```

## Keeping Up to Date

```bash
# Update your agents to latest versions
/sync-agents

# Update Claude Code itself
/update
```

## Contributing

Found a useful agent configuration? Have ideas for new commands? Contributions welcome!

## Source

Agents are sourced from the community-maintained [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) repository.

## License

MIT
