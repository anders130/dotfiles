{
    system,
    pkgs,
}: let
    inherit (builtins) readDir filter map attrNames elemAt split match listToAttrs replaceStrings;

    dir = filter (name: name != "default.nix") (attrNames (readDir ./.));
    stripNixSuffix = name: replaceStrings [".nix"] [""] name;

in listToAttrs (map (name: {
    name = stripNixSuffix name;
    value = pkgs.callPackage ./${name} {};
}) dir)
