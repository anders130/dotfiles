inputs: let
    inherit (inputs.nixpkgs.lib) composeManyExtensions filterAttrs;
    inherit (builtins) mapAttrs;
in rec {
    allowMissingOverlay = final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    };

    all-channels = final: prev: {
        inputs = let
            filtered = filterAttrs (_: value: value ? packages) inputs;
            mapped = mapAttrs (name: value: value.packages.${prev.system}) filtered;
        in
            mapped;
        local = inputs.self.packages.${final.system};
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
        };
    };

    evdi = final: prev: {
        linuxPackages_latest =
            prev.linuxPackages_latest.extend
            (lpfinal: lpprev: {
                evdi = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.linuxPackages_latest.evdi;
            });
        displaylink = prev.displaylink.override {
            inherit (final.linuxPackages_latest) evdi;
        };
    };

    default = composeManyExtensions [
        allowMissingOverlay
        all-channels
        evdi
        inputs.nix-minecraft.overlay
        inputs.nur.overlays.default
        inputs.hyprland.overlays.default
        inputs.zenix.overlays.default
    ];
}
