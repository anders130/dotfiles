{
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.type = lib.mkOption {
        type = lib.types.enum ["base" "full"];
        default = "base";
    };

    config = cfg: {
        nixpkgs.overlays = [(_: prev: {nvix = inputs.nvix.packages.${prev.stdenv.hostPlatform.system};})];
        hm.home.packages = [pkgs.nvix.${cfg.type}];
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
}
