{
    config,
    lib,
    ...
}: {
    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile.nvim = lib.home-symlink { config = config; source = "neovim"; recursive = true; };

    programs.neovim.defaultEditor = true;
}
