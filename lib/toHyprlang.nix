{lib}: let
    inherit (builtins) isAttrs isBool toString concatStringsSep genList;
    inherit (lib) mapAttrsToList boolToString;

    generate = n: key: value: let
        indent = concatStringsSep "" (genList (_: "    ") n);
    in
        if isAttrs value
        then let
            inner =
                value
                |> mapAttrsToList (generate (n + 1))
                |> concatStringsSep "\n";
        in ''
            ${indent}${key} {
            ${inner}
            ${indent}}
        ''
        else "${indent}${key} = ${
            if isBool value
            then boolToString value
            else toString value
        }";

    toHyprlang = n: config:
        config
        |> mapAttrsToList (generate n)
        |> concatStringsSep "\n\n";
in
    toHyprlang 0
