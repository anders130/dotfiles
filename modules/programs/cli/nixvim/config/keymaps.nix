{
    globals = {
        mapleader = " ";
        maplocalleader = " ";
    };

    # Set highlight on search, but clear on pressing <Esc> in normal mode
    opts.hlsearch = true;
    keymaps = [
        { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }

        # Diagnostic keymaps
        { mode = "n"; key = "[d"; action = "vim.diagnostic.goto_prev"; options.desc = "Go to previous diagnostic message"; }
        { mode = "n"; key = "]d"; action = "vim.diagnostic.goto_next"; options.desc = "Go to next diagnostic message"; }
        { mode = "n"; key = "<leader>e"; action = "vim.diagnostic.open_float"; options.desc = "Open floating diagnostic message"; }

        { mode = "n"; key = "<leader>q"; action = "vim.diagnostic.setloclist"; options.desc = "Open diagnostics list"; }
        # TIP: Disable arrow keys in normal mode
        { mode = "n"; key = "<left>"; action = "<cmd>echo \"Use h to move!!\"<CR>"; }
        { mode = "n"; key = "<right>"; action = "<cmd>echo \"Use l to move!!\"<CR>"; }
        { mode = "n"; key = "<up>"; action = "<cmd>echo \"Use k to move!!\"<CR>"; }
        { mode = "n"; key = "<down>"; action = "<cmd>echo \"Use j to move!!\"<CR>"; }
    ];
}
