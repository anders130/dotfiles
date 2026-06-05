{inputs, ...}: {
    perSystem = {system, ...}: {
        _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [inputs.nix-lib.overlays.default];
        };
    };
    den.default.nixos = {
        nixpkgs.config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
        };
    };
}
