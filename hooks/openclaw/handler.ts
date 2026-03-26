import type { HookHandler } from 'openclaw/hooks';

const REMINDER_CONTENT = `## Self-Improvement Reminder (Secure)

- Log only redacted summaries to \.learnings/.
- Never paste secrets/tokens into learning logs.
- Stage promotion candidates first; require human approval before updating AGENTS/SOUL/TOOLS/MEMORY.`;

const handler: HookHandler = async (event) => {
  if (!event || typeof event !== 'object') return;
  if (event.type !== 'agent' || event.action !== 'bootstrap') return;
  if (!event.context || typeof event.context !== 'object') return;

  const sessionKey = event.sessionKey || '';
  if (sessionKey.includes(':subagent:')) return;

  if (Array.isArray(event.context.bootstrapFiles)) {
    event.context.bootstrapFiles.push({
      path: 'SELF_IMPROVEMENT_REMINDER.md',
      content: REMINDER_CONTENT,
      virtual: true,
    });
  }
};

export default handler;
