{
    config,
    inputs,
    internalName,
    pkgs,
    ...
}: {
    imports = with inputs.self.modules.nixos; [
        default
        jesse
        sops
        ssh
        nix
        nh
        nvix
        fish
    ];
    hm.imports = with inputs.self.modules.homeManager; [cli nix-index btop];

    environment = {
        systemPackages = [(pkgs.local.rebuild.override {nix = config.nix.package;})];
        variables.NIX_FLAKE_DEFAULT_HOST = internalName;
    };
}
