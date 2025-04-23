inputs: let
    inherit (inputs.nixpkgs.lib) composeManyExtensions;
    inherit (builtins) attrNames readDir filter;
    overlays = ./.
        |> readDir
        |> attrNames
        |> filter (n: n != "default.nix")
        |> map (n: import "${./.}/${n}" inputs);
in {
    default = composeManyExtensions (overlays ++ [
        inputs.nix-minecraft.overlay
        inputs.nur.overlays.default
        inputs.hyprland.overlays.default
        inputs.zenix.overlays.default
    ]);
}
