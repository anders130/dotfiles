{
    filetype = {
        extension.rasi = "rasi";
        pattern.".*/hypr/.*%.conf" = "hyprlang";
    };

    extraConfigLua = /*lua*/''
        require("nvim-treesitter.install").prefer_git = true
    '';

    plugins.treesitter = {
        enable = true;
        settings = {
            auto_install = false;
            ensure_installed = "all";
            prefer_git = true;
            highlight = {
                enable = true;
                # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                # If you are experiencing weird indenting issues, add the language to
                # the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = [ "ruby" ];
            };
            indent = {
                enable = true;
                disable = [ "ruby" ];
            };
        };
    };
}
