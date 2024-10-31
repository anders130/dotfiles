{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.modules.utils.nixpkgs = {
        enable = lib.mkEnableOption "nixpkgs";
    };

    config = lib.mkIf config.modules.utils.nixpkgs.enable {
        nixpkgs = {
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
            };

            overlays = [inputs.self.outputs.overlays.default];
        };

        system.stateVersion = pkgs.lib.trivial.release;
    };
}
