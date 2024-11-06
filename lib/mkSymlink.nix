{
    inputs,
    isThinClient,
    lib,
    ...
}: config: path: let
    p = lib.mkRelativePath path;
in {
    recursive = true; # important for directories but has no effect on files
    source =
        config.lib.file.mkOutOfStoreSymlink
        "${
            if isThinClient
            then inputs.self
            else config.home.homeDirectory
        }/.dotfiles/${p}";
}
