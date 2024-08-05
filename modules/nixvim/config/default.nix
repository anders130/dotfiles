{
    imports = [
        ./plugins

        ./keymaps.nix
        ./set.nix
    ];

    colorschemes.catppuccin = {
        enable = true;
        settings = {
            flavour = "macchiato";
            transparent_background = true;
        };
    };
}
