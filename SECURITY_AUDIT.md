# Security Audit - self-improving-agent (upstream) and secure rewrite

Date: 2026-03-26
Source audited: `peterskoett/self-improving-agent` (tarball `master`, extracted commit `383ec57`)

## Summary

The upstream skill is not obviously malicious, but has architectural risks around persistent prompt influence and potential sensitive-data reprocessing.

## Findings

### 1) Raw tool-output ingestion risk (High)
- File: `scripts/error-detector.sh`
- Issue: reads `CLAUDE_TOOL_OUTPUT` and pattern-matches full output.
- Risk: accidental capture/reprocessing of secrets, tokens, internal paths, or sensitive logs.
- Fix in rewrite: `error-detector.sh` now requires explicit `--summary` input and rejects long unredacted payloads.

### 2) Unreviewed persistent prompt promotion (High)
- File: `SKILL.md` workflow guidance
- Issue: encourages promotion into AGENTS/SOUL/TOOLS/CLAUDE instructions without explicit review gate.
- Risk: prompt poisoning persistence and policy drift over time.
- Fix in rewrite: promotion is staged to `.learnings/PROMOTION_CANDIDATES.md`; explicit human approval required before persistent edits.

### 3) Privileged global bootstrap injection (Medium)
- File: `hooks/openclaw/handler.{js,ts}`
- Issue: hook modifies every bootstrap context when enabled.
- Risk: broad behavior influence beyond immediate task scope.
- Fix in rewrite: reminder-only content, minimal scope, subagent skip preserved, documented as optional/disabled by default.

### 4) Path-write surface in scaffold script (Medium)
- File: `scripts/extract-skill.sh`
- Issue: had basic checks but lacked canonical path-boundary enforcement.
- Risk: edge-case workspace escape via path tricks/symlink contexts.
- Fix in rewrite: hardened relative-path validation and canonical resolved-path boundary check under current workspace.

### 5) Overly broad guidance body (Low)
- File: `SKILL.md`
- Issue: very broad automation instructions increase chance of unsafe behavior in varied environments.
- Risk: misapplied automation and over-persistence.
- Fix in rewrite: reduced and security-first instructions with explicit constraints.

## Rewrite Outcome

Created secure fork at:
`C:\Users\murdo\.openclaw\workspace\forks\self-improving-agent-secure`

Key changes:
- Security-first `SKILL.md`
- Hardened `scripts/error-detector.sh`
- Hardened `scripts/extract-skill.sh`
- Safer reminder-only `scripts/activator.sh`
- Safer optional hook handler/docs
- Added `.learnings/PROMOTION_CANDIDATES.md`

## Remaining Recommendations

- Add automated tests for script input validation.
- Add shell linting (shellcheck) in CI.
- Add SECURITY.md with disclosure process if publishing publicly.
