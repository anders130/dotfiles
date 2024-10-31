{
    imports = [
        ./langs
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

    autoCmd = [
        {
            desc = "Highlight when yanking text";
            event = ["TextYankPost"];
            callback.__raw = /*lua*/''function()
                vim.highlight.on_yank()
            end'';
        }
    ];
}
