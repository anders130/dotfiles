inputs: final: prev: let
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) config;
        inherit (prev.stdenv.hostPlatform) system;
    };
in {
    # permanent unstable packages
    inherit
        (unstable)
        claude-code
        comma
        devenv
        gemini-cli
        github-copilot-cli
        nextcloud-client
        nh
        proton-ge-bin
        ;
}
