{
    imports = [
        ./cmp.nix
        ./conform.nix
        ./dashboard.nix
        ./treesitter.nix
    ];

    plugins = {
        indent-blankline.enable = true;
        neo-tree.enable = true;

        ts-autotag.enable = true;
        nvim-autopairs.enable = true;
        nvim-colorizer = {
            enable = true;
            fileTypes = [
                "*"
                {
                    language = "html";
                    names = false;
                }
            ];
        };

        fugitive.enable = true;
        # vim-rhubarb.enable = true;
        gitsigns.enable = true;
        godot.enable = true;
        otter.enable = true;
        markdown-preview.enable = true;
        tmux-navigator.enable = true;
        which-key.enable = true;
    };
}
