function fish_greeting
    fastfetch -c ~/.dotfiles/fastfetch/shell-greeting.jsonc
end

# usage: flake-rebuild HOST [--impure]
function flake-rebuild -w nixos-rebuild
    if test "x$argv" = "x"
        if test "x$NIX_FLAKE_DEFAULT_HOST" = "x"
            set_color red
            echo -n "error: "
            set_color normal
            echo '$NIX_FLAKE_DEFAULT_HOST is not set!'
            return
        end
        set argv $NIX_FLAKE_DEFAULT_HOST
    end
    eval "sudo nixos-rebuild switch --flake ~/.dotfiles\?submodules=1#$argv"
end

complete -c flake-rebuild -l impure -k
complete -c flake-rebuild -xa "linux wsl" -k -f

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set -g fish_vi_force_cursor
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore

    # colors
    set fish_color_command "blue"
    set fish_color_quote "green"
    set fish_color_option "gray"

    alias ls lsd
    alias cat bat
    
    set -gx EDITOR nvim 

    # bind -M insert -k nul 'start_tmux'

    # zoxide fuzzy find cd with z
    zoxide init fish | source
    # use starship prompt
    starship init fish | source
end
