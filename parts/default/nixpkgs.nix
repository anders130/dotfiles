{inputs, ...}: {
    perSystem = {system, ...}: {
        _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [inputs.nix-lib.overlays.default];
        };
    };
    flake.modules.nixos.default = {
        nixpkgs.config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
        };
    };
}
