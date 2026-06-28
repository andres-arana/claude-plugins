#!/usr/bin/env bash
# Claude Code Notification/Stop hook (shared by all profiles via symlink).
# Rings a tmux bell in the originating pane so that window flags in the status
# bar (window_bell_flag) until you next focus it. The status bar lists flagged
# windows across ALL sessions — see ~/.tmux.conf (@tmux-gruvbox-right-status-x).
#
# Deliberately silent and non-intrusive: no desktop notification (notify-send
# was too spammy and had to be dismissed by hand) and no audible beep
# (bell-action none in tmux.conf). The status-bar flag is the whole signal;
# it auto-clears when you focus the window. The optional $1 label is ignored.

if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
  # Writing BEL to the pane tty makes tmux flag that window in the status bar
  # until it is next focused. Works across windows/sessions; auto-clears on focus.
  tmux run-shell -t "$TMUX_PANE" "printf '\\a' > #{pane_tty}" 2>/dev/null \
    || printf '\a' >/dev/tty 2>/dev/null
fi
