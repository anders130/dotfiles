{lib, ...}: hostConfig: path: {
    imports ? [],
    options ? {},
    config ? null,
    name ? null,
    ...
} @ args: let
    relativePath = path
        |> lib.mkRelativePath
        |> lib.removeSuffix ".nix"
        |> lib.removeSuffix "/default"; # if path is a default.nix, remove it

    configName = if name != null then name
        else let a = lib.splitString "/" relativePath; in builtins.elemAt a (builtins.length a - 1);
    configObj = if config != null then config else args;

    pathToSet = path: value: let
        parts = lib.splitString "/" path;
        buildSet = parts: acc: lib.foldr (key: acc: {${key} = acc;}) acc parts;
    in
        buildSet parts value;

    definedOptions = pathToSet relativePath ({enable = lib.mkEnableOption configName;} // options);

    cfg = let
        getFromConfig = pathStr: configObj: let
            parts = lib.splitString "/" pathStr;

            getNestedAttr = parts: obj:
                if builtins.length parts == 0
                then obj
                else getNestedAttr (builtins.tail parts) (builtins.getAttr (builtins.elemAt parts 0) obj);
        in
            getNestedAttr parts configObj;
    in
        getFromConfig relativePath hostConfig;

    resolvedConfig =
        if builtins.typeOf configObj == "lambda"
        then (configObj cfg)
        else configObj;
in {
    inherit imports;
    options = definedOptions;
    config = lib.mkIf cfg.enable resolvedConfig;
}
