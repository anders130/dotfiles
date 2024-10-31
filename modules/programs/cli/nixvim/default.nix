{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.modules.programs.cli.nixvim = {
        enable = lib.mkEnableOption "nixvim";
    };

    config = lib.mkIf config.modules.programs.cli.nixvim.enable {
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
