{inputs, ...}: {
    flake.modules.nixos.default = {
        nixpkgs = {
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
            };
            overlays = [inputs.self.outputs.overlays.default];
        };
    };
}
