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
        hm.home.packages = [inputs.nvix.packages.${pkgs.system}.${cfg.type}];
        environment = {
            systemPackages = [inputs.nvix.packages.${pkgs.system}.base];

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
