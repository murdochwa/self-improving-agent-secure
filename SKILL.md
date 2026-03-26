---
name: self-improving-agent-secure
description: "Capture learnings, errors, and feature requests with a security-first workflow. Use when you want continuous improvement logs without unsafe automatic ingestion of raw tool output or automatic persistence into AGENTS/SOUL/TOOLS/MEMORY files."
---

# Self-Improving Agent (Secure Rewrite)

Use this skill to log useful learnings while minimizing prompt-persistence and secret-leak risks.

## Security Defaults

- Do not ingest raw tool output automatically.
- Do not auto-write to `AGENTS.md`, `SOUL.md`, `TOOLS.md`, `MEMORY.md`, or other long-term context files.
- Keep hook behavior optional and reminder-only.
- Require explicit human review before promoting any learning into persistent guidance.
- Keep all writes under workspace-relative `.learnings/`.

## Quick Reference

- Command failed unexpectedly -> log to `.learnings/ERRORS.md` (summarized, redacted)
- User corrected behavior/facts -> log to `.learnings/LEARNINGS.md`
- User requested missing capability -> log to `.learnings/FEATURE_REQUESTS.md`
- Recurring pattern (>=3 occurrences across tasks) -> stage promotion proposal only

## Logging Rules

1. Redact secrets before writing.
2. Prefer concise summaries over raw command dumps.
3. Store only what is needed to reproduce/fix.
4. Link related entries with `See Also`.

## Safe Promotion Workflow

When a learning appears broadly useful:

1. Create a proposal in `.learnings/PROMOTION_CANDIDATES.md`
2. Include:
   - target file (`AGENTS.md`/`SOUL.md`/`TOOLS.md`)
   - short candidate rule
   - rationale + references
3. Wait for explicit user approval before editing persistent files.

## Scripts

- `scripts/activator.sh`: prints a short reminder block.
- `scripts/error-detector.sh`: analyzes explicit, summarized error text passed by argument; does **not** read raw `CLAUDE_TOOL_OUTPUT`.
- `scripts/extract-skill.sh`: scaffolds a new skill with stricter path checks.

## Optional Hook

Hook support is optional and disabled by default. If enabled, use reminder-only mode.
See `references/openclaw-integration.md`.
