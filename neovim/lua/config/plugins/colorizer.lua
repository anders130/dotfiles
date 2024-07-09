opts = {
    "*",
    html = { names = false },
}

return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup(opts)
    end,
}
