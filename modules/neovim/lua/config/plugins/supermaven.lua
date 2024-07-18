return {
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({
            disable_inline_completion = false,
            keymaps = {
                accept_suggestion = "<S-TAB>",
                clear_suggestion = "<C-S-j>",
                accept_word = "<C-j>",
            },
        })
    end
}
