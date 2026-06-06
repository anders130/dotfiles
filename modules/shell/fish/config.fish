set fish_function_path $fish_function_path ~/.config/fish/custom_functions

set -U fish_greeting ""
# Commands to run in interactive sessions can go here
fish_vi_key_bindings
set -g fish_vi_force_cursor
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# ctrl+p to go to previous command
bind \cp _atuin_bind_up
bind -M insert \cp _atuin_bind_up

set -gx EDITOR nvim

# colorize man pages with bat
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x MANROFFOPT "-c"
