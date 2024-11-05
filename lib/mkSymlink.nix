{
    inputs,
    isThinClient,
    lib,
    ...
}: config: {
    source,
    recursive ? false,
    ...
}: let
    path =
        if builtins.typeOf source == "string"
        then source
        else lib.mkRelativePath source;
in {
    inherit recursive;
    source =
        config.lib.file.mkOutOfStoreSymlink
        "${
            if isThinClient
            then inputs.self
            else config.home.homeDirectory
        }/.dotfiles/${path}";
}
