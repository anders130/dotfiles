args: let
    inherit (builtins) attrNames filter listToAttrs map readDir replaceStrings;
in ./.
    |> readDir
    |> attrNames # only get the names of the files
    |> filter (name: name != "default.nix")
    |> map (name: {
        name = replaceStrings [".nix"] [""] name;
        value = import ./${name} args;
    })
    |> listToAttrs
