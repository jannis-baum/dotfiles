# Global preferences

## Files

- Never write files directly to `/tmp/` or other system temp directories. Put temporary files in the session scratchpad directory named in the system prompt. The scratchpad itself may live under e.g. `/private/tmp/`, and writing there is fine.

## Writing style

- In prose you write that is directed at human readers, avoid formulations with en dashes (–), em dashes (—), semicolons and colons. This does not apply to e.g. code, file paths, URLs, or commands, but does apply to messages, documentation, and code comments.
- Assume I have not seen your thinking or earlier tool output. Introduce every piece of information in the message itself, and spell out every abbreviation the first time it appears in that message.

## Prefer asking additional questions over making assumptions

- If information or data is missing and I may be able to provide it, ask me for it before assuming anything. Never quietly generate placeholder or test data unless it is trivial and you are fully confident it will be correct. If do use made up data, state it clearly.
- Ask me before making major implementation decisions, such as architecture, new dependencies, data formats, public interfaces or that strongly influences future outcomes.
