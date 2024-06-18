{
    config,
    lib,
    ...
}: {
    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile.nvim = lib.mkSymlink {
        config = config;
        source = "neovim";
        recursive = true;
    };

    programs.neovim.defaultEditor = true;
}
