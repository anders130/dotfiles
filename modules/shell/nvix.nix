{
    flake-file.inputs.nvix.url = "github:anders130/nvix";
    flake-follows.exclude = ["nvix.nixpkgs"];
    den.aspects.nvix = {
        nixos = {
            lib,
            pkgs,
            inputs',
            ...
        }: {
            options.my.nvix.type = lib.mkOption {
                type = lib.types.enum ["base" "full"];
                default = "base";
            };
            config = {
                nixpkgs.overlays = [
                    (_: _: {nvix = inputs'.nvix.packages;})
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
            };
        };
        homeManager = {
            osConfig,
            pkgs,
            ...
        }: {
            home.packages = [pkgs.nvix.${osConfig.my.nvix.type}];
        };
    };
}
