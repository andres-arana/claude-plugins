---
name: spec-writer
description: Use when you want to turn a feature idea or suggestion into a full specification. Activates when the user asks to "write a spec", "create a specification", "spec out a feature", "spec this", or wants to define requirements for a feature before implementation.
---

# Spec Writer

Turn a feature idea into a complete, unambiguous specification through iterative clarification.

## Behavior

When this skill activates:

1. **Ground in the codebase first.** Explore the relevant code, conventions, and existing patterns before asking anything. Resolve every ambiguity you can from the repo. Only ask the user what the code cannot answer.
2. **Identify** every remaining decision point, ambiguity, and edge case.
3. **Ask** about them — using the `AskUserQuestion` tool for batched multiple-choice decisions, grouped by theme. Propose sensible defaults so the user can accept or override quickly. Fall back to free-text questions only when options don't fit.
4. **Never assume silently.** If something could go multiple ways and the code doesn't settle it, ask.
5. After each round of answers, update your understanding and ask any follow-up questions that surface.
6. **Get sign-off.** Once decisions are resolved, present a draft spec and get explicit user approval before finalizing.
7. **Write the spec to a file.** Default to `specs/<feature-name>.md` (create the directory if needed). Confirm the path with the user; honor any existing spec convention in the repo.

## Final Spec Format

The completed spec must cover:
- **Behavior**: What the feature does, end-to-end
- **Inputs/Outputs**: What goes in and what comes out
- **Edge cases**: Boundary conditions and unusual inputs
- **Error handling**: What happens when things go wrong
- **Constraints/Non-goals**: Explicit scope boundaries from the conversation

## Rules

- Do not implement anything.
- Do not suggest implementation approaches unless the user asks. Proposing *behavioral* defaults during clarification is fine; proposing *how to build it* is not.
- Do not make assumptions — resolve from the codebase, or ask.
