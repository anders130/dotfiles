{
    config,
    ...
}: {
    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile.nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
        recursive = true;
    };

    programs.neovim.defaultEditor = true;
}
