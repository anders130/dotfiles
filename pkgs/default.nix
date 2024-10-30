{pkgs, ...}: let
    inherit (builtins) readDir filter map attrNames listToAttrs replaceStrings;

    dir = filter (name: name != "default.nix") (attrNames (readDir ./.));
    stripNixSuffix = name: replaceStrings [".nix"] [""] name;

in listToAttrs (map (name: {
    name = stripNixSuffix name;
    value = pkgs.callPackage ./${name} {};
}) dir)
