{
    inputs,
    isThinClient,
    lib,
    ...
}: hmConfig: path: let
    basePath =
        if isThinClient
        then "${inputs.self}"
        else "${hmConfig.home.homeDirectory}/.dotfiles";
in {
    recursive = true; # important for directories but has no effect on files
    source = path
        |> lib.mkRelativePath
        |> (p: "${basePath}/${p}")
        |> hmConfig.lib.file.mkOutOfStoreSymlink;
}
