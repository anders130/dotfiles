{lib, ...}: hostConfig: createEnableOption: path: {
    imports ? [],
    options ? {},
    config ? null,
    ...
} @ args: let
    inherit (builtins) elemAt isAttrs length;
    inherit (lib) foldr mkIf removeSuffix splitString;

    pathList = path
        |> lib.mkRelativePath
        |> removeSuffix ".nix"
        |> removeSuffix "/default" # if path is a default.nix, remove it
        |> splitString "/";

    configName = elemAt (length - 1) pathList; # last element of the path

    cfg = lib.foldl' (obj: key: obj.${key}) hostConfig pathList; # get the modules option values from the hostConfig

    adjustConfig = config: config
        |> (c: removeAttrs c ["imports"]);
in {
    imports = imports ++ config.imports or [];
    options = options
        # |> (o: o // {enable = lib.mkEnableOption configName;})
        # |> (o: lib.debug.traceSeq {inherit path;} o)
        |> (o:
            if createEnableOption
            then o // {enable = lib.mkEnableOption configName;}
            else o
        )
        |> (o: foldr (key: acc: {${key} = acc;}) o pathList); # set the value at the path
    config = config
        |> (c: if c != null then c else args) # if config is not set, assume args are the config
        |> (c: if isAttrs c then c else (c cfg)) # if config is a function, call it with cfg
        |> adjustConfig
        |> mkIf cfg.enable; # only enable if cfg.enable is true
}
