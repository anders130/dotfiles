return {
    "jmbuhr/otter.nvim",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
        require('otter').activate({ "javascript", "python", "fish" }, true, true, nil)
    end,
}
