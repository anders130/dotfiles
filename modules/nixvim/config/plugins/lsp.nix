{
    plugins.lsp = {
        enable = true;
        inlayHints = true;
        keymaps.extra = [
            {
                key = "gd";
                action.__raw = "require('telescope.builtin').lsp_definitions";
                options.desc = "[G]oto [D]efinition";
            }
            {
                key = "gr";
                action.__raw = "require('telescope.builtin').lsp_references";
                options.desc = "[G]oto [R]eferences";
            }
            {
                key = "gI";
                action.__raw = "require('telescope.builtin').lsp_implementations";
                options.desc = "[G]oto [I]mplementations";
            }
            {
                key = "<leader>D";
                action.__raw = "require('telescope.builtin').lsp_type_definitions";
                options.desc = "Type [D]efinition";
            }
            {
                key = "<leader>ds";
                action.__raw = "require('telescope.builtin').lsp_document_symbols";
                options.desc = "[D]ocument [S]ymbols";
            }
            {
                key = "<leader>ws";
                action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
                options.desc = "[W]orkspace [S]ymbols";
            }
        ];
        keymaps.lspBuf = {
            gd = "definition";
            rn = "rename";
            ca = "code_action";
            K = "hover";
            gD = "declaration";
        };
        servers = {
            cssls.enable = true;
            html.enable = true;
            java_language_server.enable = true;
            jsonls.enable = true;
        };
    };
}
