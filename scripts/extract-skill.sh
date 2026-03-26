#!/bin/bash
# Skill Extraction Helper (hardened)
# Creates a new skill scaffold from a learning entry.

set -euo pipefail

SKILLS_DIR="./skills"
SKILL_NAME=""
DRY_RUN=false

usage() {
  cat << EOF
Usage: $(basename "$0") <skill-name> [options]

Options:
  --dry-run                 Show output without creating files
  --output-dir <rel-path>   Relative output directory (default: ./skills)
  -h, --help                Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --output-dir)
      [[ -n "${2:-}" ]] || { echo "--output-dir requires value" >&2; exit 1; }
      SKILLS_DIR="$2"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *)
      if [[ -z "$SKILL_NAME" ]]; then SKILL_NAME="$1"; shift; else echo "Unexpected arg: $1" >&2; exit 1; fi
      ;;
  esac
done

[[ -n "$SKILL_NAME" ]] || { echo "Skill name required" >&2; exit 1; }
[[ "$SKILL_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Invalid skill name" >&2; exit 1; }

# Reject absolute, parent traversal, or backslash traversal on POSIX shells.
if [[ "$SKILLS_DIR" = /* ]] || [[ "$SKILLS_DIR" == *".."* ]] || [[ "$SKILLS_DIR" == *"\\"* ]]; then
  echo "Unsafe output-dir. Use a clean relative path under current directory." >&2
  exit 1
fi

mkdir -p "$SKILLS_DIR"
ROOT_REAL=$(pwd -P)
OUT_REAL=$(cd "$SKILLS_DIR" && pwd -P)

case "$OUT_REAL" in
  "$ROOT_REAL"* ) ;;
  * ) echo "Resolved output path escapes current workspace" >&2; exit 1 ;;
esac

SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"

if [[ -d "$SKILL_PATH" && "$DRY_RUN" = false ]]; then
  echo "Skill already exists: $SKILL_PATH" >&2
  exit 1
fi

if [[ "$DRY_RUN" = true ]]; then
  echo "Would create: $SKILL_PATH/SKILL.md"
  exit 0
fi

mkdir -p "$SKILL_PATH"
cat > "$SKILL_PATH/SKILL.md" << TEMPLATE
---
name: $SKILL_NAME
description: "TODO: concise description + trigger conditions"
---

# ${SKILL_NAME//-/ }

## Purpose
TODO

## Safe Defaults
- Review-gated persistence
- Redacted logging

## Source Learning
- Learning ID: TODO
- Source File: .learnings/LEARNINGS.md
TEMPLATE

echo "Created $SKILL_PATH/SKILL.md"
