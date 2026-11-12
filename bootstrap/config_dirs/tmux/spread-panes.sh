#!/bin/sh
# Spreads all panes of a window out evenly, on every level of the layout.
# `select-layout -E` only evens out the direct parent of a pane, so with nested
# layouts (e.g. columns with several panes each) the columns stay uneven.
#
# Usage: spread-panes.sh <window-id>

window="${1:?window id missing}"

layout=$(tmux display -p -t "$window" '#{window_layout}')

# Recalculates size and offset of each cell top-down. Siblings share their
# parent's size minus the 1-cell borders between them; the remainder goes to
# the first siblings.
even=$(printf '%s' "$layout" | /usr/bin/jq -c '
  def spread($x; $y; $w; $h):
    .x = $x | .y = $y | .w = $w | .h = $h
    | if .t == "p" then . else
        .t as $t | .c as $cells | ($cells | length) as $n
        | ((if $t == "h" then $w else $h end) - ($n - 1)) as $free
        | (($free / $n) | floor) as $each
        | .c = (reduce range(0; $n) as $i ({pos: (if $t == "h" then $x else $y end), out: []};
            .pos as $pos
            | ($each + (if $i < $free - $each * $n then 1 else 0 end)) as $size
            | .out += [$cells[$i] | if $t == "h" then spread($pos; $y; $size; $h) else spread($x; $pos; $w; $size) end]
            | .pos = $pos + $size + 1
          ) | .out)
      end;
  .L |= spread(.x; .y; .w; .h)
')

tmux select-layout -t "$window" "$even"
