#!/bin/bash
# Secure error detector
# Purpose: detect likely error signatures from a user-provided summary string.
# Security: does NOT read raw tool output env vars.

set -euo pipefail

usage() {
  cat << 'EOF'
Usage: ./error-detector.sh --summary "short redacted summary"

Notes:
- Pass only a short, redacted summary.
- Do not pass full logs, stack dumps, or command output containing secrets.
EOF
}

SUMMARY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --summary)
      SUMMARY="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$SUMMARY" ]]; then
  echo "--summary is required" >&2
  exit 1
fi

if [[ ${#SUMMARY} -gt 500 ]]; then
  echo "Summary too long; keep <= 500 chars and redacted" >&2
  exit 1
fi

LOWER=$(printf '%s' "$SUMMARY" | tr '[:upper:]' '[:lower:]')
PATTERNS=("error" "failed" "exception" "traceback" "permission denied" "no such file" "timeout" "fatal")

contains_error=false
for p in "${PATTERNS[@]}"; do
  if [[ "$LOWER" == *"$p"* ]]; then
    contains_error=true
    break
  fi
done

if [[ "$contains_error" == true ]]; then
  cat << 'EOF'
<error-detected>
Potential error pattern detected from summarized text.
If useful for future sessions, log a redacted entry in .learnings/ERRORS.md.
</error-detected>
EOF
fi
