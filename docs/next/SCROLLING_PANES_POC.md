# Scrolling panes proof of concept

This branch experiments with a horizontal pane strip inside each Herdr tab.
Each pane starts at half the available width and keeps its own width choice.
The focused pane and one adjacent pane are visible, so opening a third pane
moves the first one out of view.
Left and right pane focus follows the strip's order; workspaces remain
Herdr's vertical level. Clicking either visible pane keeps the current pair
in place. The strip shifts only when focus moves outside that pair.

The ready-to-use config is `docs/next/scrolling-panes-poc.toml`. On macOS,
with Rust installed, clone the prototype branch and build it:

```sh
git clone --branch poc/scrolling-panes git@github.com:eelcoh/herdr.git
cd herdr
./scripts/run-scrolling-panes-poc.sh
```

On bootc Linux, run the build and launcher inside your development Distrobox
with Rust and Zig installed, rather than in the host shell.

The script builds the checkout, creates its isolated `/tmp/herdr-poc-*`
directories, and launches a fresh `poc-widths-v2` session with the demo config.
To launch the built prototype manually from the repository root:

```sh
XDG_CONFIG_HOME=/tmp/herdr-poc-config \
XDG_STATE_HOME=/tmp/herdr-poc-state \
HERDR_CONFIG_PATH="$PWD/docs/next/scrolling-panes-poc.toml" \
./target/debug/herdr --session poc-widths-v2
```

This keeps the prototype's session files separate from normal Herdr. Its
bindings are:

```toml
[ui]
scrolling_panes = true
tab_bar_position = "bottom"

[keys]
cycle_pane_previous = ["prefix+shift+tab", "alt+comma"]
cycle_pane_next = ["prefix+tab", "alt+period"]
focus_pane_left = "prefix+h"
focus_pane_right = "prefix+l"
focus_pane_up = ""
focus_pane_down = ""
navigate_pane_left = "h"
navigate_pane_right = "l"
navigate_pane_down = ""
navigate_pane_up = ""
navigate_pane_move_left = "shift+h"
navigate_pane_move_right = "shift+l"
resize_mode = ""
resize_pane_right = ["cmd+r", "prefix+r"]
zoom = ["cmd+f", "prefix+f"]
previous_workspace = ["prefix+k", "alt+<", "alt+shift+comma"]
next_workspace = ["prefix+j", "alt+>", "alt+shift+period"]
```

Press `Alt+,` or `Alt+.` to cycle to the previous or next pane.
Press `Alt+<` or `Alt+>` to switch to the previous or next workspace
(`Alt+Shift+,` or `Alt+Shift+.` on a US keyboard). These shortcuts take over
the corresponding shell bindings. On macOS, configure the terminal's Option
key to send Meta/Esc+ so the shortcuts reach Herdr. Both legacy symbol input
and enhanced protocol shifted-key input are bound.

Press `Ctrl+b`, then `v` to add a pane to the right of the focused pane.
Press `Ctrl+b`, then `h` or `l` to focus the previous or next pane directly.
`Ctrl+b`, then `Tab` or `Shift+Tab` also cycles through panes.
Press `Ctrl+b`, then `w` to enter Navigate mode. Use `h`/`l` or the left/right
arrows to focus the previous or next pane, and `Shift+h`/`Shift+l` to move the
focused pane left or right.
Navigate mode stays open as you use those keys; press `Enter` to return to the
terminal. Press `Ctrl+b`, then `Shift+n` to make a workspace, or `j`/`k` to
switch workspaces. Press `Ctrl+b`, then `q` to detach.

Press `Cmd+R` to cycle the focused pane through half, two thirds, and one third
of the available width. `Cmd+F` toggles full width. These also work as
`Ctrl+b`, then `r` or `f` when the outer terminal does not send Command keys.
Width choices belong to individual panes and reset when the session restarts.
When two panes fit, both keep their chosen widths and spare space stays blank.
When they exceed the viewport, the neighboring preview is clipped so the
focused pane keeps its chosen width.

The bottom tab row shows a cue such as `←2  3/5  1→`: two panes are hidden
to the left, pane 3 of 5 is focused, and one pane is hidden to the right.

The experiment preserves the existing split tree and pane processes. It only
changes the terminal presentation and directional focus in this mode. It is a
stepped strip rather than smooth scrolling: two adjacent panes are visible,
and panes farther away are hidden. Existing split
ratios, vertical splits, and the public pane layout snapshot
still describe the underlying split tree. Those would need a dedicated layout
model for a complete niri-style implementation.
