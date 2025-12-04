{
    internalName,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    environment = {
        systemPackages = [pkgs.local.rebuild];
        variables.NIX_FLAKE_DEFAULT_HOST = internalName;
    };

    modules = {
        programs.cli = {
            fish.enable = mkDefault true;
            git.enable = mkDefault true;
            btop.enable = mkDefault true;
            direnv.enable = mkDefault true;
            nh.enable = mkDefault true;
            nix-index.enable = mkDefault true;
            nix.enable = mkDefault true;
            ssh.enable = mkDefault true;
            nvix.enable = mkDefault true;
        };
        utils = {
            sops.enable = mkDefault true;
            stylix.enable = mkDefault true;
            home-manager.enable = mkDefault true;
            keyboard.enable = mkDefault true;
            locale.enable = mkDefault true;
            networking.enable = mkDefault true;
            nixpkgs.enable = mkDefault true;
            users.enable = mkDefault true;
        };
    };
}
