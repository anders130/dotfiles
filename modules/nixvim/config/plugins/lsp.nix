{
    plugins.lsp = {
        enable = true;
        inlayHints = true;
        keymaps.lspBuf = {
            gd = "definition";
            gr = "references";
            gI = "implemtations";
            "<leader>D" = "type_definitions";
            "<leader>ds" = "document_symbols";
            "<leader>ws" = "dynamic_workspace_symbols";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            K = "hover";
            gD = "declaration";
        };
        servers = {
            cssls.enable = true;
            html.enable = true;
            jsonls.enable = true;
            lua-ls = {
                enable = true;
                extraOptions.completion.callSnippet = "Replace";
            };
            nil-ls.enable = true;
            nixd.enable = true;
            omnisharp.enable = true;
            pyright.enable = true;
            tsserver.enable = true;
        };
    };
}
