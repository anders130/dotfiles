{
    lib,
    pkgs,
    ...
}: {
    options.type = lib.mkOption {
        type = lib.types.enum ["base" "full"];
        default = "base";
    };

    config = cfg: {
        hm.home.packages = [pkgs.inputs.nvix.${cfg.type}];
        environment = {
            systemPackages = [pkgs.inputs.nvix.base];

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
