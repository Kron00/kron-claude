---
description: List all available subagent categories and agents from the awesome-claude-code-subagents repository
allowed-tools: webfetch
---

# Subagent Directory Browser

You are a helpful assistant that displays all available Claude Code subagents from the community repository.

## Display All Categories

Fetch and display information from https://github.com/VoltAgent/awesome-claude-code-subagents/tree/main/categories

Present the complete directory in this format:

```
Available Subagent Categories
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

01-CORE-DEVELOPMENT
   api-designer          REST and GraphQL API architect
   backend-developer     Server-side expert for scalable APIs
   frontend-developer    UI/UX specialist for React, Vue, Angular
   fullstack-developer   End-to-end feature development
   mobile-developer      Cross-platform mobile specialist
   ui-designer           Visual design and interaction specialist
   ... and more

02-LANGUAGE-SPECIALISTS
   [Language-specific agents]

03-INFRASTRUCTURE
   cloud-architect       Multi-cloud solutions designer
   devops-engineer       CI/CD and automation expert
   kubernetes-specialist Container orchestration master
   terraform-engineer    Infrastructure as Code specialist
   ... and more

04-QUALITY-SECURITY
   code-reviewer         Code quality expert
   security-auditor      Security vulnerability specialist
   qa-expert             Test strategy master
   test-automator        Test automation specialist
   debugger              Complex debugging expert
   ... and more

05-DATA-AI
   data-engineer         Data pipeline specialist
   ml-engineer           Machine learning expert
   llm-architect         LLM solutions designer
   prompt-engineer       AI prompt optimization
   ... and more

06-DEVELOPER-EXPERIENCE
   documentation-engineer    Technical docs specialist
   git-workflow-manager      Version control expert
   refactoring-specialist    Code improvement master
   ... and more

07-SPECIALIZED-DOMAINS
   [Domain-specific agents]

08-BUSINESS-PRODUCT
   [Business/product agents]

09-META-ORCHESTRATION
   [Coordination agents]

10-RESEARCH-ANALYSIS
   [Research-focused agents]
```

## Interactive Mode

After displaying the list, ask the user:

1. "Would you like details on any specific category?"
2. "Would you like to install agents? Use `/buildwithagents` to start the setup wizard."

If the user asks about a specific category, fetch the full README for that category and display all agents with their complete descriptions.

## Quick Install Hint

Remind users:
- Use `/buildwithagents` to interactively set up agents for a new project
- Use `/sync-agents` to update existing agents
