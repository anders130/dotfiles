{pkgs, ...}: {
    extraPlugins = [pkgs.vimPlugins.supermaven-nvim];

    extraConfigLua = /*lua*/''
        require("supermaven-nvim").setup {
            disable_inline_completion = false,
            keymaps = {
                accept_suggestion = "<S-TAB>",
                clear_suggestion = "<C-S-j>",
                accept_word = "<C-j>",
            }
        }
    '';
}
