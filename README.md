# claude-plugins

Andres's personal [Claude Code](https://code.claude.com) plugin marketplace.

Marketplace name: **`andres`**. It currently ships one plugin, **`personal`**, bundling the
skills and hooks that are shared across my Claude config profiles
(`~/.config/claude/{gfw,obs}`).

## Contents

| Component | Type | Notes |
|-----------|------|-------|
| `claude-config-profiles` | skill | How my multi-profile Claude config is structured |
| `spec-writer` | skill | Turn a feature idea into a full specification |
| `tmux-notify` | hook | Flags the tmux window on `Notification` / `Stop` |

## Install

```
/plugin marketplace add andres-arana/claude-plugins
/plugin install personal@andres
```

Or declaratively, in a profile's `settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "andres": { "source": { "source": "github", "repo": "andres-arana/claude-plugins" } }
  },
  "enabledPlugins": { "personal@andres": true }
}
```

During local development, point the marketplace at this checkout instead:

```json
"andres": { "source": { "source": "directory", "path": "/home/andres/Repositories/own/claude-plugins" } }
```

## Layout

```
.claude-plugin/marketplace.json   # marketplace catalog
plugins/personal/
  .claude-plugin/plugin.json      # plugin manifest (no version -> commit-SHA versioning)
  skills/<name>/SKILL.md          # one dir per skill (stable name: in frontmatter)
  hooks/hooks.json                # hook wiring, references ${CLAUDE_PLUGIN_ROOT}
  hooks/tmux-notify.sh            # the hook script
```

The plugin manifest intentionally omits `version`, so Claude Code uses the git commit SHA —
`/plugin marketplace update andres` then picks up every new commit automatically.

## Not in this repo

The global `CLAUDE.md` rules stay outside the marketplace: plugins have no always-on-context
component, so those live in `~/.config/claude/shared/CLAUDE.md` and are pulled into each
profile via an `@../shared/CLAUDE.md` import.
