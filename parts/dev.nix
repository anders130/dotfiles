{inputs, ...}: {
    imports = [inputs.pre-commit-hooks.flakeModule];
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
