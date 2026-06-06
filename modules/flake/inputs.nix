{inputs, ...}: {
    imports = [inputs.flake-file.flakeModules.default];

    flake-file.description = "My NixOS Configuration";
    flake-file.inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        flake-file.url = "github:denful/flake-file";
        nix-lib.url = "github:anders130/nix-lib";

        # host specific
        disko.url = "github:nix-community/disko";
        lanzaboote.url = "github:nix-community/lanzaboote";
    };

    perSystem = {
        config,
        lib,
        ...
    }: {
        pre-commit.settings.hooks.write-flake = {
            enable = true;
            name = "write-flake";
            entry = lib.getExe config.packages.write-flake;
            always_run = true;
            pass_filenames = false;
        };
    };
}
