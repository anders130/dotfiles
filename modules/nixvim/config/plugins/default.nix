{
    imports = [
        ./cellular-automaton.nix
        ./cmp.nix
        ./colorizer.nix
        ./conform.nix
        ./dashboard.nix
        ./lsp.nix
        ./supermaven.nix
        ./telescope.nix
        ./treesitter.nix
        ./treesj.nix
        ./trouble.nix
    ];

    plugins = {
        # essentials
        comment.enable = true; # "gc" to comment visual regions/lines
        indent-blankline.enable = true;
        lualine = {
            enable = true;
        };
        otter.enable = true; # completion for embedded code
        surround.enable = true;
        tmux-navigator.enable = true;
        which-key.enable = true;

        # git
        fugitive.enable = true; # git commands in nvim with ":G"
        # vim-rhubarb.enable = true;
        gitsigns.enable = true;

        # autopairs
        ts-autotag.enable = true;
        nvim-autopairs.enable = true;

        # mini
        mini = {
            enable = true;
            modules = {
                ai.n_lines = 500;
                surround.enable = true;
            };
        };

        # misc
        godot.enable = true;
        markdown-preview.enable = true;
        neo-tree.enable = true;
    };
}
