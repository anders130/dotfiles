{lib, ...}: {
    imports = lib.importFromDir ./.;

    plugins = {
        # essentials
        comment.enable = true; # "gc" to comment visual regions/lines
        indent-blankline.enable = true;
        lualine = {
            enable = true;
            settings.options = {
                theme = "catppuccin";
                section_separators = {
                    left = "";
                    right = "";
                };
                component_separators = {
                    left = "";
                    right = "";
                };
            };
        };
        otter.enable = true; # completion for embedded code
        vim-surround.enable = true;
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
        web-devicons.enable = true;
    };
}
