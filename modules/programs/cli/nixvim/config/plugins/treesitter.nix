{
    filetype = {
        extension.rasi = "rasi";
        pattern.".*/hypr/.*%.conf" = "hyprlang";
    };

    plugins.treesitter = {
        enable = true;
        settings = {
            highlight.enable = true;
            indent.enable = true;
        };
        nixvimInjections = true;
    };
}
