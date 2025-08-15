inputs: final: prev: let
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) config system;
    };
in {
    # permanent unstable packages
    inherit
        (unstable)
        comma
        gemini-cli
        # hyprlock
        immich
        jellyseerr
        nextcloud-client
        ;
}
