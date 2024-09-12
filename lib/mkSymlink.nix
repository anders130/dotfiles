{
    inputs,
    isThinClient,
    ...
}: config: {
    source,
    recursive ? false,
    ...
}: {
    source = config.lib.file.mkOutOfStoreSymlink (
        if isThinClient
        then "${inputs.self}/${source}"
        else "${config.home.homeDirectory}/.dotfiles/${source}"
    );
    inherit recursive;
}
