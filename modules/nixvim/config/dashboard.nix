{
    pkgs,
    ...
}: {
    plugins = {
        dashboard = {
            enable = true;
            settings = {
                config = {
                    footer = null;
                    header = [
                        "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
                        "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
                        "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
                        "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
                        "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
                        "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
                    ];
                    project = {
                        enable = true;
                        action.__raw = /*lua*/''function(project_path)
                            vim.cmd('cd ' .. project_path)
                            vim.cmd('Neotree')
                            vim.api.nvim_buf_delete(require('dashboard').bufnr, { force = true })
                        end'';
                    };
                };
                theme = "hyper";
            };
        };

        indent-blankline.settings.exclude.filetypes = ["dashboard"];
    };
 
    extraPlugins = with pkgs.vimPlugins; [
        nvim-web-devicons
    ];
}
