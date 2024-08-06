{
    plugins.telescope = {
        enable = true;
        extensions = {
            fzf-native.enable = true;
            ui-select = {
                enable = true;
                settings = {
                    theme = "dropdown";
                };
            };
        };
        settings.pickers.buffers = {
            show_all_buffers = true;
            sort_lastused = true;
            previewer = true;
            mappings.i."<c-d>" = "delete_buffer";
        };
    };

    keymaps = [
        {
            mode = "n";
            key = "<leader>sh";
            action = "<cmd>Telescope help_tags<cr>";
            options.desc = "[S]earch [H]elp";
        }
        {
            mode = "n";
            key = "<leader>sk";
            action = "<cmd>Telescope keymaps<cr>";
            options.desc = "[S]earch [K]eymaps";
        }
        {
            mode = "n";
            key = "<leader>sf";
            action = "<cmd>Telescope find_files<cr>";
            options.desc = "[S]earch [F]iles";
        }
        {
            mode = "n";
            key = "<leader>ss";
            action = "<cmd>Telescope builtin<cr>";
            options.desc = "[S]earch [S]elect Telescope";
        }
        {
            mode = "n";
            key = "<leader>sw";
            action = "<cmd>Telescope grep_string<cr>";
            options.desc = "[S]earch current [W]ord";
        }
        {
            mode = "n";
            key = "<leader>sg";
            action = "<cmd>Telescope live_grep<cr>";
            options.desc = "[S]earch [G]rep";
        }
        {
            mode = "n";
            key = "<leader>sd";
            action = "<cmd>Telescope diagnostics<cr>";
            options.desc = "[S]earch [D]iagnostics";
        }
        {
            mode = "n";
            key = "<leader>s.";
            action = "<cmd>Telescope oldfiles<cr>";
            options.desc = "[S]earch Recent Files (\".\" for repeat)";
        }
        {
            mode = "n";
            key = "<leader><leader>";
            action = "<cmd>Telescope buffers<cr>";
            options.desc = "[ ] Find existing buffers";
        }
        {
            mode = "n";
            key = "<leader>/";
            action = /*lua*/''function()
                require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes")
                    .get_dropdown {
                        winblend = 10,
                        previewer = false,
                    }
                )
            end'';
            options.desc = "[/] Fuzzily search in current buffer";
        }
        {
            mode = "n";
            key = "<leader>s/";
            action = /*lua*/''function()
                require("telescope.builtin").live_grep {
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                }
            end'';
            options.desc = "[S]earch [/] in Open Files";
        }
        {
            mode = "n";
            key = "<leader>sn";
            action = /*lua*/''function()
                require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
            end'';
            options.desc = "[S]earch [N]eovim Files";
        }
    ];
}
