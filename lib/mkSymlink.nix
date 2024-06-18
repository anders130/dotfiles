{
    inputs,
    ...
}: { config, source, recursive ? false, ... }: {
    source = config.lib.file.mkOutOfStoreSymlink "${inputs.self}/${source}";
    recursive = recursive;
}
