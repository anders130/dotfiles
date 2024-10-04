{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.modules.nixvim = {
        enable = lib.mkEnableOption "nixvim";
    };

    config = lib.mkIf config.modules.nixvim.enable {
        environment = {
            systemPackages = [inputs.nixvim.packages.${pkgs.system}.default];

            shellAliases = {
                vim = "nvim";
                vi = "nvim";
            };

            variables.EDITOR = "nvim";
        };
    };
}
