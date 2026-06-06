{inputs, ...}: {
    gitignore = [".pre-commit-config.yaml"];
    flake-file.inputs.git-hooks = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    imports = [inputs.git-hooks.flakeModule];
    perSystem = {config, ...}: {
        pre-commit.settings.hooks = {
            shellcheck.enable = true;
            statix.enable = true;
            ripsecrets.enable = true;
        };
        devShells.default = config.pre-commit.devShell;
    };
}
