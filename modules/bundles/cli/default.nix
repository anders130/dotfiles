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
        modules.console = {
            btop.enable = lib.mkDefault true;
            fish.enable = lib.mkDefault true;
            git.enable = lib.mkDefault true;
            tmux.enable = lib.mkDefault true;
            nvix = {
                enable = lib.mkDefault true;
                type = lib.mkDefault "full";
            };
        };

        # for secret storing stuff
        services.gnome.gnome-keyring.enable = lib.mkDefault true;

        # directory dev-environments
        programs.direnv.enable = lib.mkDefault true;

        # add nix-community cache
        nix.settings.substituters = ["https://nix-community.cachix.org"];

        nix.settings.trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };
}
