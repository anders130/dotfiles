inputs: rec {
    allowMissingOverlay = final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    };

    all-channels = final: prev: {
        local = import ../pkgs {
            inherit (prev) system;
            pkgs = final;
        };
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
        };
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        allowMissingOverlay
        all-channels
        inputs.nix-minecraft.overlay
        inputs.nix-xilinx.overlay
        inputs.nur.overlays.default
        inputs.hyprland.overlays.default
    ];
}
