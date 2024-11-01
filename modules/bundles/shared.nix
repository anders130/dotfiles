{
    config,
    lib,
    ...
}: {
    options.bundles.shared = {
        enable = lib.mkEnableOption "shared bundle";
    };

    config.modules = lib.mkIf config.bundles.shared.enable {
        programs.cli = {
            fish.enable = lib.mkDefault true;
            starship.enable = lib.mkDefault true;
            btop.enable = lib.mkDefault true;
            nix-index.enable = lib.mkDefault true;
            nix.enable = lib.mkDefault true;
            ssh.enable = lib.mkDefault true;
        };

        utils = {
            sops.enable = lib.mkDefault true;
            stylix.enable = lib.mkDefault true;
            home-manager.enable = lib.mkDefault true;
            locale.enable = lib.mkDefault true;
            nixpkgs.enable = lib.mkDefault true;
            user.enable = lib.mkDefault true;
        };
    };
}
