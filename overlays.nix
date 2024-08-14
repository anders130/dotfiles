inputs: rec {
    allowMissingOverlay = final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    };

    all-channels = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
        };

        local = import ./pkgs {
            inherit (prev) system;
            pkgs = final;
        };
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        allowMissingOverlay
        all-channels
        inputs.nix-minecraft.overlay
    ];
}
