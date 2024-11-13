{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./nvix.nix {
    environment = {
        systemPackages = [inputs.nvix.packages.${pkgs.system}.default];

        shellAliases = {
            nvix = "nvim";
            vim = "nvim";
            vi = "nvim";
        };

        variables.EDITOR = "nvim";
    };
}
