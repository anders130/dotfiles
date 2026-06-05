{
    config,
    lib,
    ...
}: let
    inherit (lib) concatLines mkOption naturalSort types;
in {
    options.gitignore = mkOption {
        type = types.listOf types.str;
        apply = naturalSort;
    };
    config = {
        gitignore = ["result"];
        perSystem.files.file.".gitignore".text = concatLines config.gitignore;
    };
}
