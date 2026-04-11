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
        devenv
        gemini-cli
        # hyprlock
        nextcloud-client
        nh
        pihole
        pihole-ftl
        pihole-web
        proton-ge-bin
        ;
}
