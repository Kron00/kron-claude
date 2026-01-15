#!/bin/bash
# scan-env-vars.sh - Scan projects for environment variables
# Helps document env vars across all projects

set -e

PROJECTS_DIR="$HOME/Documents/projects"

echo "Scanning for environment variables..."
echo ""

# Find .env.example files
echo "=== From .env.example files ==="
find "$PROJECTS_DIR" -maxdepth 4 -name ".env.example" -o -name ".env.sample" -o -name ".env.template" 2>/dev/null | while read -r envfile; do
    PROJECT=$(basename "$(dirname "$envfile")")
    echo ""
    echo "[$PROJECT] $envfile:"
    grep -E "^[A-Z_]+=" "$envfile" 2>/dev/null | sed 's/=.*//' | sort -u | sed 's/^/  /'
done

echo ""
echo "=== From code (process.env / os.getenv) ==="

# Scan JavaScript/TypeScript for process.env
find "$PROJECTS_DIR" -maxdepth 5 \( -name "*.js" -o -name "*.ts" -o -name "*.tsx" \) -type f 2>/dev/null | head -100 | while read -r jsfile; do
    VARS=$(grep -oE 'process\.env\.[A-Z_]+' "$jsfile" 2>/dev/null | sed 's/process\.env\.//' | sort -u)
    if [ -n "$VARS" ]; then
        PROJECT=$(echo "$jsfile" | sed "s|$PROJECTS_DIR/||" | cut -d'/' -f1)
        echo "[$PROJECT] $(basename "$jsfile"):"
        echo "$VARS" | sed 's/^/  /'
    fi
done

# Scan Python for os.getenv / os.environ
find "$PROJECTS_DIR" -maxdepth 5 -name "*.py" -type f 2>/dev/null | head -100 | while read -r pyfile; do
    VARS=$(grep -oE "os\.getenv\(['\"][A-Z_]+['\"]" "$pyfile" 2>/dev/null | sed "s/os\.getenv(['\"//" | sed "s/['\"]$//" | sort -u)
    VARS2=$(grep -oE "os\.environ\[['\"][A-Z_]+['\"]" "$pyfile" 2>/dev/null | sed "s/os\.environ\[['\"//" | sed "s/['\"]$//" | sort -u)
    ALLVARS=$(echo -e "$VARS\n$VARS2" | sort -u | grep -v '^$')
    if [ -n "$ALLVARS" ]; then
        PROJECT=$(echo "$pyfile" | sed "s|$PROJECTS_DIR/||" | cut -d'/' -f1)
        echo "[$PROJECT] $(basename "$pyfile"):"
        echo "$ALLVARS" | sed 's/^/  /'
    fi
done

echo ""
echo "Scan complete. Add relevant env vars to KNOWLEDGE.md"
