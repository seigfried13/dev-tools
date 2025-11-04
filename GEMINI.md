# Gemini Workspace Context: dev-tools

This directory, `dev-tools`, is a collection of projects and utilities focused on enhancing the capabilities of AI coding assistants, particularly Anthropic's Claude. It contains several distinct sub-projects, each with its own purpose and tools.

## Project Overview

This workspace is a meta-repository or monorepo containing tools for AI-assisted software development. The primary focus is on creating, managing, and using "skills" to extend the functionality of AI agents.

The main sub-projects are:
- **`anthropics/skills`**: A reference library of example skills for Claude.
- **`ccpm`**: A comprehensive project management and development workflow system for Claude Code.
- **`mcp-servers/skill-seekers`**: A powerful tool to automatically generate Claude skills from various sources like documentation, GitHub repositories, and PDFs.
- **`superpowers`**: A library of professional software engineering skills (e.g., TDD, debugging) packaged for use by AI assistants.

## Sub-Project Details

### 1. `anthropics/skills`

-   **Purpose**: Provides a collection of example "skills" that teach Claude how to perform specialized tasks. These range from creative applications (e.g., `algorithmic-art`) to technical development (e.g., `webapp-testing`) and enterprise workflows.
-   **Key Structure**: Each skill is a self-contained directory containing a `SKILL.md` file with instructions for the AI.
-   **Getting Started**: The skills can be used within Claude Code by adding the repository as a plugin marketplace.
    ```bash
    # In Claude Code
    /plugin marketplace add anthropics/skills
    /plugin install example-skills@anthropic-agent-skills
    ```

### 2. `ccpm` (Claude Code PM)

-   **Purpose**: A sophisticated, spec-driven development workflow designed for Claude Code. It turns product requirement documents (PRDs) into GitHub issues and facilitates parallel development by multiple AI agents using Git worktrees.
-   **Key Features**:
    -   Manages development from PRD to production code.
    -   Uses GitHub Issues as the source of truth.
    -   Employs specialized agents for parallel execution of tasks.
-   **Getting Started**: The system is installed into a project and then operated via a series of `/pm:*` commands.
    ```bash
    # Installation (Unix/Linux/macOS)
    curl -sSL https://automaze.io/ccpm/install | bash

    # Initialize the system in your project
    /pm:init

    # Start a new feature
    /pm:prd-new your-feature-name
    ```

### 3. `mcp-servers/skill-seekers`

-   **Purpose**: An automated tool to create production-ready Claude skills from documentation websites, GitHub repositories, and PDF files. It scrapes the source, analyzes the content, detects conflicts between docs and code, and packages it into a `.zip` file for upload to Claude.
-   **Key Features**:
    -   Supports web scraping, PDF extraction, and deep code analysis (AST parsing).
    -   Can merge multiple sources into a single, unified skill.
    -   Features conflict detection to find discrepancies between documentation and implementation.
-   **Getting Started**: It can be used as a command-line tool or via a local MCP server for natural language interaction within Claude Code.
    ```bash
    # Clone the repository
    git clone https://github.com/yusufkaraaslan/Skill_Seekers.git
    cd Skill_Seekers

    # CLI Usage Example (using a preset config)
    pip install -r requirements.txt
    python3 cli/doc_scraper.py --config configs/react.json

    # Or, set up the MCP server for Claude Code
    ./setup_mcp.sh
    ```

### 4. `superpowers`

-   **Purpose**: A library of skills that teach AI assistants proven software engineering workflows and patterns, such as Test-Driven Development (TDD), systematic debugging, and collaborative planning.
-   **Key Features**:
    -   Provides slash commands like `/superpowers:brainstorm` and `/superpowers:write-plan`.
    -   Skills activate automatically based on the task at hand.
    -   Enforces best practices and structured development processes.
-   **Getting Started**: The library is installed as a plugin from a marketplace within Claude Code.
    ```bash
    # In Claude Code
    /plugin marketplace add obra/superpowers-marketplace
    /plugin install superpowers@superpowers-marketplace
    ```

## Development Conventions

-   **AI-Centric**: All projects are designed to be used by or in conjunction with AI assistants.
-   **Modularity**: Functionality is encapsulated in "skills" or distinct command-line tools.
-   **Claude Ecosystem**: The tools are heavily integrated with the Claude Code environment and its plugin/skill system.
-   **Configuration-driven**: Projects like `skill-seekers` and `ccpm` rely on configuration files (JSON, Markdown frontmatter) to guide their operations.
