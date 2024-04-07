{
    config,
    home-symlink,
    ...
}: {
    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile.nvim = home-symlink { config = config; source = "neovim"; recursive = true; };

    programs.neovim.defaultEditor = true;
}
