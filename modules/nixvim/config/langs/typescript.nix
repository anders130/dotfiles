{
    plugins = {
        lsp.servers = {
            tsserver.enable = true;
            eslint.enable = true;
        };
        none-ls.sources.formatting.prettier = {
            enable = true;
            disableTsServerFormatter = true;
        };
    };
}
