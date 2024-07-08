{
    imports = [
        ./packages.nix
        ../../../neovim
    ];

    modules = {
        stylix.enable = true;
        tmux.enable = true;
    };

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;

    # directory dev-environments
    programs.direnv.enable = true;
}
