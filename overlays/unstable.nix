inputs: final: prev: let
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) config;
        inherit (prev.stdenv.hostPlatform) system;
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
        nh
        ntfy-sh
        pihole
        pihole-ftl
        pihole-web
        proton-ge-bin
        stash
        ;
}
