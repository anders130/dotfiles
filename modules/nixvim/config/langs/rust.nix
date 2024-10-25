{pkgs, ...}: {
    plugins = {
        lsp.servers.rust-analyzer = {
            enable = true;
            settings.cargo.features = "all";
            # Handled by the flake.nix of the rust project
            installCargo = false;
            installRustc = false;
        };
        conform-nvim.formattersByFt.rust = ["rustfmt"];
    };

    extraPackages = [pkgs.rustfmt];
}
