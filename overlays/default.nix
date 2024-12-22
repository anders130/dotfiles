inputs: rec {
    allowMissingOverlay = final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    };

    all-channels = final: prev: {
        local = import ../pkgs {
            inherit (prev) system;
            pkgs = final;
        };
    };

    evdiFix = import ./evdi.nix;

    default = inputs.nixpkgs.lib.composeManyExtensions [
        allowMissingOverlay
        all-channels
        inputs.nix-minecraft.overlay
        inputs.nix-xilinx.overlay
        inputs.nur.overlays.default
        evdiFix
    ];
}
