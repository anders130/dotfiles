inputs: final: prev: rec {
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) system;
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            permittedInsecurePackages = [];
        };
    };
    # permanent unstable packages
    inherit
        (unstable)
        comma
        gemini-cli
        hyprlock
        nextcloud-client
        ;
}
