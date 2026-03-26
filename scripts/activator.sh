#!/bin/bash
# Self-Improvement reminder hook (safe mode)

set -euo pipefail

cat << 'EOF'
<self-improvement-reminder>
After task completion, optionally log redacted learnings to .learnings/.
Do not store raw tool output, secrets, or tokens.
Do not auto-promote into AGENTS/SOUL/TOOLS/MEMORY without explicit user approval.
</self-improvement-reminder>
EOF
