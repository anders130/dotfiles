{
    config,
    inputs,
    lib,
    ...
}: {
    imports = [
        inputs.nix-index-database.nixosModules.nix-index
    ];

    options.modules.programs.cli.nix-index = {
        enable = lib.mkEnableOption "nix-index";
    };

    config.programs = lib.mkIf config.modules.console.nix-index.enable {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
        command-not-found.enable = false; # nix-index handles this
    };
}
