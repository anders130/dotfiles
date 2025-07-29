inputs: final: prev: rec {
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) config system;
    };
    # permanent unstable packages
    inherit
        (unstable)
        comma
        gemini-cli
        # hyprlock
        immich
        nextcloud-client
        ;
}
