#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$repo_dir"
cargo build --locked

export XDG_CONFIG_HOME=/tmp/herdr-poc-config
export XDG_STATE_HOME=/tmp/herdr-poc-state
export HERDR_CONFIG_PATH="$repo_dir/docs/next/scrolling-panes-poc.toml"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_STATE_HOME"

exec "$repo_dir/target/debug/herdr" --session poc-widths "$@"
