{
    inputs,
    lib,
    ...
}: let
    treefmtConfig = {
        projectRootFile = "flake.nix";
        programs.alejandra = {
            enable = true;
            settings.indentation = "FourSpaces";
        };
    };
in {
    imports = [inputs.treefmt-nix.flakeModule];

    flake-file = {
        inputs.treefmt-nix.url = "github:anders130/treefmt-nix";
        formatter = pkgs: let
            wrapper = inputs.treefmt-nix.lib.mkWrapper pkgs treefmtConfig;
        in
            pkgs.writeShellApplication {
                name = "treefmt-fmt";
                text = "exec ${pkgs.lib.getExe wrapper} --no-cache \"$@\"";
            };
    };
    perSystem = {config, ...}: {
        pre-commit.settings.hooks.treefmt = {
            enable = true;
            pass_filenames = false;
            package = config.formatter;
        };
        treefmt = lib.recursiveUpdate treefmtConfig {
            programs.alejandra.includes = ["parts/*.nix" "parts/**/*.nix"];
        };
    };
}
