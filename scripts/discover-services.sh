#!/bin/bash
# discover-services.sh - Scan projects directory and discover services
# Run manually or via SessionStart hook

set -e

PROJECTS_DIR="$HOME/Documents/projects"
KNOWLEDGE_FILE="$HOME/.claude/KNOWLEDGE.md"

echo "Scanning $PROJECTS_DIR for services..."

# Find package.json files (Node.js projects)
find "$PROJECTS_DIR" -maxdepth 3 -name "package.json" -type f 2>/dev/null | while read -r pkg; do
    PROJECT_DIR=$(dirname "$pkg")
    PROJECT_NAME=$(basename "$PROJECT_DIR")

    # Extract info from package.json
    DESCRIPTION=$(jq -r '.description // "No description"' "$pkg" 2>/dev/null | head -c 50)

    # Detect tech stack
    TECH=""
    [ -f "$PROJECT_DIR/tsconfig.json" ] && TECH="TypeScript"
    [ -f "$PROJECT_DIR/next.config.js" ] || [ -f "$PROJECT_DIR/next.config.mjs" ] && TECH="Next.js"
    [ -f "$PROJECT_DIR/vite.config.ts" ] && TECH="Vite"
    [ -z "$TECH" ] && TECH="Node.js"

    # Detect port
    PORT=$(grep -r "PORT\|port" "$PROJECT_DIR"/*.json 2>/dev/null | grep -oE '[0-9]{4}' | head -1)
    [ -z "$PORT" ] && PORT="-"

    echo "Found: $PROJECT_NAME ($TECH) at $PROJECT_DIR"
done

# Find Python projects
find "$PROJECTS_DIR" -maxdepth 3 -name "pyproject.toml" -o -name "requirements.txt" -type f 2>/dev/null | while read -r pyfile; do
    PROJECT_DIR=$(dirname "$pyfile")
    PROJECT_NAME=$(basename "$PROJECT_DIR")

    TECH="Python"
    [ -f "$PROJECT_DIR/manage.py" ] && TECH="Django"
    [ -f "$PROJECT_DIR/app.py" ] || [ -f "$PROJECT_DIR/main.py" ] && grep -q "fastapi\|FastAPI" "$PROJECT_DIR"/*.py 2>/dev/null && TECH="FastAPI"
    [ -f "$PROJECT_DIR/app.py" ] && grep -q "flask\|Flask" "$PROJECT_DIR"/*.py 2>/dev/null && TECH="Flask"

    echo "Found: $PROJECT_NAME ($TECH) at $PROJECT_DIR"
done

# Find Go projects
find "$PROJECTS_DIR" -maxdepth 3 -name "go.mod" -type f 2>/dev/null | while read -r gomod; do
    PROJECT_DIR=$(dirname "$gomod")
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    echo "Found: $PROJECT_NAME (Go) at $PROJECT_DIR"
done

# Find Rust projects
find "$PROJECTS_DIR" -maxdepth 3 -name "Cargo.toml" -type f 2>/dev/null | while read -r cargo; do
    PROJECT_DIR=$(dirname "$cargo")
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    echo "Found: $PROJECT_NAME (Rust) at $PROJECT_DIR"
done

echo ""
echo "Discovery complete. Update KNOWLEDGE.md with findings."
