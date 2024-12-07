inputs: let
    inherit (builtins) attrNames filter listToAttrs map readDir replaceStrings;
in inputs.nixpkgs.lib.extend (final: prev: ./.
    |> readDir
    |> attrNames
    |> filter (name: name != "default.nix")
    |> map (name: {
        name = replaceStrings [".nix"] [""] name;
        value = import ./${name} {inherit inputs; lib = final;};
    })
    |> listToAttrs
) // inputs.home-manager.lib
