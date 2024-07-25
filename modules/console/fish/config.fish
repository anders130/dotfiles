fish_config theme choose "fish"

function fish_greeting
    fastfetch -c $FLAKE/modules/console/fish/shell-greeting.jsonc
end

if status is-interactive
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
        if begin test "$argv[1]" = "shell";
              or test "$argv[1]" = "develop";
              or test "$argv[1]" = "build";
            end
            nom $argv
        else if test "$argv[1]" = "dev"
            command nix develop -c fish
        else
            command nix $argv
        end
    end

    set -gx EDITOR nvim
    set -x DIRENV_LOG_FORMAT ""

    # colorize man pages with bat
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -x MANROFFOPT "-c"

    # set bat theme
    set -x BAT_THEME "bat"

    zoxide init fish | source
    # use starship prompt
    starship init fish | source
end
