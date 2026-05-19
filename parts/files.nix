{
    inputs,
    lib,
    ...
}: {
    flake-file.inputs.files = {
        url = "github:mightyiam/files";
        flake = false;
    };
    imports = [(inputs.files + "/flake-module.nix")];
    perSystem = {
        config,
        pkgs,
        ...
    }: {
        _module.args.writeLines = name: lines:
            pkgs.writeText name (lib.concatLines lines);

        packages.write-files = config.files.writer.drv;

        pre-commit.settings.hooks.write-files = {
            enable = true;
            name = "write-files";
            entry = lib.getExe config.packages.write-files;
            always_run = true;
            pass_filenames = false;
        };
    };
}
