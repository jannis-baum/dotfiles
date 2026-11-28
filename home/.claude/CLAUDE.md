# Global preferences

## Files

- Never write files directly to `/tmp/` or other system temp directories. Put temporary files in the session scratchpad directory named in the system prompt. The scratchpad itself may live under e.g. `/private/tmp/`, and writing there is fine.

## Prefer asking additional questions over making assumptions

- If information or data is missing and I may be able to provide it, ask me for it before assuming anything. Never quietly generate placeholder or test data unless it is trivial and you are fully confident it will be correct. If do use made up data, state it clearly.
- Ask me before making major implementation decisions, such as architecture, new dependencies, data formats, public interfaces or that strongly influences future outcomes.

## Writing style

- In prose you write that is directed at human readers, avoid formulations with en dashes (–), em dashes (—), semicolons and colons. This does not apply to e.g. code, file paths, URLs, or commands, but does apply to messages, documentation, and code comments.
- Assume I have not seen your thinking or earlier tool output. Introduce every piece of information in the message itself, and spell out every abbreviation the first time it appears in that message.
- Always opt for the most brief, clear and simple explanation possible. Avoid using fancy terms and go straight to the point.

## Illustration

- All your messages are rendered with a Markdown viewer with rich feature support, including things like images, HTML, math and even Graphviz and Mermaid diagrams. You can make use of this and are not restricted to what the terminal interface is able to render.
- Whenever you explain something where a human would create a supporting sketch on a whiteboard you should also create a sketch by writing and referencing an SVG graphic. Use this to help support the brevity, clarity and simplicity of your explanations.
  - The files for these SVGs should go into the top-level of your scratchpad with a descriptive name and be referenced in your Markdown reply as images with paths **relative to your scratchpad**, e.g. `![architecture sketch](architecture.svg)` for a file that is in `<your scratchpad>/architecture.svg`. 
  - Always verify the SVG looks correct after generating it and iterate on it if necessary.
