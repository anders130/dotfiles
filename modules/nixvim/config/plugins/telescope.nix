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
        keymaps = {
            "<leader>sh" = {
                action = "help_tags";
                options.desc = "[S]earch [H]elp";
            };
            "<leader>sk" = {
                action = "keymaps";
                options.desc = "[S]earch [K]eymaps";
            };
            "<leader>sf" = {
                action = "find_files";
                options.desc = "[S]earch [F]iles";
            };
            "<leader>ss" = {
                action = "builtin";
                options.desc = "[S]earch [S]elect Telescope";
            };
            "<leader>sw" = {
                action = "grep_string";
                options.desc = "[S]earch current [W]ord";
            };
            "<leader>sg" = {
                action = "live_grep";
                options.desc = "[S]earch [G]rep";
            };
            "<leader>sd" = {
                action = "diagnostics";
                options.desc = "[S]earch [D]iagnostics";
            };
            "<leader>s." = {
                action = "oldfiles";
                options.desc = "[S]earch Recent Files (\".\" for repeat)";
            };
            "<leader><leader>" = {
                action = "buffers";
                options.desc = "[ ] Find existing buffers";
            };
            "<leader>/" = {
                action = "current_buffer_fuzzy_find";
                options.desc = "[/] Fuzzily search in current buffer";
            };
        };
        settings.pickers.buffers = {
            show_all_buffers = true;
            sort_lastused = true;
            previewer = true;
            mappings.i."<c-d>" = "delete_buffer";
        };
    };
}
