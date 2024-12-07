{inputs, ...}: {
    imports = [inputs.nix-index-database.nixosModules.nix-index];

    programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
        command-not-found.enable = false; # nix-index handles this
    };
}
