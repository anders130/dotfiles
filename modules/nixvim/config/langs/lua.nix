{
    plugins = {
        lsp.servers.lua-ls = {
            enable = true;
            extraOptions.completion.callSnippet = "Replace";
        };
        conform-nvim.formattersByFt.lua = ["stylua"];
    };
}
