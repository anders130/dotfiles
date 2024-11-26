{
    inputs,
    pkgs,
    ...
}: {
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
        };

        overlays = [inputs.self.outputs.overlays.default];
    };

    system.stateVersion = pkgs.lib.trivial.release;
}
