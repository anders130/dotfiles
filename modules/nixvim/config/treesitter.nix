{
    filetype = {
        extension.rasi = "rasi";
        pattern.".*/hypr/.*%.conf" = "hyprlang";
    };

    plugins.treesitter = {
        enable = true;
        settings = {
            ensure_installed = "all";
            auto_install = false;
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
            rainbow = {
                enable = true;
            };
        };
    };
}
