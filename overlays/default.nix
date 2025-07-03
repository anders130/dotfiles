{inputs, ...}: let
    inherit (inputs.haumea.lib) load;
    inherit (inputs.nixpkgs.lib) composeManyExtensions;
    inherit (builtins) attrValues removeAttrs;

    myOverlays = load {
        src = ./.;
        loader = _: path: import path inputs;
        transformer = _: mod: removeAttrs mod ["default"];
    };
in {
    flake.overlays.default = composeManyExtensions ((attrValues myOverlays)
    ++ (with inputs; [
        nix-minecraft.overlay
        nur.overlays.default
        zenix.overlays.default
    ]));
}
