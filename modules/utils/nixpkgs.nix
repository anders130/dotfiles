{
    config,
    inputs,
    lib,
    variables,
    ...
}: lib.mkModule config ./nixpkgs.nix {
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
        };

        overlays = [inputs.self.outputs.overlays.default];
    };

    system.stateVersion = variables.version;
}
