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

    # update flake inputs with relative paths to avoid nixos-rebuild from failing
    eval "nix flake lock --update-input nixvim"
    # use default host and nom
    eval "sudo nixos-rebuild switch --flake $FLAKE\?submodules=1#$NIX_FLAKE_DEFAULT_HOST $argv &| nom"
end

complete -c flake-rebuild -l impure -k
