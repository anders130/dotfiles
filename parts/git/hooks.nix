{inputs, ...}: {
    gitignore = [".pre-commit-config.yaml"];
    flake-file.inputs.git-hooks = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    imports = [inputs.git-hooks.flakeModule];
    perSystem = {
        config,
        system,
        ...
    }: {
        pre-commit.settings.hooks = {
            shellcheck = {
                enable = true;
                excludes = ["\\.envrc"];
            };
            statix = {
                enable = true;
                package = inputs.statix.packages.${system}.statix;
            };
            ripsecrets.enable = true;
        };
        devShells.default = config.pre-commit.devShell;
    };
}
