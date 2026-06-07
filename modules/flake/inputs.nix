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
        pkgs,
        ...
    }: {
        pre-commit.settings.hooks.write-flake = {
            enable = true;
            name = "write-flake";
            entry = "${pkgs.writeShellScript "write-flake-hook" ''
                command -v nix > /dev/null 2>&1 || exit 0
                exec ${lib.getExe config.packages.write-flake} "$@"
            ''}";
            always_run = true;
            pass_filenames = false;
        };
    };
}
