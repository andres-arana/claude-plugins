---
name: claude-config-profiles
description: How Andres's Claude config is structured across multiple profiles and a shared layer. Use when editing Claude Code configuration, global CLAUDE.md, settings.json, or skills under ~/.config/claude; when adding/sharing a skill across profiles; when reasoning about CLAUDE_CONFIG_DIR or why a config change affects one profile vs all of them.
---

# Claude config profiles

Andres runs multiple isolated Claude config profiles, one per work context, selected by
pointing `CLAUDE_CONFIG_DIR` at the profile directory:

- `~/.config/claude/gfw` — Global Fishing Watch
- `~/.config/claude/obs` — a separate work context

Each profile keeps its own auth, sessions, projects, history, and `settings.json`. Switching
profiles is just launching with a different `CLAUDE_CONFIG_DIR`.

## The shared layer

Content meant to be common across profiles is shared by **two different mechanisms**,
depending on the file type:

**CLAUDE.md — imported.** Each profile has its own *real* `CLAUDE.md` whose only line is a
**relative** import of the shared file in `~/.config/claude/shared/`:

```markdown
@../shared/CLAUDE.md
```

Claude Code resolves `@path` imports recursively when loading memory, so every profile
picks up `shared/CLAUDE.md`. Use a relative path (resolved against the importing file's
directory). A `~/...` home-relative import does **not** expand and silently loads nothing —
verified failing. Absolute paths work but hardcode the home dir, so prefer relative. Because the profile file is real (not a symlink), any
profile-specific instructions can be added below the import line and apply to that profile
only. Editing `shared/CLAUDE.md` still changes every profile at once. CLAUDE.md stays on
this mechanism because plugins have **no always-on-context component** — there is no way to
ship a global CLAUDE.md as a plugin.

**Skills & hooks — a plugin marketplace.** Shared skills and hooks live in a personal
marketplace repo, **`andres-arana/claude-plugins`** (marketplace name `andres`), which ships
a single plugin, **`personal`**:

- `plugins/personal/skills/<name>/SKILL.md` — shared skills (each needs a stable `name:` in
  frontmatter, since plugin-installed skill dirs are named by version string).
- `plugins/personal/hooks/hooks.json` + scripts — shared hooks, referencing bundled files via
  `${CLAUDE_PLUGIN_ROOT}`. The `tmux-notify` Notification/Stop hooks live here (they used to
  be hand-written blocks in each profile's `settings.json`).

Each profile opts in declaratively in its `settings.json`:

```json
"extraKnownMarketplaces": {
  "andres": { "source": { "source": "github", "repo": "andres-arana/claude-plugins" } }
},
"enabledPlugins": { "personal@andres": true }
```

(During local development the source is instead
`{ "source": "directory", "path": "/home/andres/Repositories/own/claude-plugins" }`.)
The `personal` plugin manifest omits `version`, so Claude Code uses the git commit SHA —
`/plugin marketplace update andres` picks up every new commit. Plugin skills are namespaced:
they're invoked as `personal:<name>`, not the bare name.

## How to make a change

- **Shared CLAUDE.md (all profiles)** — edit `~/.config/claude/shared/CLAUDE.md`.
- **Profile-specific CLAUDE.md** — add instructions below the `@import` line in that
  profile's `CLAUDE.md` (e.g. `~/.config/claude/gfw/CLAUDE.md`). Or use a project-level
  `CLAUDE.md`.
- **Shared skill or hook (all profiles)** — edit it in the `claude-plugins` repo under
  `plugins/personal/`, commit & push, then `/plugin marketplace update andres`.
- **New shared skill** — add `plugins/personal/skills/<name>/SKILL.md` (with a `name:` in
  frontmatter) in the repo; it ships automatically with the `personal` plugin.
- **New shared hook** — add it to `plugins/personal/hooks/hooks.json`, referencing any script
  via `${CLAUDE_PLUGIN_ROOT}`.
- **Profile-specific skill** — create it directly under `<profile>/skills/<name>/` (not in the
  marketplace).
