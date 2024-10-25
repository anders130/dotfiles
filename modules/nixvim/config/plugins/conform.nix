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
            notifyOnError = false;
            formatOnSave = /*lua*/''function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local ignore_filetypes = { ${builtins.concatStringsSep ", " (builtins.map lib.strings.escapeShellArg cfg.ignore_filetypes)} }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    print(vim.bo[bufnr].filetype)
                    return
                end
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
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
}
