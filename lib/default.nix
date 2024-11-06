args: let
    inherit (builtins) readDir filter map attrNames listToAttrs replaceStrings;

    dir = filter (name: name != "default.nix") (attrNames (readDir ./.));
    stripNixSuffix = name: replaceStrings [".nix"] [""] name;

    mkImport = path: import path args;

in listToAttrs (map (name: {
    name = stripNixSuffix name;
    value = mkImport ./${name};
}) dir)

