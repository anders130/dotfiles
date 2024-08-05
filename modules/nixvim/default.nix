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
        modules.neovim.enable = lib.mkForce false;

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
