{lib, ...}: currentConfig: path: {
    imports ? [],
    options ? {},
    config ? null,
    name ? null,
    ...
} @ args: let
    p = lib.mkRelativePath path;
    n = if name != null then name
        else let a = lib.splitString "/" p; in builtins.elemAt a (builtins.length a - 1);
    c = if config != null then config else args;

    pathToSet = path: value: let
        parts = lib.splitString "/" path;
        buildSet = parts: acc: lib.foldr (key: acc: {${key} = acc;}) acc parts;
    in
        buildSet parts value;

    opts = pathToSet p ({enable = lib.mkEnableOption n;} // options);

    configPath = pathStr: configObj: let
        parts = lib.splitString "/" pathStr;

        getNestedAttr = parts: obj:
            if builtins.length parts == 0
            then obj
            else getNestedAttr (builtins.tail parts) (builtins.getAttr (builtins.elemAt parts 0) obj);
    in
        getNestedAttr parts configObj;
in {
    inherit imports;
    options = opts;
    config = lib.mkIf (configPath p currentConfig).enable c;
}
