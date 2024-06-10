function flake-remote-rebuild -w nixos-rebuild
    eval "NIX_SSHOPTS=\"-o RequestTTY=force\" nixos-rebuild switch \
    --flake ~/.dotfiles\?submodules=1#$argv \
    --use-remote-sudo"
end

