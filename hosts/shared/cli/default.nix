{
    imports = [
        ./packages.nix
        ../../../neovim
        ../../../tmux
    ];

    modules.stylix.enable = true;

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;

    # directory dev-environments
    programs.direnv.enable = true;
}
