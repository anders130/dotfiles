{pkgs, ...}: {
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
            local ignore_filetypes = { "nix" }
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
        formattersByFt = {
            lua = ["stylua"];
            nix = ["alejandra" "convert_indentation"];
            # Conform can also run multiple formatters sequentially
            python = ["isort" "black"];
            rust = ["rustfmt"];
            # You can use a sub-list to tell conform to run *until* a formatter
            # is found.
            # javascript = ["prettierd" "prettier"];
        };
        formatters = {
            alejandra.command = "${pkgs.alejandra}/bin/alejandra";
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

    extraPackages = [pkgs.rustfmt];
}
