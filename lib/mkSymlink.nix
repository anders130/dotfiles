{
    inputs,
    isThinClient,
    ...
}: config: {
    source,
    recursive ? false,
    ...
}: let
    mkRelativePath = path: let
        inherit (builtins) substring stringLength;
        p = toString path;
        selfStrLen = stringLength inputs.self;
    in
        substring
        (selfStrLen + 1)
        (stringLength p - selfStrLen - 1)
        p;

    path =
        if builtins.typeOf source == "string"
        then source
        else mkRelativePath source;
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
