{
    config,
    lib,
    ...
}: let
    inherit (lib) mkOption naturalSort types;
in {
    options.gitignore = mkOption {
        type = types.listOf types.str;
        apply = naturalSort;
    };
    config = {
        gitignore = ["result"];
        perSystem = {writeLines, ...}: {
            files.files = [
                {
                    path = ".gitignore";
                    drv = writeLines ".gitignore" config.gitignore;
                }
            ];
        };
    };
}
