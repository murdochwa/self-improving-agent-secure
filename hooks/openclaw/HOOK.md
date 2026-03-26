---
name: self-improving-agent-secure-hook
description: "Optional reminder-only bootstrap hook for secure learning capture"
metadata: {"openclaw":{"emoji":"🧠","events":["agent:bootstrap"]}}
---

# Secure Self-Improvement Hook

Optional, reminder-only hook.

## Security Behavior

- Injects a short virtual reminder file during `agent:bootstrap`.
- Does not read tool output.
- Does not write persistent memory files.
- Intended to stay disabled unless explicitly enabled by the operator.

## Enable

```bash
openclaw hooks enable self-improving-agent-secure-hook
```
