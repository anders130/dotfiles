{
    config,
    lib,
    ...
}: {
    imports = [
        ./packages.nix
    ];

    options.bundles.cli = {
        enable = lib.mkEnableOption "cli";
    };

    config = lib.mkIf config.bundles.cli.enable {
        modules = {
            console = {
                btop.enable = lib.mkDefault true;
                fish.enable = lib.mkDefault true;
                git.enable = lib.mkDefault true;
                tmux.enable = lib.mkDefault true;
            };
            neovim.enable = lib.mkDefault true;
            theming.stylix.enable = lib.mkDefault true;
        };

        # for secret storing stuff
        services.gnome.gnome-keyring.enable = lib.mkDefault true;

        # directory dev-environments
        programs.direnv.enable = lib.mkDefault true;
    };
}
