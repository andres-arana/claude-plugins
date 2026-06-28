---
name: claude-config-profiles
description: How Claude config is structured across multiple profiles and a shared layer. Use when editing Claude Code configuration, global CLAUDE.md, settings.json, or skills under ~/.config/claude; when adding/sharing a skill across profiles; when reasoning about CLAUDE_CONFIG_DIR or why a config change affects one profile vs all of them.
---

# Claude config profiles

I run multiple isolated Claude config profiles, one per work context, selected by
pointing `CLAUDE_CONFIG_DIR` at the profile directory. For example:

- `~/.config/claude/gfw` — Global Fishing Watch
- `~/.config/claude/obs` — a separate work context

Each profile keeps its own auth, sessions, projects, history, and `settings.json`. Switching
profiles is just launching with a different `CLAUDE_CONFIG_DIR`.

## The shared layer

Content meant to be common across profiles is shared by **two different mechanisms**,
depending on the file type:

**CLAUDE.md — imported.** Each profile has its own *real* `CLAUDE.md` whose only line is a
**relative** import of the shared file at `~/.config/claude/CLAUDE.md`:

```markdown
@../CLAUDE.md
```

Claude Code resolves `@path` imports recursively when loading memory, so every profile
picks up `../CLAUDE.md`. Use a relative path (resolved against the importing file's
directory). A `~/...` home-relative import does **not** expand and silently loads nothing —
verified failing. Absolute paths work but hardcode the home dir, so prefer relative. Because the profile file is real (not a symlink), any
profile-specific instructions can be added below the import line and apply to that profile
only. Editing `~/.config/claude/CLAUDE.md` still changes every profile at once. CLAUDE.md stays on
this mechanism because plugins have **no always-on-context component** — there is no way to
ship a global CLAUDE.md as a plugin.

## How to make a change

- **Shared CLAUDE.md (all profiles)** — edit `~/.config/claude/CLAUDE.md`.
- **Profile-specific CLAUDE.md** — add instructions below the `@import` line in that
  profile's `CLAUDE.md` (e.g. `~/.config/claude/gfw/CLAUDE.md`). Or use a project-level
  `CLAUDE.md`.
- **Profile-specific skill** — create it directly under `<profile>/skills/<name>/` (not in the
  marketplace).
