return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        vim.o.buftype = 'nofile' -- set buffer type to hide indent-blankline
        require('dashboard').setup({
            theme = 'hyper',
            config = {
                project = {
                    enable = true,
                    -- go to the projects root directory and open neotree
                    action = 'Neotree current dir='
                },
                footer = {},
            },
        })
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
