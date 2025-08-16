{inputs, ...}: let
    inherit (inputs.haumea.lib) load;
    inherit (inputs.nixpkgs.lib) composeManyExtensions;
    inherit (builtins) attrValues length removeAttrs;

    myOverlays = load {
        src = ./.;
        loader = _: path: import path inputs;
        transformer = from: to:
            if length from == 0
            then removeAttrs to ["default"]
            else if to ? "default"
            then to.default
            else to;
    };
in {
    flake.overlays.default = composeManyExtensions ((attrValues myOverlays)
    ++ (with inputs; [
        nh.overlays.default
        nix-minecraft.overlay
        nur.overlays.default
        zenix.overlays.default
    ]));
}
