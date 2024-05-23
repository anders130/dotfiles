fish_config theme choose "Catppuccin Macchiato"

function fish_greeting
    fastfetch -c ~/.dotfiles/other/shell-greeting.jsonc
end

# usage: flake-rebuild [--impure]
function flake-rebuild -w nixos-rebuild
    if test "x$NIX_FLAKE_DEFAULT_HOST" = "x"
        set_color red
        echo -n "error: "
        set_color normal
        echo '$NIX_FLAKE_DEFAULT_HOST is not set!'
        return
    end
    # require users password to continue
    # (to avoid nom not showing password prompt for nixos-rebuild)
    sudo true # require password to do nothing
    if test $status -ne 0; return; end # exit if unsuccessful

    # use default host and nom
    eval "sudo nixos-rebuild switch --flake ~/.dotfiles\?submodules=1#$NIX_FLAKE_DEFAULT_HOST $argv &| nom"
end

function flake-remote-rebuild -w nixos-rebuild
    eval "NIX_SSHOPTS=\"-o RequestTTY=force\" nixos-rebuild switch \
    --flake ~/.dotfiles\?submodules=1#$argv \
    --use-remote-sudo"
end

complete -c flake-rebuild -l impure -k

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

    alias ls lsd
    alias cat bat

    alias aquarium "asciiquarium -s -t"

    # alias nix commands to nom
    function nix
        if begin test "$argv[1]" = "shell";
              or test "$argv[1]" = "develop";
              or test "$argv[1]" = "build";
            end
            nom $argv
        else
            command nix $argv
        end
    end

    set -gx EDITOR nvim 

    # bind -M insert -k nul 'start_tmux'

    # zoxide fuzzy find cd with z
    zoxide init fish | source
    # use starship prompt
    starship init fish | source
end
