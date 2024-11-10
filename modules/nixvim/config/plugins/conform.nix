{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.plugins.conform-nvim;
in{
    options.plugins.conform-nvim = {
        ignore_filetypes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Filetypes to ignore";
        };
    };

    config = {
        keymaps = [{
            mode = ["n" "v"];
            key = "<leader>f";
            action.__raw = /*lua*/''function()
                require('conform').format { async = true, lsp_fallback = true }
            end'';
            options.desc = "[F]ormat buffer";
        }];

        plugins.conform-nvim = {
            enable = true;
            settings = {
                notify_on_error = false;
                format_on_save = /*lua*/''function(bufnr)
                    local disable_filetypes = {
                        ${builtins.concatStringsSep ", " (builtins.map (filetype: "${filetype} = true") cfg.ignore_filetypes)}
                    }
                    if disable_filetypes[vim.bo[bufnr].filetype] then
                        return
                    else
                        return {
                            timeout_ms = 500,
                            lsp_fallback = "fallback"
                        }
                    end
                end'';
                formatters = {
                    convert_indentation = {
                        command = "${pkgs.gnused}/bin/sed";
                        args = ["-i" "-E" "s/^([ \t]+)/\\1\\1/" "$FILENAME"];
                        stdin = false;
                        cwd.__raw = /*lua*/''
                            function() return vim.fn.expand('%:p:h') end
                        '';
                    };
                };
            };
        };
    };
}
