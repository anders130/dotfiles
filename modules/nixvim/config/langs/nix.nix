{pkgs, ...}: {
    plugins = {
        lsp.servers.nixd = {
            enable = true;
            settings = {
                nixpkgs.expr = /*nix*/''
                    (builtins.getFlake (builtins.getEnv "FLAKE")).inputs.nixpkgs {}
                '';
                options.nixos.expr = /*nix*/''
                    (builtins.getFlake (builtins.getEnv "FLAKE")).nixosConfigurations.desktop.options
                '';
            };
        };
        conform-nvim = {
            ignore_filetypes = ["nix"]; # IMPORTANT: this a custom option
            formattersByFt.nix = ["alejandra" "convert_indentation"];
        };
    };

    extraPackages = [pkgs.alejandra];
}
