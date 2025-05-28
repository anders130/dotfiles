set fish_function_path $fish_function_path ~/.config/fish/custom_functions

set -U fish_greeting ""
# Commands to run in interactive sessions can go here
fish_vi_key_bindings
set -g fish_vi_force_cursor
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# ctrl+p to go to previous command
bind \cp up-or-search
bind -M insert \cp up-or-search

# ctrl+n to go to next command
bind \cn down-or-search
bind -M insert \cn down-or-search

# alias nix commands to nom
function nix
    set -l unfree 0
    set -l args

    for arg in $argv
        if test "$arg" = "--unfree"
            set unfree 1
        else
            set args $args $arg
        end
    end

    if test $unfree -eq 1
        env NIXPKGS_ALLOW_UNFREE=1 nix $args --impure
    else
        if begin test "$args[1]" = "build";
                or test "$args[1]" = "shell";
                or test "$args[1]" = "develop";
            end
            nom $args
        else if test "$args[1]" = "search"
            nh $args
        else
            command nix $args
        end
    end
end

function ls
    if test -f .hidden
        set hidden_args (cat .hidden | xargs -I{} echo --ignore-glob={})
    end

    # only hide hidden files if the current command is ls
    switch (basename (status current-command))
        case 'ls'
            command lsd $hidden_args $argv
        case '*'
            command lsd $argv
    end
end

set -gx EDITOR nvim

# colorize man pages with bat
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x MANROFFOPT "-c"
