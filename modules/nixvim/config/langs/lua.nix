{
    plugins = {
        lsp.servers.lua_ls = {
            enable = true;
            extraOptions.completion.callSnippet = "Replace";
        };
        conform-nvim.settings.formatters_by_ft.lua = ["stylua"];
    };
}
