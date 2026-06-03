{
    config,
    inputs,
    internalName,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    imports = with inputs.self.modules.nixos; [
        default
        jesse
        sops
    ];

    environment = {
        systemPackages = [(pkgs.local.rebuild.override {nix = config.nix.package;})];
        variables.NIX_FLAKE_DEFAULT_HOST = internalName;
    };

    modules = {
        programs.cli = {
            fish.enable = mkDefault true;
            btop.enable = mkDefault true;
            nh.enable = mkDefault true;
            nix-index.enable = mkDefault true;
            nix.enable = mkDefault true;
            ssh.enable = mkDefault true;
            nvix.enable = mkDefault true;
        };
        utils = {
            stylix.enable = mkDefault true;
            keyboard.enable = mkDefault true;
            locale.enable = mkDefault true;
            nixpkgs.enable = mkDefault true;
        };
    };
}
