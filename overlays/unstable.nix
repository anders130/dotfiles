inputs: final: prev: {
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) system;
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            permittedInsecurePackages = [];
        };
    };
}
