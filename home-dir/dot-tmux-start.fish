#!/usr/bin/env fish
if test -z "$TMUX"
    tmux attach || tmux
else
    exec fish
end

