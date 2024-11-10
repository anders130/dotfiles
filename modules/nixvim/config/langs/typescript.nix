{
    plugins = {
        lsp.servers = {
            ts_ls.enable = true;
            eslint.enable = true;
        };
        none-ls.sources.formatting.prettier = {
            enable = true;
            disableTsServerFormatter = true;
        };
    };
}
