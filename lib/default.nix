{
    inputs,
    lib,
    system,
    isThinClient,
}: let
    inherit (builtins) readDir filter map attrNames listToAttrs replaceStrings;

    dir = filter (name: name != "default.nix") (attrNames (readDir ./.));
    stripNixSuffix = name: replaceStrings [".nix"] [""] name;

    mkImport = path: import path { inherit inputs lib system isThinClient; };

in listToAttrs (map (name: {
    name = stripNixSuffix name;
    value = mkImport ./${name};
}) dir)

