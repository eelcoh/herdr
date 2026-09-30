# Scrolling panes proof of concept

This branch experiments with a horizontal pane strip inside each Herdr tab.
Each pane starts at half the available width. The focused pane and one adjacent
pane are visible, so opening a third pane moves the first one out of view.
Left and right pane focus follows the strip's order; workspaces remain
Herdr's vertical level.

The ready-to-use config is `docs/next/scrolling-panes-poc.toml`. On macOS,
with Rust installed, clone the prototype branch and build it:

```sh
git clone --branch poc/scrolling-panes git@github.com:eelcoh/herdr.git
cd herdr
./scripts/run-scrolling-panes-poc.sh
```

The script builds the checkout, creates its isolated `/tmp/herdr-poc-*`
directories, and launches a fresh `poc-widths` session with the demo config.
To launch the built prototype manually from the repository root:

```sh
XDG_CONFIG_HOME=/tmp/herdr-poc-config \
XDG_STATE_HOME=/tmp/herdr-poc-state \
HERDR_CONFIG_PATH="$PWD/docs/next/scrolling-panes-poc.toml" \
./target/debug/herdr --session poc-widths
```

This keeps the prototype's session files separate from normal Herdr. Its
bindings are:

```toml
[ui]
scrolling_panes = true
tab_bar_position = "bottom"

[keys]
focus_pane_left = ""
focus_pane_right = ""
focus_pane_up = ""
focus_pane_down = ""
navigate_pane_left = "["
navigate_pane_right = "]"
navigate_pane_down = ""
navigate_pane_up = ""
navigate_pane_move_left = "{"
navigate_pane_move_right = "}"
resize_mode = ""
resize_pane_right = ["cmd+r", "prefix+r"]
zoom = ["cmd+f", "prefix+f"]
previous_workspace = "prefix+k"
next_workspace = "prefix+j"
```

Press `Ctrl+b`, then `v` to add a pane to the right of the focused pane.
Press `Ctrl+b`, then `w` to enter Navigate mode. Use `[` and `]` to focus the
previous or next pane, and `{` and `}` to move the focused pane left or right.
Navigate mode stays open as you use those keys; press `Enter` to return to the
terminal. Press `Ctrl+b`, then `Shift+n` to make a workspace, or `j`/`k` to
switch workspaces. Press `Ctrl+b`, then `q` to detach.

Press `Cmd+R` to cycle the focused pane through half, two thirds, and one third
of the available width. `Cmd+F` toggles full width. These also work as
`Ctrl+b`, then `r` or `f` when the outer terminal does not send Command keys.
Width choices belong to individual panes and reset when the session restarts.

The bottom tab row shows a cue such as `←2  3/5  1→`: two panes are hidden
to the left, pane 3 of 5 is focused, and one pane is hidden to the right.

The experiment preserves the existing split tree and pane processes. It only
changes the terminal presentation and directional focus in this mode. It is a
stepped strip rather than smooth scrolling: two adjacent panes are visible,
and panes farther away are hidden. Existing split
ratios, vertical splits, and the public pane layout snapshot
still describe the underlying split tree. Those would need a dedicated layout
model for a complete niri-style implementation.
