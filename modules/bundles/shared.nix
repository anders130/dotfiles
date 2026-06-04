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
        ssh
        nix
    ];
    hm.imports = with inputs.self.modules.homeManager; [cli nix-index];

    environment = {
        systemPackages = [(pkgs.local.rebuild.override {nix = config.nix.package;})];
        variables.NIX_FLAKE_DEFAULT_HOST = internalName;
    };

    modules = {
        programs.cli = {
            fish.enable = mkDefault true;
            btop.enable = mkDefault true;
            nh.enable = mkDefault true;
            nvix.enable = mkDefault true;
        };
    };
}
