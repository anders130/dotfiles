{inputs, ...}: {
    flake-file.inputs.nvix.url = "github:anders130/nvix";
    flake.modules.nixos.nvix = {
        config,
        lib,
        pkgs,
        ...
    }: {
        options.my.nvix.type = lib.mkOption {
            type = lib.types.enum ["base" "full"];
            default = "base";
        };
        config = {
            nixpkgs.overlays = [
                (_: prev: {nvix = inputs.nvix.packages.${prev.stdenv.hostPlatform.system};})
            ];
            environment = {
                systemPackages = [pkgs.nvix.base];
                shellAliases = {
                    nvix = "nvim";
                    vim = "nvim";
                    vi = "nvim";
                    v = "nvim";
                };
                variables.EDITOR = "nvim";
            };
            home-manager.sharedModules = [
                {
                    home.packages = [pkgs.nvix.${config.my.nvix.type}];
                }
            ];
        };
    };
}
