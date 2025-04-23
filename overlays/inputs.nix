inputs: final: prev: {
    inputs = let
        filtered = inputs.nixpkgs.lib.filterAttrs (_: value: value ? packages) inputs;
        mapped = builtins.mapAttrs (name: value: value.packages.${prev.system}) filtered;
    in
        mapped;
}
