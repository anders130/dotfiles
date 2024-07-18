return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        vim.o.buftype = 'nofile' -- set buffer type to hide indent-blankline
        local dashboard = require('dashboard')

        dashboard.setup({
            theme = 'hyper',
            config = {
                project = {
                    enable = true,
                    -- action = 'Neotree current dir='
                    action = function(project_path)
                        vim.cmd('cd ' .. project_path)
                        vim.cmd('Neotree')
                        vim.api.nvim_buf_delete(dashboard.bufnr, { force = true })
                    end,
                },
                footer = {},
            },
        })
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
