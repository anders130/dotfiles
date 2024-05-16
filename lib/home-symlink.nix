{ config, source, recursive ? false, ... }: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${source}";
    recursive = recursive;
}
