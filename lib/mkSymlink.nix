{
    inputs,
    isThinClient,
    lib,
    ...
}: config: path: let
    p = lib.mkRelativePath path;
    recursive = !lib.hasSuffix ".nix" p;
in {
    inherit recursive;
    source =
        config.lib.file.mkOutOfStoreSymlink
        "${
            if isThinClient
            then inputs.self
            else config.home.homeDirectory
        }/.dotfiles/${p}";
}
