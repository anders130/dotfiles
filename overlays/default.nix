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

    plex-fix = final: prev: {
        plex-desktop = (import inputs.plex-fix {
            config.allowUnfree = true;
            inherit (prev) system;
        }).plex-desktop;
    };

    default = composeManyExtensions [
        allowMissingOverlay
        all-channels
        plex-fix
        inputs.nix-minecraft.overlay
        inputs.nur.overlays.default
        inputs.hyprland.overlays.default
    ];
}
