# Nexus Framework v3.1

## Purpose
Nexus is a unified agentic development framework for Antigravity IDE. It provides structured workflows, multi-agent orchestration, skill-based task execution, and self-learning capabilities.

## Tech Stack
- **PowerShell** — Installation scripts, CLI tools (`bin/nexus.ps1`, `install.ps1`)
- **Markdown** — Workflows, skills, agents, templates, documentation
- **JSON** — Configuration (`nexus.json`), reasoning bank

## Codebase Structure
```
H:\Kit\Nexus\
├── .agent/           # Framework core
│   ├── workflows/    # 15 workflow definitions
│   ├── skills/       # 116 skills in 14 categories
│   ├── agents/       # 6 agents + 13 shared protocols
│   ├── orchestration/# Orchestrator and memory schema
│   ├── maintenance/  # Usage logging and self-learning
│   └── templates/    # 10 project file templates
├── .nexus/           # Project state (per-project)
├── .serena/          # Serena MCP config
├── bin/              # CLI scripts
├── nexus.json        # Root config
├── GEMINI.md         # Auto-read by Antigravity
├── install.ps1       # Installer script
└── README.md         # Documentation
```

## Key Concepts
- **Bilingual**: Vietnamese for user communication, English for code/technical content
- **Workflows**: /init, /design, /plan, /execute, /verify, /review, /audit, /quick, /progress, /guide, /health, /start, /end, /learn, /evolve
- **MCP Integration**: Serena (memory), Context7 (docs), Pencil (design)
