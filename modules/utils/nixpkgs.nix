{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./nixpkgs.nix {
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
        };

        overlays = [inputs.self.outputs.overlays.default];
    };

    system.stateVersion = pkgs.lib.trivial.release;
}
