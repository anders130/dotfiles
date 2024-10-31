{pkgs, ...}: {
    extraPlugins = [pkgs.vimPlugins.treesj];

    extraConfigLuaPre = /*lua*/''
        require("treesj").setup {
            use_default_keymaps = false,
        }
    '';

    keymaps = [
        {
            mode = "n";
            key = "<leader>m";
            action = "<cmd>TSJToggle<cr>";
        }
    ];
}
