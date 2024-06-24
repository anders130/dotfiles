{
    ...
}: {
    imports = [
        ./packages.nix
        ../../../neovim
        ../../../tmux
    ];

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;

    # directory dev-environments
    programs.direnv.enable = true;
}
